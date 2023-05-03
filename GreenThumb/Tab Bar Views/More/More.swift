//
//  More.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

/**
    A struct called More that conforms to View which gives me a List filled with different NavigationLinks that act as more tabs for the application.
 */
struct More: View {
    var body: some View {
        NavigationView {
            List {
                // Plant Diseases API
                NavigationLink(destination: PlantDiseases()) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .imageScale(.large)
                            .font(Font.title.weight(.regular))
                            .frame(width: 60)
                        Text("Plant Diseases API")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(.blue)
                }
                // App Information with Details for all our information
                NavigationLink(destination: AppInformation()) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .imageScale(.large)
                            .font(Font.title.weight(.regular))
                            .frame(width: 60)
                        Text("App Information")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(.blue)
                    
                }
                // Settings Page that contains change of key and password setups
                NavigationLink(destination: Settings()) {
                    HStack {
                        Image(systemName: "gear.circle.fill")
                            .imageScale(.large)
                            .font(Font.title.weight(.regular))
                            .frame(width: 60)
                        Text("Settings")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(.blue)
                } //end of NavigationLink
            } //end of List
            .navigationBarTitle(Text("More"), displayMode: .inline)
        } //end of NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
    } //end of body
} //end of struct
