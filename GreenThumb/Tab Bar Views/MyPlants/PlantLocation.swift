//
//  PlantLocation.swift
//  GreenThumb
//
//  Created by Brian Wood on 4/24/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct PlantLocation: View {
    
    // ❎ Core Data managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    // ❎ Core Data FetchRequest returning all Video entities from the database
    @FetchRequest(fetchRequest: Plant.allPlantsFetchRequest()) var allPlants: FetchedResults<Plant>
    
    @State private var location = ""
    
    @State private var plantLocationList = ["Outdoors"]
    @State private var selectedLocationIndex = 0
    
    var body: some View {
        
        Form {
            Section(header: Text("Plant Location")) {
                Picker("", selection: $selectedLocationIndex) {
                    ForEach(0 ..< plantLocationList.count, id: \.self) {
                        Text(plantLocationList[$0])
                    }
                    onAppear {
                        plantLocationList = generateLocationsList()
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                
                TextField("Plant Location", text: $location)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
            }
        } // End of Form
    }
    
    func generateLocationsList() -> [String]{
        var locs = ["Outdoors", "Add New Location"]
        
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
}

struct PlantLocation_Previews: PreviewProvider {
    static var previews: some View {
        PlantLocation()
    }
}
