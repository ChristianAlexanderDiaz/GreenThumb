//
//  PlantItem.swift
//  GreenThumb
//
//  Created by Brian Wood on 4/23/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct PlantItem: View {
    
    // ✳️ Input parameter: Core Data Plant Entity instance reference
    let plant: Plant
    
    // Subscribe to changes in Core Data database
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        HStack {
//            if plant.thumbnail != "" {
//                getImageFromUrl(url: "\(plant.thumbnail ?? "")", defaultFilename: "ImageUnavailable")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 80.0)
//            }
//            else{
//                getImageFromDocumentDirectory(filename: plant.user_photo_name ?? "",
//                                              fileExtension: "jpg",
//                                              defaultFilename: "ImageUnavailable")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(maxWidth: 100, alignment: .center)
//            }
            getImageFromBinaryData(binaryData: plant.primaryImage!, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
            
            
            VStack(alignment: .leading) {
                Text(plant.common_name ?? "")

                Text(plant.scientific_name?[0] ?? "")
                
//                Text(plant.sunlight?[0] ?? "")
//                Text(plant.watering ?? "")
                
                Text("Watered: " + wateredDate(date: plant.lastWateringDate!))
            }
            // Set font and size for the whole VStack content
            .font(.system(size: 14))
            
        }   // End of HStack
    }
    
    func wateredDate(date: Date) -> String {
        // Instantiate a DateFormatter object
        let dateFormatter = DateFormatter()
        // Set the date format to yyyy-MM-dd at HH:mm:ss
        dateFormatter.dateFormat = "MM/dd/yy"
        // Format current date and time as above and convert it to String
        let currentDate = dateFormatter.string(from: date)
        
        return currentDate
    }
}
