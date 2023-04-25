//
//  ExploreApiResultItem.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct ExploreApiResultItem: View {
    let plant: PlantAPIStruct
    
    // Subscribe to changes in Core Data database
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        HStack {
            getImageFromUrl(url: plant.thumbnail, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
        }
        VStack(alignment: .leading) {
            Text(plant.common_name)
            Text(plant.scientific_name[0])
        }
        .font(.system(size: 14))
    }
}
