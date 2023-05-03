//
//  AppInformation.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/24/23.
//

import SwiftUI

struct AppInformation: View {
    var body: some View {
        VStack {
            List {
                Section(header: Text("App Information")) {
                    Text("App Name: GreenThumb")
                    Text("Version: 1.0")
                    Text("Developer: Christian Alexander Diaz, Taylor Adeline Flieg, Brian Andrew Wood")
                }
                
                Section(header: Text("Support")) {
                    Button(action: {
                        let to = ["taflieg@vt.edu", "brianwood@vt.edu", "cdiaz799@vt.edu"].joined(separator: ",")
                        let subject = "GreenThumb App Support"
                        let email = "mailto:\(to)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        guard let url = URL(string: email) else { return }
                        UIApplication.shared.open(url)
                    }) {
                        Text("Email Us")
                    }
                    
                    Link("Course Website", destination: URL(string: "https://manta.cs.vt.edu/cs3714/Index.html")!)
                }
            }
            .listStyle(GroupedListStyle())
            
            HStack {
                Text("© 2023 GreenThumb. All rights reserved.")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .navigationBarTitle("About GreenThumb")
    }
}
