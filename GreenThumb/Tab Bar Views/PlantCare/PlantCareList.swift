//
//  PlantCareList.swift
//  GreenThumb
//
//  Created by Taylor Adeline Flieg on 4/24/2023.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//  Tutorial by Osman Balci.
//

/*
 Will allow the user to view various care tasks for their plants and perform special actions for each task.
 */

import SwiftUI

struct PlantCareList: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    //fetch requests for the various lists
    @FetchRequest(fetchRequest: Plant.wateringNeedsFetchRequest()) var WateringPlantCareList: FetchedResults<Plant>
    @FetchRequest(fetchRequest: Plant.diseasedNeedsFetchRequest()) var DiseasedPlantCareList: FetchedResults<Plant>
    @FetchRequest(fetchRequest: Plant.starredNeedsFetchRequest()) var StarredPlantCareList: FetchedResults<Plant>
    
    @EnvironmentObject var databaseChange: DatabaseChange
    
    @State private var selectedSortTypeIndex = 0
    var sortTypes = ["Needs Watering", "Diseased", "Starred"]
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Sorting", selection: $selectedSortTypeIndex) {
                    ForEach(0 ..< sortTypes.count, id: \.self) {
                        Text(sortTypes[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    switch selectedSortTypeIndex {
                    case 0:
                        // contains only those plants who are past due for watering, or need watering today
                        ForEach(WateringPlantCareList) { aPlant in
                            NavigationLink(destination: PlantDetails(plant: aPlant)) {
                                WateringPlantCareItem(plant: aPlant)
                            }
                        }
                    case 1:
                        // contains only those plants which are marked as diseased by the user
                        ForEach(DiseasedPlantCareList) { aPlant in
                            NavigationLink(destination: PlantDetails(plant: aPlant)) {
                                DiseasedPlantCareItem(plant: aPlant)
                            }
                        }
                    case 2:
                        // contains only those plants which are starred by the user
                        ForEach(StarredPlantCareList) { aPlant in
                            NavigationLink(destination: PlantDetails(plant: aPlant)) {
                                StarredPlantCareItem(plant: aPlant)
                            }
                        }
                    default:
                        fatalError("Sort type is out of range!")
                    }
                }
            }
            .navigationBarTitle(Text("Plant Care List"), displayMode: .inline)
        }
        .customNavigationViewStyle()
    }
}

struct PlantCareList_Previews: PreviewProvider {
    static var previews: some View {
        PlantCareList()
    }
}
