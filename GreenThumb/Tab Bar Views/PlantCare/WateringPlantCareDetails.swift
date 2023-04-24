//
//  WaterPlantCareDetails.swift
//  GreenThumb
//
//  Created by Taylor Flieg on 4/24/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct WateringPlantCareDetails: View {
    // Input Parameter
    let plant: Plant
    
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        HStack {
            Text(plant.common_name ?? "error")
            Text("Watering")
        }
    }
}


