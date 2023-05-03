//
//  ExploreApiResultDetails.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

/**
    A struct called `ExploreApiResultDetails` that conforms to `View` which gives all the Details from what the API has.
 */
struct ExploreApiResultDetails: View {
    // A PlantAPIStruct object representing the found plant to display
    let plant: PlantAPIStruct

    // Environment variables
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext

    // Fetching the request to retrieve all plants from Core Data
    @FetchRequest(fetchRequest: Plant.allPlantsFetchRequest()) var allPlants: FetchedResults<Plant>
    
    // Environemnt object that detects changes to the Core Data database to update values
    @EnvironmentObject var databaseChange: DatabaseChange

    // Alert Messages
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    var body: some View {
        Form {
            Group {
                // A Section displaying the plant's common name
                Section(header: Text("Plant Common Name")) {
                    Text(capitalizeFirstLetter(of: plant.common_name))
                }
                // A seciton displaying the plant's scientific name
                Section(header: Text("Plant Scientific Name")) {
                    Text((plant.scientific_name.joined(separator: ", ")))
                }
                // A section displaying the plant's other names, if they exist.
                if !plant.other_name.isEmpty {
                    Section(header: Text("Other Names")) {
                        Text((plant.other_name.joined(separator: ", ")))
                    }
                }
                // A section displaying the plant's thumbnail image
                Section(header: Text("Plant Image")) {
                    getImageFromUrl(url: plant.thumbnail, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 300)
                }
                // A section for adding the selected plant to My Plants
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
                // A section displaying whether the plant is meant for indoor or outdoor growing
                Section(header: Text("Plant Location")) {
                    Text(plantLocationString(from: plant.indoor))
                }
                // A section displaying the plant's sunlight requirements
                Section(header: Text("Sunlight Requirements")) {
                    Text((plant.sunlight.joined(separator: ", ")))
                }
                // A section displaying the plant's watering needs
                Section(header: Text("Watering")) {
                    Text(capitalizeFirstLetter(of: plant.watering))
                }
                // A section displaying the plant's cycle (annual, biennial, perennial)
                Section(header: Text("Cycle")) {
                    Text(capitalizeFirstLetter(of: plant.cycle))
                }
            }
            
            // A section displaying what animals are attracted to this plant, if they exist.
            if !plant.attracts.isEmpty {
                Section(header: Text("Attracts")) {
                    Text((plant.attracts.joined(separator: ", ")))
                }
            }
            // A section that includes the Type of Plant, the footer will give you the possibilities.
            Section(header: Text("Type of Plant"), footer: Text("Includes: Herbs, Shrubs, Trees, Climbers, Creepers")) {
                Text(capitalizeFirstLetter(of: plant.type))
            }
            // A section that includes the size of the plant.
            Section(header: Text("Dimension for Plant")) {
                Text(plant.dimension)
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
        A function called `capitalizeFirstLetter` that takes a String as input and returns the same string with the first letter capitalized. If the string is empty, it will return itself.
     */
    func capitalizeFirstLetter(of string: String) -> String {
        // Check if the string is empty
        guard !string.isEmpty else { return string }
        // Capitalize the first letter of the string and return the modified string
        return string.prefix(1).capitalized + string.dropFirst()
    }
    
    /**
        A function called `plantLocationString` that takes a Boolean as input and returns a String. For example, if the value is true, it will show as "Indoors", vice versa.
     */
    func plantLocationString(from indoor: Bool) -> String {
        return indoor ? "Indoors" : "Outdoors"
    }
    
    /**
        A function called `calculateWateringDays` that takes a String as input and returns the corresponding number of days for watering the plant as a String.
     */
    func calculateWateringDays(watering: String) -> String {
        switch watering {
        case "Frequent":
            return "4"
        case "Average":
            return "8"
        case "Minimal":
            return "14"
        case "None":
            return "30"
        default:
            return "7"
        }
    }
    
    /**
        A function called `savePlantsToDatabaseAsFavorite` that saves the individual plant that we are looking at and saves that on the database.
     */
    func savePlantsToDatabaseAsFavorite() {
        let plantEntity = Plant(context: managedObjectContext)
        
        plantEntity.id = (allPlants.count + 1) as NSNumber
        plantEntity.common_name = plant.common_name
        plantEntity.scientific_name = plant.scientific_name
        plantEntity.other_name = plant.other_name
        plantEntity.cycle = plant.cycle
        
        //contains a function to calculate the watering days from stirng -> string
        plantEntity.watering = calculateWateringDays(watering: plant.watering)
        
        plantEntity.sunlight = plant.sunlight
        
        // Fetch Image Data
        plantEntity.primaryImage = getUIImageFromUrl(url: plant.thumbnail, defaultFilename: "ImageUnavailable").jpegData(compressionQuality: 1.0)
        
        // 3️⃣ It has no relationship to another Entity
        //todo - make!
        PersistenceController.shared.saveContext()
        
        databaseChange.indicator.toggle()
    }
}
