//
//  PlantCareItem.swift
//  GreenThumb
//
//  Created by Taylor Flieg on 4/24/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

let tempDate = Date()

struct WateringPlantCareItem: View {
    // Input Parameter
    let plant: Plant
    
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                getImageFromBinaryData(binaryData: plant.primaryImage!, defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80.0)
                VStack(alignment: .leading) {
                    if plant.nickname != "" {
                        Text(plant.nickname ?? "")
                    }
                    Text(plant.common_name ?? "")
                }
                .font(.system(size: 14))
            }
            
            HStack {
                Text("Needs Watering \(formatDate(date: plant.nextWateringDate ?? tempDate))")
                    .font(.system(size: 14))
                    
                Spacer()
                
                Button("Watered?") {
                    waterPlant(plant: plant)
                }
                //styling for the button
                .tint(.blue)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
        }
    }
    
}

struct DiseasedPlantCareItem: View {
    // Input Parameter
    let plant: Plant
    
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                getImageFromBinaryData(binaryData: plant.primaryImage!, defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80.0)
                VStack(alignment: .leading) {
                    if plant.nickname != "" {
                        Text(plant.nickname ?? "")
                    }
                    Text(plant.common_name ?? "")
                }
                .font(.system(size: 14))
            }
            
            HStack {
                //TODO
                //Text("Diseased since \(formatDate(date: plant.diseasedDate ?? tempDate))")
                    //.font(.system(size: 14))
                    
                Spacer()
                
                Button("Healthy?") {
                    undiseasePlant(plant: plant)
                }
                //styling for the button
                .tint(.green)
                .foregroundColor(.green)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
        }
    }
    
}

struct StarredPlantCareItem: View {
    // Input Parameter
    let plant: Plant
    
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                getImageFromBinaryData(binaryData: plant.primaryImage!, defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80.0)
                VStack(alignment: .leading) {
                    if plant.nickname != "" {
                        Text(plant.nickname ?? "")
                    }
                    Text(plant.common_name ?? "")
                }
                .font(.system(size: 14))
            }
            HStack {
                //Text("Starred since \(formatDate(date: plant.starredDate ?? tempDate))")
                    //.font(.system(size: 14))
                    
                Spacer()
                
                Button("Remove Star?") {
                    unstarPlant(plant: plant)
                }
                //styling for the button
                .tint(.yellow)
                .foregroundColor(.yellow)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
        }
    }
    
}

func formatDate(date: Date) -> String {
    // Instantiate a DateFormatter object
    let dateFormatter = DateFormatter()
    
    // Set the date format to dd/MM/yyy
    dateFormatter.dateFormat = "dd/MM/yyy"
    
    // Obtain DatePicker's selected date, format it as dd/MM/yyy, and return it as a String
    return dateFormatter.string(from: date)
}
