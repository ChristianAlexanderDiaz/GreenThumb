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
//            Home()
//                .tabItem {
//                    Image(systemName: "house")
//                    Text("Home")
//                }
//            FavoritesList()
//                .tabItem {
//                    Image(systemName: "star.fill")
//                    Text("Favorites")
//                }
//            SearchDatabase()
//                .tabItem {
//                    Image(systemName: "magnifyingglass")
//                    Text("Search Database")
//                }
//            ApiSearchHome()
//                .tabItem {
//                    Image(systemName: "magnifyingglass.circle")
//                    Text("Search API")
//                }
            Settings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        } // end of TabView
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

