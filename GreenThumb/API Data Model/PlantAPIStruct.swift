//
//  PlantAPIStruct.swift
//  GreenThumb
//
//  Created by Taylor Flieg on 4/24/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct PlantAPIStruct: Hashable, Codable, Identifiable {
    var id: Int32
    var common_name: String
    var scientific_name: [String]
    var other_name: [String]
    var cycle: String
    var watering: String
    var sunlight: [String]
    var thumbnail: String
    
    var attracts: [String]
    var type: String
    var dimension: String
    var indoor: Bool
}

