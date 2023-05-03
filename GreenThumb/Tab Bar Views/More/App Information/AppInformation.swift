//
//  AppInformation.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/24/23.
//

import SwiftUI

// Define a new view called AppInformation
struct AppInformation: View {
    var body: some View {
        VStack {
            // Create a list view
            List {
                // Add a section to the list view
                Section(header: Text("App Information")) {
                    Text("App Name: GreenThumb")
                    Text("Version: 1.0")
                    Text("Developers: Christian Alexander Diaz, Taylor Adeline Flieg, Brian Andrew Wood")
                }
                
                // Add another section to the list view
                Section(header: Text("Support")) {
                    // Create a button that opens an email application to contact the developers
                    Button(action: {
                        let to = ["taflieg@vt.edu", "brianwood@vt.edu", "cdiaz799@vt.edu"].joined(separator: ",")
                        let subject = "GreenThumb App Support"
                        let email = "mailto:\(to)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        guard let url = URL(string: email) else { return }
                        UIApplication.shared.open(url)
                    }) {
                        Text("Email the Developers")
                    }
                    
                    // Add a link to a course website
                    Link("Course Website", destination: URL(string: "https://manta.cs.vt.edu/cs3714/Index.html")!)
                }
            }
            .listStyle(GroupedListStyle())
            
            // Add a footer text with copyright information
            HStack {
                Text("© 2023 GreenThumb. All rights reserved.")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        // Set the navigation bar title for this view
        .navigationBarTitle("About GreenThumb")
    }
}
