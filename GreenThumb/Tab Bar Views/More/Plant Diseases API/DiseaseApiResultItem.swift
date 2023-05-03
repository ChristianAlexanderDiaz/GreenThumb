//
//  DiseaseApiResultItem.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 5/3/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

/**
    A struct called `DiseaseApiResultItem` that conforms to `View` which gives the item format for each plant in the list.
 */
struct DiseaseApiResultItem: View {
    let disease: DiseaseAPIStruct
    
    var body: some View {
        HStack {
            getImageFromUrl(url: disease.thumbnail, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
        }
        VStack(alignment: .leading) {
            Text(capitalizeFirstLetter(of: disease.common_name))
            Text(capitalizeFirstLetter(of: trimLeadingSpace(of: disease.scientific_name)))
        }
        .font(.system(size: 14))
    }
    
    /**
        A function called `capitalizeFirstLetter` that takes a String and returns the String with the first letter capitalized. If the input string is empty, it returns itself.
     */
    func capitalizeFirstLetter(of string: String) -> String {
        guard !string.isEmpty else { return string }
        return string.prefix(1).capitalized + string.dropFirst()
    }
    
    /**
        A function called `trimLeadingSpace` that takes a String and returns the String with the leading space removed, if it exists.
     */
    func trimLeadingSpace(of string: String) -> String {
        if string.hasPrefix(" ") {
            return String(string.dropFirst())
        } else {
            return string
        }
    }
}

