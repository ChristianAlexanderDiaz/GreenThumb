//
//  DiseaseApiResultDetails.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 5/3/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

/**
    A struct called `DiseaseApiResultDetails` that conforms to `View` which gives all the Details from what the API has.
 */
struct DiseaseApiResultDetails: View {
        let disease: DiseaseAPIStruct
        
        @State private var showAlertMessage = false
        @State private var alertTitle = ""
        @State private var alertMessage = ""
        
        var body: some View {
            Form {
                Group {
                    // A section with the Disease Name
                    Section(header: Text("Disease Name")) {
                        Text(disease.common_name)
                    }
                    // A section with the Diseases Image
                    Section(header: Text("Disease Image")) {
                        getImageFromUrl(url: disease.thumbnail, defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 300)
                    }
                    // A section with Scientific Names for the Disease
                    Section(header: Text("Scientific Name")) {
                        Text(trimLeadingSpace(of: disease.scientific_name))
                    }
                }
                // A section with Other Names for the Disease
                Section(header: Text("Other Names")) {
                    Text((disease.other_name.joined(separator: ", ")))
                }
                
                // A section with a description for the Disease if it exists.
                if let description = disease.descriptionValue, !description.isEmpty {
                    Section(header: Text("Description")) {
                        Text(description)
                    }
                }
            }
            .navigationBarTitle(Text("Disease API Details"), displayMode: .inline)
            .font(.system(size: 14))
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
        }
    /**
        A function called `capitalizeFirstLetter` of a function that is a String and returns the String with the first letter being capitalized. If in the extreme case, it's an empty string, it will return itself.
     */
    func capitalizeFirstLetterDisease(of string: String) -> String {
        //the extreme case the string is empty if it ever happens
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
    
