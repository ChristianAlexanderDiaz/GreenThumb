//
//  PlantItem.swift
//  GreenThumb
//
//  Created by Brian Wood on 4/23/23.
//  Edited by Taylor Flieg on 5/02/23.
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
            if plant.primaryImage != nil {
                getImageFromBinaryData(binaryData: plant.primaryImage!, defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80.0)
            }
            VStack(alignment: .leading) {
                if plant.nickname != nil && plant.nickname != "" {
                    HStack {
                        if let nextWatering = plant.nextWateringDate, nextWatering <= Date() {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.blue)
                        }
                        Text(plant.nickname ?? "")
                    }
                    Text(plant.common_name ?? "")
                }
                else {
                    HStack {
                        if let nextWatering = plant.nextWateringDate, nextWatering <= Date() {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.blue)
                        }
                        Text(plant.common_name ?? "")
                    }
                    if plant.scientific_name != nil {
                        Text(plant.scientific_name?.joined(separator: ", ") ?? "")
                    }
                }

                HStack{
                    Image(systemName: "oilcan.fill")
                        .foregroundColor(.gray)
                    if plant.lastWateringDate != nil {
                        Text(wateredDate(date: plant.lastWateringDate!))
                    } else {
                        Text("Unknown")
                    }
                }
            }
            // Set font and size for the whole VStack content
            .font(.system(size: 14))

        }   // End of HStack
    }

    // Calculate the last watered date and return as string
    func wateredDate(date: Date?) -> String {
        guard let date = date else {
            return "Unknown"
        }

        let calendar = Calendar.current
        let now = Date()

        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if calendar.isDate(date, equalTo: now, toGranularity: .day) {
            return "Today"
        } else {
            let components = calendar.dateComponents([.day], from: date, to: now)
            let days = components.day ?? 0
            if days >= 30 {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd"
                if calendar.component(.year, from: date) < calendar.component(.year, from: now) {
                    formatter.dateFormat = "MM/dd/yy"
                }
                return formatter.string(from: date)
            } else {
                return "\(days) Days Ago"
            }
        }
    }



}
