//
//  ExploreApiResultsList.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

/**
    A struct called `ExploreApiResultList` that conforms to View which combines the details and items.
 */
struct ExploreApiResultsList: View {
    // Array of PlantAPIStruct objects representing the found plants matching the search query
    var exploreApiResultPlants: [PlantAPIStruct]
    
    var body: some View {
        // Create a List view to display the found plant details
        List {
            ForEach(exploreApiResultPlants, id: \.id) { aPlant in
                NavigationLink(destination: ExploreApiResultDetails(plant: aPlant)) {
                    // Display the ExploreApiResultItem view for the found plant
                    ExploreApiResultItem(plant: aPlant)
                }
                // Set the navigation bar title for the search results page
                .navigationBarTitle(Text("Search Results"), displayMode: .inline)
            }
        }
    }
}
