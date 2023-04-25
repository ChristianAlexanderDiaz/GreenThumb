//
//  ExploreApiResultDetails.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct ExploreApiResultDetails: View {
    let plant: PlantAPIStruct

    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(fetchRequest: Plant.allPlantsFetchRequest()) var allPlants: FetchedResults<Plant>
    @EnvironmentObject var databaseChange: DatabaseChange

    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    var body: some View {
        Form {
            Group {
                Section(header: Text("Plant Name")) {
                    Text(plant.common_name)
                }
                Section(header: Text("Plant Image")) {
                    getImageFromUrl(url: plant.thumbnail, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80.0)
                }
                Section(header: Text("Sunlight Requirements")) {
                    Text((plant.sunlight.joined(separator: ", ")))
                }
                Section(header: Text("Cycle")) {
                    Text(plant.cycle)
                }
                Section(header: Text("Watering")) {
                    Text(plant.watering)
                }
            }
            Section(header: Text("Scientific Names")) {
                Text((plant.scientific_name.joined(separator: ", ")))
            }

            Section(header: Text("Other Names")) {
                Text((plant.other_name.joined(separator: ", ")))
            }
            
            if !plant.attracts.isEmpty {
                Section(header: Text("Attracts")) {
                    Text((plant.attracts.joined(separator: ", ")))
                }
            }
            
            Section(header: Text("Type")) {
                Text(plant.type)
            }
            Section(header: Text("Dimension")) {
                Text(plant.dimension)
            }
            
            Section(header: Text("Indoor")) {
                Text(String(plant.indoor))
            }
        }
        .navigationBarTitle(Text("Plant API Details"), displayMode: .inline)
        .font(.system(size: 14))
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
              Button("OK") {}
            }, message: {
              Text(alertMessage)
            })
    }
}
