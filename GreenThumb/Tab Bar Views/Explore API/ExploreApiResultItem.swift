//
//  ExploreApiResultItem.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

/**
    A struct called `ExploreApiResultItem` that conforms to `View` which gives the item format for each plant in the list.
 */
struct ExploreApiResultItem: View {
    // A PlantAPIStruct object representing the found plant to display
    let plant: PlantAPIStruct
    
    // Subscribe to changes in Core Data database
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        HStack {
            // Display the thumbnail image for the found plant
            getImageFromUrl(url: plant.thumbnail, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
        }
        VStack(alignment: .leading) {
            // Display the common name and scientific name of the found plant
            Text(capitalizeFirstLetter(of: plant.common_name))
            Text(capitalizeFirstLetter(of: plant.scientific_name[0]))
        }
        .font(.system(size: 14))
    }
    
    /**
        A function called `capitalizeFirstLetter` that takes a String as input and returns the same string with the first letter capitalized. If the string is empty, it will return itself.
     */
    func capitalizeFirstLetter(of string: String) -> String {
        // Check if the string is empty
        guard !string.isEmpty else { return string }
        // Capitalize the first letter of the string and return the modified string
        return string.prefix(1).capitalized + string.dropFirst()
    }
}
