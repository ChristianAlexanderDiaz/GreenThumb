//
//  PlantsData.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/4/23.
//  Edited by Taylor Adeline Flieg on 4/24/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI
import CoreData
import Foundation

/**
 The `createVideosDatabase` function creates the videos database in Core Data by decoding a JSON file and populating the Video entity with the decoded data.
 */
public func createPlantsDatabase() {
    let managedObjectContext = PersistenceController.shared.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    var listOfAllPlantEntitiesInDatabase = [Plant]()
    
    do {
        listOfAllPlantEntitiesInDatabase = try managedObjectContext.fetch(fetchRequest)
    } catch {
        print("Database Creation Failed!")
        return
    }
    
    if listOfAllPlantEntitiesInDatabase.count > 0 {
        print("Database has already been created!")
        return
    }
    
    print("Database will be created!")
    // Local variable arrayOfVideoStructs obtained from the JSON file to create the database
    var arrayOfPlantStructs = [PlantStruct]()
    arrayOfPlantStructs = decodeJsonFileIntoArrayOfStructs(fullFilename: "PlantsData.json", fileLocation: "Main Bundle")
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yy"
    
    for aPlant in arrayOfPlantStructs {
        
        // 1️⃣ Create an instance of the Video entity in managedObjectContext
        let plantEntity = Plant(context: managedObjectContext)
        
        // 2️⃣ Dress it up by specifying its attributes
        plantEntity.id = aPlant.id as NSNumber
        plantEntity.common_name = aPlant.common_name
        plantEntity.scientific_name = aPlant.scientific_name
        plantEntity.other_name = aPlant.other_name
        plantEntity.cycle = aPlant.cycle
        plantEntity.watering = aPlant.watering
        plantEntity.sunlight = aPlant.sunlight
        plantEntity.diseaseNotes = aPlant.diseasedNotes
        plantEntity.starred = aPlant.starred
        plantEntity.diseased = aPlant.diseased
        plantEntity.lastWateringDate = dateFormatter.date(from: aPlant.lastWateringDate)
        plantEntity.nextWateringDate = dateFormatter.date(from: aPlant.nextWateringDate)
        plantEntity.diseasedDate = dateFormatter.date(from: aPlant.diseasedDate)
        plantEntity.starredDate = dateFormatter.date(from: aPlant.starredDate)

        plantEntity.location = aPlant.location
        plantEntity.nickname = aPlant.nickname

        // Fetch Image Data
        plantEntity.primaryImage = getUIImageFromUrl(url: aPlant.thumbnail, defaultFilename: "ImageUnavailable").jpegData(compressionQuality: 1.0)
        
        // 3️⃣ It has no relationship to another Entity
        //todo - make!
        PersistenceController.shared.saveContext()
    }   // End of for loop
}
