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
                    Text(capitalizeFirstLetter(of: plant.common_name))
                }
                Section(header: Text("Plant Image")) {
                    getImageFromUrl(url: plant.thumbnail, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 300)
                }
                Section(header: Text("Sunlight Requirements")) {
                    Text((plant.sunlight.joined(separator: ", ")))
                }
                Section(header: Text("Add Plant To My Plant Tab")) {
                    Button(action: {
                        savePlantsToDatabaseAsFavorite()
                        
                        showAlertMessage = true
                        alertTitle = "Plant Added!"
                        alertMessage = "Selected Plant is added to your My Plants Tab."
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Add Plant to My Plants")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
                Section(header: Text("Cycle")) {
                    Text(capitalizeFirstLetter(of: plant.cycle))
                }
                Section(header: Text("Watering")) {
                    Text(capitalizeFirstLetter(of: plant.watering))
                }
            }
            Section(header: Text("Scientific Names")) {
                Text((plant.scientific_name.joined(separator: ", ")))
            }

            if !plant.other_name.isEmpty {
                Section(header: Text("Other Names")) {
                    Text((plant.other_name.joined(separator: ", ")))
                }
            }
            
            if !plant.attracts.isEmpty {
                Section(header: Text("Attracts")) {
                    Text((plant.attracts.joined(separator: ", ")))
                }
            }
            
            Section(header: Text("Type of Plant"), footer: Text("Includes: Herbs, Shrubs, Trees, Climbers, Creepers")) {
                Text(capitalizeFirstLetter(of: plant.type))
            }
            Section(header: Text("Dimension for Plant")) {
                Text(plant.dimension)
            }
            Section(header: Text("Preferred Location")) {
                Text(plantLocationString(from: plant.indoor))
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
    
    /**
        A function called `capitalizeFirstLetter` of a function that is a String and returns the String with the first letter being capitalized. If in the extreme case, it's an empty string, it will return itself.
     */
    func capitalizeFirstLetter(of string: String) -> String {
        //the extreme case the string is empty for some reason
        guard !string.isEmpty else { return string }
        return string.prefix(1).capitalized + string.dropFirst()
    }
    
    func plantLocationString(from indoor: Bool) -> String {
        return indoor ? "Keep the plant inside." : "Leave the plant outside."
    }
    
    func savePlantsToDatabaseAsFavorite() {
        let plantEntity = Plant(context: managedObjectContext)
        
        plantEntity.id = (allPlants.count + 1) as NSNumber
        plantEntity.common_name = plant.common_name
        plantEntity.scientific_name = plant.scientific_name
        plantEntity.other_name = plant.other_name
        plantEntity.cycle = plant.cycle
        
        if plant.watering == "Frequent" {
            plantEntity.watering = "4"
        } else if plant.watering == "Average" {
            plantEntity.watering = "8"
        } else if plant.watering == "Minimal" {
            plantEntity.watering = "14"
        } else if plant.watering == "None" {
            plantEntity.watering = "30"
        } else {
            plantEntity.watering = "7"
        }
        
        plantEntity.sunlight = plant.sunlight
        
        //NEED TO CHANGE CORE DATA IF THEY NEED THESE
//        plantEntity.type = plant.type
//        plantEntity.dimension = plant.dimension
//        plantEntity.indoor = plant.indoor
        
        // Fetch Image Data
        plantEntity.primaryImage = getUIImageFromUrl(url: plant.thumbnail, defaultFilename: "ImageUnavailable").jpegData(compressionQuality: 1.0)
        
        // 3️⃣ It has no relationship to another Entity
        //todo - make!
        PersistenceController.shared.saveContext()
    }
}
