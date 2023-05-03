//
//  More.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct More: View {
    var body: some View {
        NavigationView {
            List {
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
