//
//  ContentView.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/4/23.
//

import SwiftUI

struct ContentView: View {
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
            PlantCare()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

