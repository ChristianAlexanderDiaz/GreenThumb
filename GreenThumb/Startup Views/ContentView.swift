//
//  ContentView.swift
//  GreenThumb
//
//  Created by Osman Balci on 5/25/22.
//  Copyright © 2022 Osman Balci. All rights reserved.
//

import SwiftUI

//special content view which is used for implementing a login screen
struct ContentView : View {
    
    //so view will be refreshed when userAuthenticated becomes true so that it can change to display the main view
    @State private var userAuthenticated = false
    
    var body: some View {
        //when user becomes authenticated, will start displaying the MainView view
        if userAuthenticated {
            // Foreground View
            MainView()
        } else {
            //else, will throw to LoginView into the background, passing it the userAuthenticated state variable. This allows this view to still be running so that it can refresh when we are changing thr userAuthenticated variable.
            ZStack {
                // Background View
                //$ is pass by reference (can change)
                LoginView(canLogin: $userAuthenticated)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
