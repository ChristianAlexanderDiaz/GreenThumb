//
//  WateringHistoryChart.swift
//  GreenThumb
//
//  Created by Brian Wood on 5/2/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import Charts
import SwiftUI


struct WateringHistoryBarChart: View {
    let dates: [Date]
    
    var body: some View {
        let wateringDates = getWateringDates()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM"
        
        return Chart(wateringDates) { grouping in
            ForEach(grouping.wateringDates, id: \.self) { date in
                let dateString = dateFormatter.string(from: date)
                let barColor = dates.contains(date) ? Color.blue : Color.clear
                
                Plot {
                    BarMark(
                        x: .value("Date", dateString),
                        y: .value("Watering", 1)
                    )
//                    .background(
//                        Rectangle()
//                            .foregroundColor(barColor)
//                    )
                }
                .accessibilityLabel(dates.contains(date) ? "Watered" : "Not Watered")
            }
        }
    }
    
    private func getWateringDates() -> [WateringDateGrouping] {
        var wateringDates: [Date] = []
        let calendar = Calendar.current
        let today = Date()
        let last30Days = calendar.date(byAdding: .day, value: -30, to: today)!
        
        for i in 0..<30 {
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            wateringDates.append(date)
        }
        
        return [WateringDateGrouping(wateringDates: wateringDates)]
    }
    
    private struct WateringDateGrouping: Identifiable {
        let id = UUID()
        let wateringDates: [Date]
    }
}




struct WateringHistoryBarChart_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current
        let today = Date()
        let twoMonthsAgo = calendar.date(byAdding: .month, value: -2, to: today)!

        var wateringDates: [Date] = []
        var currentDate = twoMonthsAgo

        while currentDate < today {
            wateringDates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 7, to: currentDate)!
        }

        
        return WateringHistoryBarChart(dates: wateringDates)
            .frame(height: 300)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

