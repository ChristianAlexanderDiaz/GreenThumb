//
//  PlantDetails.swift
//  GreenThumb
//
//  Created by Brian Wood on 4/23/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct PlantDetails: View {
    
    // Input Parameter
    let plant: Plant
    
    //---------------
    // Alert Messages
    //---------------
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        Form {
            Group {
                // Plant Names
                Section(header: Text("Plant Name")) {
                    Text(plant.common_name ?? "")
                }
                
                // Plant Image
                Section(header: Text("Plant Image")) {
                    getImageFromBinaryData(binaryData: plant.primaryImage!, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80.0)
                }
                
                Section(header: Text("Plant Location")) {
                    Text(plant.location ?? "Unspecified")
                }
                
                Section(header: Text("Sunlight Requirements")) {
                    Text(plant.sunlight?.joined(separator: ", ") ?? "")
                }
                
                Section(header: Text("Last Watered")) {
                    Text(wateredDate(date: plant.lastWateringDate!))
                }
            }

        }   // End of Form
        .navigationBarTitle(Text("Plant Details"), displayMode: .inline)
        .font(.system(size: 14))
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
              Button("OK") {}
            }, message: {
              Text(alertMessage)
            })
        
    }   // End of body var
    
    func wateredDate(date: Date) -> String {
        // Instantiate a DateFormatter object
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full     // Thursday, November 7, 2019
        // Set the date format to yyyy-MM-dd at HH:mm:ss
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Format current date and time as above and convert it to String
        let currentDate = dateFormatter.string(from: date)
        
        return currentDate
    }
}

//struct PlantDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        PlantDetails()
//    }
//}
