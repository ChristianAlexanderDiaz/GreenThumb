//
//  PlantsData.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/4/23.
//  Edited by Taylor Adeline Flieg on 4/24/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//  Tutorial by Osman Balci.
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
    dateFormatter.dateFormat = "MM/dd/yy"
    
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
        
        var arrayOfWatering = [Date]()
        
        for waterDate in aPlant.watering_history {
            let tempDate = dateFormatter.date(from: waterDate) ?? tempDate
            arrayOfWatering.append(tempDate)
        }
        plantEntity.watering_history = arrayOfWatering

        // Fetch Image Data
        if aPlant.thumbnail != "" {
            //sets primary image
            plantEntity.primaryImage = getUIImageFromUrl(url: aPlant.thumbnail, defaultFilename: "ImageUnavailable").jpegData(compressionQuality: 1.0)
            
            //creates photo entity for the gallery feature
            let photoEntity = Photo(context: managedObjectContext)
            photoEntity.image = plantEntity.primaryImage
            photoEntity.title = "First photo."
            photoEntity.date = aPlant.lastWateringDate
            
            photoEntity.plant = plantEntity
            
        } else {
            //for each example data, creares a photo entity
            for (index, entry) in aPlant.images.enumerated() {
                let photoEntity = Photo(context: managedObjectContext)
                
                // Obtain the album cover photo image from Assets.xcassets as UIImage
                let photoUIImage = UIImage(named: entry)
                
                // Convert photoUIImage to photoData of type Data (Binary Data) in JPEG format with 100% quality
                if let photoData = photoUIImage?.jpegData(compressionQuality: 1.0) {
                    // Store JPEG data into database attribute albumCoverPhoto of type Binary Data
                    photoEntity.image = photoData
                    //sets primary image
                    plantEntity.primaryImage = photoData
                } else {
                    photoEntity.image = nil
                }

                photoEntity.title = aPlant.titles[index]
                photoEntity.date = aPlant.dates[index]
                
                //relationship
                photoEntity.plant = plantEntity
            }
        }
        
        PersistenceController.shared.saveContext()
    }   // End of for loop
}
