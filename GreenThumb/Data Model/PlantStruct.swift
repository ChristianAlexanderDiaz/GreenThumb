//
//  PlantStruct.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/4/23.
//  Edited by Taylor Flieg on 5/02/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

//todo- edit to pass in array of photo names in assets? from my plant app on my phone maybe? (also need arrays with dates and captions for each!)
struct PlantStruct: Decodable {
    var id: Int32
    var common_name: String
    var scientific_name: [String]
    var other_name: [String]
    var cycle: String
    var watering: String
    var sunlight: [String]
    var diseasedNotes: String
    var starred: Bool
    var diseased: Bool
    var lastWateringDate: String
    var nextWateringDate: String
    var diseasedDate: String
    var starredDate: String
    var thumbnail: String
    var images: [String]
    var dates: [String]
    var titles: [String]
    var location: String
    var nickname: String
    var watering_history: [String]
}
