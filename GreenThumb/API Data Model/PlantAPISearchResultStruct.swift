//
//  PlantAPISearchResultStruct.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/24/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct PlantAPISearchResultStruct: Hashable, Codable, Identifiable {
    var id: Int32
    var common_name: String
}
