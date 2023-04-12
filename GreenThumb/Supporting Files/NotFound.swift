//
//  NotFound.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 3/25/23.
//  Copyright © 2023 Christian Alexander Diaz. All rights reserved.
//
//  Tutorial by Osman Balci on 3/20/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import SwiftUI
 
/**
    A struct called `NotFound` that gives us a View that custom makes a Not Found system for that whe something isn't found.
 */
struct NotFound: View {
    
    // Input parameter
    let message: String
    
    var body: some View {
        ZStack {        // Color Background to Ivory
            Color(red: 1.0, green: 1.0, blue: 240/255)
            
            VStack {    // Foreground
                Image(systemName: "exclamationmark.triangle")
                    .imageScale(.large)
                    .font(Font.title.weight(.medium))
                    .foregroundColor(.red)
                    .padding()
                Text(message)
                    .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 128/255, green: 0.0, blue: 0.0))    // Maroon
                    .padding()
            }
        }
    }
}

struct NotFound_Previews: PreviewProvider {
    static var previews: some View {
        NotFound(message: "")
    }
}
