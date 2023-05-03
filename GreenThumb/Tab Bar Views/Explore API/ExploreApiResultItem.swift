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
            Text(capitalizeFirstLetter(of: plant.common_name))
            Text(capitalizeFirstLetter(of: plant.scientific_name[0]))
        }
        .font(.system(size: 14))
    }
    
    /**
        A function called `capitalizeFirstLetter` of a function that is a String and returns the String with the first letter being capitalized. If in the extreme case, it's an empty string, it will return itself.
     */
    func capitalizeFirstLetter(of string: String) -> String {
        //the extreme case the string is empty for some reason
        guard !string.isEmpty else { return string }
        return string.prefix(1).capitalized + string.dropFirst()
    }
}
