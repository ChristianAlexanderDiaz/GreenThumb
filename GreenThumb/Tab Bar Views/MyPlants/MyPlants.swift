//
//  MyPlants.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

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
    var sortTypes = ["Bedroom", "Living Room", "Outside", "All"]
        
    var body: some View {
            NavigationView {
                VStack{
                    Picker("", selection: $selectedSortIndex) {
                        ForEach(0 ..< sortTypes.count, id: \.self) { index in
                            Text(sortTypes[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    List {
                        if selectedSortIndex == 0 {
                            ForEach(allPlants) { aPlant in
                                NavigationLink(destination: PlantDetails(plant: aPlant)) {
                                    PlantItem(plant: aPlant)
                                        .alert(isPresented: $showConfirmation) {
                                            Alert(title: Text("Delete Confirmation"),
                                                  message: Text("Are you sure to permanently delete this plant? It cannot be undone."),
                                                  primaryButton: .destructive(Text("Delete")) {
                                                if let index = toBeDeleted?.first {
                                                    let plantToDelete = allPlants[index]
                                                    // ❎ Delete Selected Plant entity from the database
                                                    managedObjectContext.delete(plantToDelete)

                                                    // ❎ Save Changes to Core Data Database
                                                    PersistenceController.shared.saveContext()
                                                    
                                                    // Toggle database change indicator so that its subscribers can refresh their views
                                                    databaseChange.indicator.toggle()
                                                }
                                                toBeDeleted = nil
                                            }, secondaryButton: .cancel() {
                                                toBeDeleted = nil
                                            }
                                        )
                                    }   // End of alert
                                }
                            }
                            .onDelete(perform: delete)
                            .onMove(perform: move)
                        }
                        
                    }   // End of List
                    .navigationBarTitle(Text("My Plants"), displayMode: .inline)
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
            
//            userData.plantsList.move(fromOffsets: source, toOffset: destination)
            
            // Set the global variable point to the changed list
//            plantStructList = userData.plantsList
            
            // Set global flag defined in otesData
//            plantDataChanged = true
        }
    }
struct MyPlants_Previews: PreviewProvider {
    static var previews: some View {
        MyPlants()
    }
}
