//
//  PlantCareList.swift
//  GreenThumb
//
//  Created by Taylor Adeline Flieg on 4/24/2023.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

/*
 
 */

import SwiftUI

struct PlantCareList: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
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
                    
                    //define database searches somewhere to be done each time the databse is changed
                    //in extension of plant core data class
                    ForEach(WateringPlantCareList) { aPlant in
                        NavigationLink(destination: WateringPlantCareDetails(plant: aPlant)) {
                            WateringPlantCareItem(plant: aPlant)
                        }
                    }
                case 1:
                    // contains only those plants which are marked as diseased by the user
                    
                    ForEach(DiseasedPlantCareList) { aPlant in
                        NavigationLink(destination: DiseasedPlantCareDetails(plant: aPlant)) {
                            DiseasedPlantCareItem(plant: aPlant)
                        }
                    }
                case 2:
                    // contains only those plants which are starred by the user
                    
                    ForEach(StarredPlantCareList) { aPlant in
                        NavigationLink(destination: StarredPlantCareDetails(plant: aPlant)) {
                            StarredPlantCareItem(plant: aPlant)
                        }
                    }
                default:
                    fatalError("Sort type is out of range!")
                }

                
            }   // End of List
        }
            .navigationBarTitle(Text("Plant Care List"), displayMode: .inline)
            

        }   // End of NavigationView
            .customNavigationViewStyle()  // Given in NavigationStyle.swift
    }
    
}

struct PlantCareList_Previews: PreviewProvider {
    static var previews: some View {
        PlantCareList()
    }
}
