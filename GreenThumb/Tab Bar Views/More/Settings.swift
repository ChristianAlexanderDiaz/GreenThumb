//
//  Settings.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

import SwiftUI

struct Settings: View {
    @AppStorage("darkMode") private var darkMode = false
    
    @State private var perenualApiKeyValue = ""

    var body: some View {
        Form {
            Section(header: Text("Dark Mode Setting")) {
                Toggle("Dark Mode", isOn: $darkMode)
            }
            Section(header: Text("Perenual API Key")) {
                TextField("Enter API Key", text: $perenualApiKeyValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
        }
        .navigationBarTitle(Text("Settings"), displayMode: .inline)
    }
}

