//  PerenualApiData.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.


import Foundation

var foundPlantsSearchResultList = [PlantAPISearchResultStruct]()
var foundPlantDetails = [PlantAPIStruct]()

//let perenualApiKey = "sk-LAYB6435bb62d3145488"

let perenualApiKey = "sk-gAna6447010cd6b5f621"

let perenualApiHeaders = [
    "accept": "application/json",
    "authorization": "Bearer \(perenualApiKey)",
    "cache-control": "no-cache",
    "connection": "keep-alive"
]

public func getFoundPlantsFromApi(query: String, maxResults: Int) {
    foundPlantsSearchResultList = [PlantAPISearchResultStruct]()
    foundPlantDetails = [PlantAPIStruct]()

    let apiUrlStringQuery = "https://perenual.com/api/species-list?key=\(perenualApiKey)&q=\(query)"

    var jsonDataFromApi: Data

    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: perenualApiHeaders, apiUrl: apiUrlStringQuery, timeout: 20.0)

    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return
    }

    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi, options: JSONSerialization.ReadingOptions.mutableContainers)

        if let jsonObject = jsonResponse as? [String: Any] {
            if let arrayOfPlants = jsonObject["data"] as? [Any] {
                
                var resultCount = 0

                for plantObject in arrayOfPlants {
                    if resultCount >= maxResults {
                        break
                    }
                    
                    var id = 0
                    var common_name = ""

                    if let plant_Id = plantObject as? [String: Any] {
                        id = plant_Id["id"] as? Int ?? 0
                    }

                    if let plant_Id = plantObject as? [String: Any] {
                        common_name = plant_Id["common_name"] as? String ?? ""
                    }

                    // Append the search result to foundPlantsSearchResultList
                    let searchResultPlant = PlantAPISearchResultStruct(id: Int32(id), common_name: common_name)
                    foundPlantsSearchResultList.append(searchResultPlant)

                    // Get plant details using the ID
                    let apiUrlStringAttributes = "https://perenual.com/api/species/details/\(id)?key=\(perenualApiKey)"

                    var jsonDataFromAttributesApi: Data

                    let jsonDataFetchedFromAttributesApi = getJsonDataFromApi(apiHeaders: perenualApiHeaders, apiUrl: apiUrlStringAttributes, timeout: 20.0)

                    if let attributesJsonData = jsonDataFetchedFromAttributesApi {
                        jsonDataFromAttributesApi = attributesJsonData
                    } else {
                        return
                    }

                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromAttributesApi, options: JSONSerialization.ReadingOptions.mutableContainers)

                        if let plant = jsonResponse as? [String: Any] {
                            var common_name = "", cycle = "", watering = ""
                            var scientific_name, other_name, sunlight: [String]
                            var thumbnail = ""

                            var attracts: [String]
                            var type = "", dimension = ""
                            var indoor: Bool

                            // Extract the required fields from the JSON object
                            common_name = plant["common_name"] as? String ?? ""
                            cycle = plant["cycle"] as? String ?? ""
                            watering = plant["watering"] as? String ?? ""
                            scientific_name = plant["scientific_name"] as? [String] ?? []
                            other_name = plant["other_name"] as? [String] ?? []
                            sunlight = plant["sunlight"] as? [String] ?? []

                            if let image = plant["default_image"] as? [String: Any], let thumbnailURL = image["thumbnail"] as? String {
                                thumbnail = thumbnailURL
                            }

                            attracts = plant["attracts"] as? [String] ?? []
                            type = plant["type"] as? String ?? ""
                            dimension = plant["dimension"] as? String ?? ""
                            indoor = plant["indoor"] as? Bool ?? false

                            let newPlant = PlantAPIStruct(id: Int32(id), common_name: common_name, scientific_name: scientific_name, other_name: other_name, cycle: cycle, watering: watering, sunlight: sunlight, thumbnail: thumbnail, attracts: attracts, type: type, dimension: dimension, indoor: indoor)
                            foundPlantDetails.append(newPlant)
                            resultCount += 1
                        } else { return }
                    } catch { return }
                }
            } else { return } // end of arrayOfPlants
        } else { return }
    } catch { return } // end of do block
} // end of function
