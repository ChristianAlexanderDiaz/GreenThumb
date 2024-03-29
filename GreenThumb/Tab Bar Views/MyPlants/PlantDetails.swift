//
//  PlantDetails.swift
//  GreenThumb
//
//  Created by Brian Wood on 4/23/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//  Tutorial by Osman Balci.
//

//view displaying the information about a plant

import SwiftUI

struct PlantDetails: View {

    // Input Parameter
    var plant: Plant

    // Subscribe to changes in Core Data database
    @EnvironmentObject var databaseChange: DatabaseChange

    //---------------
    // Alert Messages
    //---------------
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    var body: some View {
        Form {
            Group {
                // If plant needs watering display warning
                if let nextWatering = plant.nextWateringDate, nextWatering <= Date() {
                    Section(header: Text("Needs Watering Reminder")) {
                        HStack {
                            Spacer()
                            HStack {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(.yellow)
                                Image(systemName: "drop.fill")
                                    .foregroundColor(.blue)
                                Text("Watering Needed")
                                Image(systemName: "drop.fill")
                                    .foregroundColor(.blue)
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(.yellow)
                            }
                            Spacer()
                        }
                    }
                }
                // Plant Names
                if plant.nickname != nil && plant.nickname != "" {
                    Section(header: Text("Plant Nickname")) {
                        Text(plant.nickname ?? "")
                    }
                }
                if plant.common_name != nil && plant.common_name != "" {
                    Section(header: Text("Plant Common Name")) {
                        Text(plant.common_name ?? "")
                    }
                }
                if plant.scientific_name != nil {
                    Section(header: Text("Plant Scientific Name")) {
                        Text(plant.scientific_name?.joined(separator: ", ") ?? "")
                    }
                }
                if plant.other_name != nil {
                    Section(header: Text("Plant Other Name")) {
                        Text(plant.other_name?.joined(separator: ", ") ?? "")
                    }
                }
            }

                // Plant Image
                Section(header: Text("Plant Image")) {
                    if let primaryImage = plant.primaryImage {
                        getImageFromBinaryData(binaryData: primaryImage, defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 300)
                    } else {
                        Image("ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 300)
                    }
                }

            Group {
                Section(header: Text("Plant Location")) {
                    Text(plant.location ?? "Unspecified")
                }
                
                Section(header: Text("Sunlight Requirements")) {
                    Text(plant.sunlight?.joined(separator: ", ") ?? "")
                }
                Section(header: Text("Watering Requirements")) {
                    Text(convertDaysToString(totalDays: plant.watering!))
                }
                
                Section(header: Text("Last Watered")) {
                    if plant.lastWateringDate != nil {
                        Text(wateredDate(date: plant.lastWateringDate!))
                    } else {
                        Text("Unknown")
                    }
                }
            }
            Group {
                if plant.watering_history != nil {
                    Section(header: Text("Plant Watering History")) {
                        NavigationLink(destination: WateringHistoryView(dates: plant.watering_history!)) {
                            Text("Watering History")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                if plant.photos != nil {
                    Section(header: Text("Plant Growth Images")) {
                        NavigationLink(destination: PlantGrowthImages(plant: plant)) {
                            Text("Plant Images")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                if plant.diseaseNotes != nil  && plant.diseaseNotes != ""{
                    Section(header: Text("Plant Notes")) {
                        Text(plant.diseaseNotes!)
                    }
                }
            }
            Section(header: Text("Plant Star")) {
                HStack {
                    Spacer()
                    
                    Button {
                        if plant.starred {
                            unstarPlant(plant: plant)
                        } else {
                            starPlant(plant: plant)
                        }
                        databaseChange.indicator.toggle()
                    } label: {
                        if plant.starred {
                            VStack {
                                Image(systemName: "star.fill")
                                    .tint(.yellow)
                                    .imageScale(.large)
                                    .font(Font.title.weight(.regular))
                                    .frame(width: 60)
                                Text("Remove star?")
                            }
                        } else {
                            Image(systemName: "star")
                                .tint(.yellow)
                                .imageScale(.large)
                                .font(Font.title.weight(.regular))
                                .frame(width: 60)
                            Text("Star plant?")
                        }
                    }
                    
                    Spacer()
                
                }
            }
            Section(header: Text("Plant Diseased")) {
                HStack {
                    Spacer()
                    
                    Button {
                        if plant.diseased {
                            undiseasePlant(plant: plant)
                        } else {
                            diseasePlant(plant: plant)
                        }
                        databaseChange.indicator.toggle()
                    } label: {
                        if plant.diseased {
                            VStack {
                                Image(systemName: "medical.thermometer.fill")
                                    .tint(.green)
                                    .imageScale(.large)
                                    .font(Font.title.weight(.regular))
                                    .frame(width: 60)
                                Text("Plant healthy?")
                            }
                        } else {
                            Image(systemName: "medical.thermometer")
                                .tint(.green)
                                .imageScale(.large)
                                .font(Font.title.weight(.regular))
                                .frame(width: 60)
                            Text("Plant diseased?")
                        }
                    }
                    
                    Spacer()
                
                }
            }
            

        }   // End of Form
        .navigationBarTitle(Text("Plant Details"), displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink(destination: EditPlant(plant: plant)) {
                    Text("Edit")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }.buttonStyle(PlainButtonStyle()))
        .font(.system(size: 14))
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
              Button("OK") {}
            }, message: {
              Text(alertMessage)
            })

    }   // End of body var

    // Convert the watered date to a string
    func wateredDate(date: Date) -> String {
        // Instantiate a DateFormatter object
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full     // Thursday, November 7, 2019

        // Format current date and time as above and convert it to String
        let currentDate = dateFormatter.string(from: date)

        return currentDate
    }

    enum TimeUnit: String, CaseIterable {
        case day = "Days"
        case week = "Weeks"
        case month = "Months"

        var days: Int {
            switch self {
            case .day:
                return 1
            case .week:
                return 7
            case .month:
                return 30
            }
        }
    }

    func convertDaysToString(totalDays: String) -> String {
        guard let totalDaysInt = Int(totalDays) else {
            return "Unspecified"
        }

        var number = 1
        var unit = TimeUnit.day

        if totalDaysInt >= TimeUnit.month.days {
            number = totalDaysInt / TimeUnit.month.days
            unit = .month
        } else if totalDaysInt >= TimeUnit.week.days {
            if totalDaysInt % TimeUnit.week.days == 0 {
                number = totalDaysInt / TimeUnit.week.days
                unit = .week
            } else {
                number = totalDaysInt
                unit = .day
            }
        } else {
            number = totalDaysInt
            unit = .day
        }

        // Adjust the number of days to account for months and weeks
        let daysInUnit = unit.days
        let remainderDays = totalDaysInt % daysInUnit
        if remainderDays == 0 {
            number = totalDaysInt / daysInUnit
        } else if remainderDays <= TimeUnit.week.days {
            number = (totalDaysInt / daysInUnit) * daysInUnit / TimeUnit.week.days
            unit = .week
        } else {
            number = (totalDaysInt / daysInUnit) * daysInUnit / TimeUnit.month.days
            unit = .month
        }

        let numberString = number == 1 ? "" : "\(number) "
        let unitString = number == 1 ? String(unit.rawValue.dropLast()) : unit.rawValue

        return "Every \(numberString)\(unitString)"
    }

}

struct PlantDetails_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let context = PersistenceController.shared.persistentContainer.viewContext
            let plant = try! context.fetch(Plant.allPlantsFetchRequest()).first!
            PlantDetails(plant: plant)
        }
    }
}
