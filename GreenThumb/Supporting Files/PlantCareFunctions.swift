//
//  PlantCareFunctions.swift
//  GreenThumb
//
//  Created by Taylor Flieg on 4/25/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

public func waterPlant(plant: Plant) {
    // Obtain current date and time
    let currentDateAndTime = Date()
    
    plant.lastWateringDate = currentDateAndTime
    
    var daysToNextWater = DateComponents()
    daysToNextWater.day = Int(plant.watering!) 

    plant.nextWateringDate = Calendar.current.date(byAdding: daysToNextWater, to: currentDateAndTime)
    
    plant.watering_history?.append(currentDateAndTime)
    
    PersistenceController.shared.saveContext()
}

public func starPlant(plant: Plant) {
    plant.starred = true
    plant.starredDate = Date()
    
    PersistenceController.shared.saveContext()
}

public func unstarPlant(plant: Plant) {
    plant.starred = false
    plant.starredDate = nil
    
    PersistenceController.shared.saveContext()
}

public func diseasePlant(plant: Plant) {
    plant.diseased = true
    plant.diseasedDate = Date()
    
    PersistenceController.shared.saveContext()
    
}

public func undiseasePlant(plant: Plant) {
    plant.diseased = false
    plant.diseasedDate = nil
    
    PersistenceController.shared.saveContext()
                            
}


