//
//  MyPlants.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//  Tutorial by Osman Balci.
//

//view listing the user's plants, sorted by which location they are associated with

import SwiftUI

struct MyPlants: View {
        
    // ❎ Core Data managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ❎ Core Data FetchRequest returning all Plant entities from the database
    @FetchRequest(fetchRequest: Plant.allPlantsFetchRequest()) var allPlants: FetchedResults<Plant>
    
    // Subscribe to changes in Core Data database
    @EnvironmentObject var databaseChange: DatabaseChange
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
        
    @State private var selectedSortIndex = 0
    @State private var plantLocationList: [String] = [""]
        
    var body: some View {
        NavigationView {
            VStack{
                Picker("", selection: $selectedSortIndex) {
                    ForEach(0 ..< plantLocationList.count, id: \.self) { index in
                        Text(plantLocationList[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                List {
                    ForEach(getPlantsForLocation(plantLocationList[selectedSortIndex])) { aPlant in
                        NavigationLink(destination: PlantDetails(plant: aPlant)) {
                            PlantItem(plant: aPlant)
                        }
                        .alert(isPresented: $showConfirmation) {
                            Alert(title: Text("Delete Confirmation"),
                                  message: Text("Are you sure to permanently delete this plant? It cannot be undone."),
                                  primaryButton: .destructive(Text("Delete")) {
                                    if let index = toBeDeleted?.first {
                                        let plantToDelete = allPlants[index]
                                        // ❎ Delete Selected Plant entity from the database
                                        managedObjectContext.delete(plantToDelete)

                                        // ❎ Save Changes to Core Data Database
                                        do {
                                            try managedObjectContext.save()
                                        } catch {
                                            print("Error saving managed object context: \(error)")
                                        }
                                                                
                                        // Toggle database change indicator so that its subscribers can refresh their views
                                        databaseChange.indicator.toggle()
                                    }
                                    toBeDeleted = nil
                                }, secondaryButton: .cancel() {
                                    toBeDeleted = nil
                                }
                            )
                        }
                    }
                    .onDelete(perform: { indexSet in
                        toBeDeleted = indexSet
                        showConfirmation = true
                    })
                    .onMove(perform: move)
                }   // End of List
                .onAppear {
                    plantLocationList = generateLocationsList()
                }
                .navigationBarTitle(Text("\(plantLocationList[selectedSortIndex]) Plants"), displayMode: .inline)
                // Place the Edit button on left and Add (+) button on right of the navigation bar
                .navigationBarItems(leading: EditButton(), trailing:
                                        NavigationLink(destination: AddPlant()) {
                    Image(systemName: "plus")
                })
                
            }
        }   // End of NavigationView
            .customNavigationViewStyle()  // Given in NavigationStyle.swift
    }
    
    /*
     ---------------------------
     MARK: Delete Selected Plant
     ---------------------------
     */
    func delete(at offsets: IndexSet) {
        
        toBeDeleted = offsets
        showConfirmation = true

    }
        
        /*
         -------------------------
         MARK: Move Selected Photo
         -------------------------
         */
        func move(from source: IndexSet, to destination: Int) {
            
            
            // Create an array of Album entities from allMusicAlbums fetched from the database
            var arrayOfAllPlants: [Plant] = allPlants.map{ $0 }

            // ❎ Perform the move operation on the array
            arrayOfAllPlants.move(fromOffsets: source, toOffset: destination )

            /*
             'stride' returns a sequence from a starting value toward, and possibly including,
             an end value, stepping by the specified amount.
             
             Update the orderNumber attribute in reverse order starting from the end toward the first.
             */
            for index in stride(from: arrayOfAllPlants.count - 1, through: 0, by: -1) {
                
                arrayOfAllPlants[index].id = Int32(index) as NSNumber
            }
            
            // ❎ Save Changes to Core Data Database
            PersistenceController.shared.saveContext()
            
            // Toggle database change indicator so that its subscribers can refresh their views
            databaseChange.indicator.toggle()
        
        }
    
    /*
     ---------------------------
     MARK: Generate plant location list
     ---------------------------
     */
    func generateLocationsList() -> [String]{
        var locs = ["All"]
        
        for aPlant in allPlants {
            let plantLoc = aPlant.location ?? ""
            
            if plantLoc != "" { // If plant has a location
                var newLoc = true // Start flagged as new location until duplicate found
                for loc in locs { // Search all saved locations to find duplicate
                    if loc == plantLoc {
                        newLoc = false // If plant location is duplicate than dont add
                    }
                }
                
                if newLoc && plantLoc != "" {
                    locs.append(plantLoc)
                }
            }
        }
        
        return locs
    }
    
    /*
     ---------------------------
     MARK: Get plants for location
     ---------------------------
     */
    func getPlantsForLocation(_ location: String) -> [Plant] {
        let fetchRequest = Plant.plantsInGivenLocFetchRequest(location: location)
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
}
struct MyPlants_Previews: PreviewProvider {
    static var previews: some View {
        MyPlants()
    }
}
