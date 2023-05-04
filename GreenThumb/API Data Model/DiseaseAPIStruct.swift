//
//  DiseaseAPIStruct.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 5/2/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

//represents a disease pulled from the Perenual API
struct DiseaseAPIStruct: Hashable, Codable, Identifiable {
    var id: Int32
    var common_name: String
    var scientific_name: String
    var other_name: [String]
    var descriptionValue: String?
    var thumbnail: String
}
