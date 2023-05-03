//
//  DiseaseApiResultDetails.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 5/3/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct DiseaseApiResultDetails: View {
        let disease: DiseaseAPIStruct
        
//        @Environment(\.dismiss) private var dismiss
//        @Environment(\.managedObjectContext) var managedObjectContext
//
//        @FetchRequest(fetchRequest: Disease.allDiseasesFetchRequest()) var allDiseases: FetchedResults<Disease>
        
//        @EnvironmentObject var databaseChange: DatabaseChange
        
        @State private var showAlertMessage = false
        @State private var alertTitle = ""
        @State private var alertMessage = ""
        
        var body: some View {
            Form {
                Group {
                    Section(header: Text("Plant Name")) {
                        Text(disease.common_name)
                    }
                    Section(header: Text("Plant Image")) {
                        getImageFromUrl(url: disease.thumbnail, defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 300)
                    }
                    Section(header: Text("Scientific Name")) {
                        Text(trimLeadingSpace(of: disease.scientific_name))
                    }
                }
                Section(header: Text("Other Names")) {
                    Text((disease.other_name.joined(separator: ", ")))
                }
                
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
        //the extreme case the string is empty for some reason
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
    
