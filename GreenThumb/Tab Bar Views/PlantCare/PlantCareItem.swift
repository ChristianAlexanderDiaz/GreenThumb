//
//  PlantCareItem.swift
//  GreenThumb
//
//  Created by Taylor Flieg on 4/24/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct WateringPlantCareItem: View {
    // Input Parameter
    let plant: Plant
    
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        HStack {
            getImageFromBinaryData(binaryData: plant.primaryImage!, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
            VStack(alignment: .leading) {
                Text(plant.common_name ?? "error")
                Text("Watering")
            }
            .font(.system(size: 14))
        }
    }
    
}

struct DiseasedPlantCareItem: View {
    // Input Parameter
    let plant: Plant
    
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        HStack {
            getImageFromBinaryData(binaryData: plant.primaryImage!, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
            VStack(alignment: .leading) {
                Text(plant.common_name ?? "error")
                Text("Diseased")
            }
            .font(.system(size: 14))
        }
    }
    
}

struct StarredPlantCareItem: View {
    // Input Parameter
    let plant: Plant
    
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        HStack {
            getImageFromBinaryData(binaryData: plant.primaryImage!, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
            VStack(alignment: .leading) {
                Text(plant.common_name ?? "error")
                Text("Starred")
            }
            .font(.system(size: 14))
        }
    }
    
}
