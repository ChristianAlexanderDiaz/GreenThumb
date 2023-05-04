//
//  WateringHistory.swift
//  GreenThumb
//
//  Created by Brian Wood on 5/2/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

//view where user can view the watering date history for a plant

import SwiftUI

struct WateringHistoryView: View {
    let dates: [Date]
    
    @State private var showDatePicker = false
    
    var body: some View {
        Form {
            Section(header: Text("Watering History")) {
                if dates.isEmpty {
                    Text("No watering history for this plant.")
                } else {
                    ForEach(dates, id: \.self) { date in
                        Text(wateredDate(date: date))
                    }
                }
            }
            
        }
        .navigationTitle("Watering History")
    }
    
    // Convert the watered date to a string
    func wateredDate(date: Date) -> String {
        // Instantiate a DateFormatter object
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full     // Thursday, November 7, 2019

        // Format current date and time as above and convert it to String
        let currentDate = dateFormatter.string(from: date)

        return currentDate
    }
}




struct WateringHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let dates: [Date] = [
            Date().addingTimeInterval(-86400 * 3),
            Date().addingTimeInterval(-86400 * 7),
            Date().addingTimeInterval(-86400 * 11),
            Date().addingTimeInterval(-86400 * 14),
            Date().addingTimeInterval(-86400 * 20),
            Date().addingTimeInterval(-86400 * 25)
        ]
        WateringHistoryView(dates: dates)
    }
}


