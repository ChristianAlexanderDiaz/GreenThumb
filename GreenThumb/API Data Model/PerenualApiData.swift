//  PerenualApiData.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import Foundation

var foundPlantsList = [PlantAPIStruct]()

let perenualApiKey = "sk-LAYB6435bb62d3145488"

let perenualApiHeaders = [
    "accept": "application/json",
    "authorization": "Bearer sk-LAYB6435bb62d3145488",
    "cache-control": "no-cache",
    "connection": "keep-alive"
]

public func getFoundPlantsFromApi(query: String) {
    foundPlantsList = [PlantAPIStruct]()
    
    let apiUrlStringQuery = "https://perenual.com/api/species-list?key=\(perenualApiKey)&q=\(query)"
    
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: perenualApiHeaders, apiUrl: apiUrlStringQuery, timeout: 20.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return
    }
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
        } else {
            return
        }
    
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi, options: JSONSerialization.ReadingOptions.mutableContainers)
        
            if let jsonObject = jsonResponse as? [String: Any] {
                if let arrayOfPlants = jsonObject["data"] as? [Any] {
                
                    for plantObject in arrayOfPlants {
                    
                    var id: Int
                    var common_name, cycle, watering: String
                    var scientific_name, other_name, sunlight: [String]
                    var thumbnail: String
                    
                    if let plant = plantObject as? [String: Any] {
                        // Extract the required fields from the JSON object
                        id = plant["id"] as? Int ?? 0
                        common_name = plant["common_name"] as? String ?? ""
                        cycle = plant["cycle"] as? String ?? ""
                        watering = plant["watering"] as? String ?? ""
                        scientific_name = plant["scientific_name"] as? [String] ?? []
                        other_name = plant["other_name"] as? [String] ?? []
                        sunlight = plant["sunlight"] as? [String] ?? []
                        
                        if let image = plant["default_image"] as? [String: String] {
                            thumbnail = image["thumbnail"] ?? ""
                        } else {
                            thumbnail = ""
                        }
                        
                        let newPlant = PlantAPIStruct(id: Int32(id), common_name: common_name, scientific_name: scientific_name, other_name: other_name, cycle: cycle, watering: watering, sunlight: sunlight, thumbnail: thumbnail)
                        foundPlantsList.append(newPlant)
                    }
                }
            } else { return }
        } else { return } //end of do block
    } catch { return }
}
