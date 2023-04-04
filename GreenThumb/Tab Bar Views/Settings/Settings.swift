//
//  Settings.swift
//  Videos
//
//  Created by Christian Alexander Diaz on 3/24/23.
//  Copyright © 2023 Christian Alexander Diaz. All rights reserved.
//

import SwiftUI

/**
    A struct called `Settings` which manages the one thing in there which is `darkMode`.
 */
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
