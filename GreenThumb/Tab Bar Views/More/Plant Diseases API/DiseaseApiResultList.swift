//
//  DiseaseApiResultList.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 5/3/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct DiseaseApiResultsList: View {
    
    var diseaseAPIStructDetails: [DiseaseAPIStruct]
    
    var body: some View {
        List {
            ForEach(diseaseAPIStructDetails, id: \.id) { aDisease in
                NavigationLink(destination: DiseaseApiResultDetails(disease: aDisease)) {
                    DiseaseApiResultItem(disease: aDisease)
                }
                .navigationBarTitle(Text("Search Results"), displayMode: .inline)
            }
        }
    }
}
