//
//  ExploreApiResultsList.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct ExploreApiResultsList: View {
    
    var exploreApiResultPlants: [PlantAPIStruct]
    
    var body: some View {
        List {
            ForEach(exploreApiResultPlants, id: \.id) { aPlant in
                NavigationLink(destination: ExploreApiResultDetails(plant: aPlant)) {
                    ExploreApiResultItem(plant: aPlant)
                }
                .navigationBarTitle(Text("Search Results"), displayMode: .inline)
            }
        }
    }
}
