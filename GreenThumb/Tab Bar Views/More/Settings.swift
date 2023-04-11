//
//  Settings.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct Settings: View {
    //dark mode
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some View {
        Form {
            Section(header: Text("Dark Mode Setting")) {
                Toggle("Dark Mode", isOn: $darkMode)
            }
        }
        .navigationBarTitle(Text("Settings"), displayMode: .inline)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
