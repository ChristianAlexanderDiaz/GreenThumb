//
//  PlantCareItem.swift
//  GreenThumb
//
//  Created by Taylor Flieg on 4/24/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

let tempDate = Date()


//view representing a plant which needs or is overdue for watering. Contains key information about the plant in regards to watering and allows the user to mark the plant as watered
struct WateringPlantCareItem: View {
    // Input Parameter
    let plant: Plant
    
    @State private var toBeWatered: Plant?
    @State private var showConfirmation = false
    
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if plant.primaryImage != nil {
                    getImageFromBinaryData(binaryData: plant.primaryImage!, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80.0)
                }
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
                
                //button to mark plant as watered will ask user to confirm (since it will remove from list)
                Button("Watered?") {
                    toBeWatered = plant
                    showConfirmation = true
                }
                //styling for the button
                .tint(.blue)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
        }
        .alert(Text("Water Confirmation"), isPresented: $showConfirmation, actions: {
            Button("Yes") {
                waterPlant(plant: toBeWatered ?? Plant())
                toBeWatered = nil
            }
            Button("No") {
                toBeWatered = nil
            }
        }, message: {
            Text("Do you want to mark this plant as watered?")
        })

    }
    
}

//view representing a plant which is currently marked as diseased. Contains key information about the plant in regards to the diseased status and allows the user to mark the plant as healthy
struct DiseasedPlantCareItem: View {
    // Input Parameter
    let plant: Plant
    
    @State private var toBeHealthy: Plant?
    @State private var showConfirmation = false
    
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if plant.primaryImage != nil {
                    getImageFromBinaryData(binaryData: plant.primaryImage!, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80.0)
                }
                VStack(alignment: .leading) {
                    if plant.nickname != "" {
                        Text(plant.nickname ?? "")
                    }
                    Text(plant.common_name ?? "")
                }
                .font(.system(size: 14))
            }
            
            HStack {
                Text("Diseased since \(formatDate(date: plant.diseasedDate ?? tempDate))")
                    .font(.system(size: 14))
                    
                Spacer()
                
                //button to mark plant as healthy will ask user to confirm (since it will remove from list)
                Button("Healthy?") {
                    toBeHealthy = plant
                    showConfirmation = true
                }
                //styling for the button
                .tint(.green)
                .foregroundColor(.green)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
        }
        .alert(Text("Healthy Confirmation"), isPresented: $showConfirmation, actions: {
            Button("Yes") {
                undiseasePlant(plant: toBeHealthy ?? Plant())
                toBeHealthy = nil
            }
            Button("No") {
                toBeHealthy = nil
            }
        }, message: {
            Text("Do you want to mark this plant as healthy?")
        })
    }
    
}

//view representing a plant which is currently starred. Contains key information about the plant in regards to the starred status and allows the user to un-star the plant
struct StarredPlantCareItem: View {
    // Input Parameter
    let plant: Plant
    
    @State private var toUnStar: Plant?
    @State private var showConfirmation = false
    
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if plant.primaryImage != nil {
                    getImageFromBinaryData(binaryData: plant.primaryImage!, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80.0)
                }
                VStack(alignment: .leading) {
                    if plant.nickname != "" {
                        Text(plant.nickname ?? "")
                    }
                    Text(plant.common_name ?? "")
                }
                .font(.system(size: 14))
            }
            HStack {
                Text("Starred since \(formatDate(date: plant.starredDate ?? tempDate))")
                    .font(.system(size: 14))
                    
                Spacer()
                
                //button to un-star will ask user to confirm (since it will remove from list)
                Button("Remove Star?") {
                    toUnStar = plant
                    showConfirmation = true
                }
                //styling for the button
                .tint(.yellow)
                .foregroundColor(.yellow)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
        }
        .alert(Text("Un-Star Confirmation"), isPresented: $showConfirmation, actions: {
            Button("Yes") {
                unstarPlant(plant: toUnStar ?? Plant())
                toUnStar = nil
            }
            Button("No") {
                toUnStar = nil
            }
        }, message: {
            Text("Do you want to remove this plant's star?")
        })
    }
    
}


