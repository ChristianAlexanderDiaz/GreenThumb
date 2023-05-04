//
//  MainView.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/4/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

//main view to set up the tab navigation

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            MyPlants()
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("My Plants")
                }
            PlantCareList()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Plant Care")
                }
            ExploreApi()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("Explore API")
                }
            More()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("More")
                }
        }
        .font(.headline)
        .imageScale(.medium)
        .font(Font.title.weight(.regular))
    } //end of var body: some View
} //end of struct

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

