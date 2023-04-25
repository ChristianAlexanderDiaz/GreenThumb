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
    daysToNextWater.day = 5 //TODO change to plant.----

    plant.nextWateringDate = Calendar.current.date(byAdding: daysToNextWater, to: currentDateAndTime)
    
    PersistenceController.shared.saveContext()
}

public func starPlant(plant: Plant) {
    plant.starred = true
    
    PersistenceController.shared.saveContext()
}

public func unstarPlant(plant: Plant) {
    plant.starred = false
    
    PersistenceController.shared.saveContext()
}

public func diseasePlant(plant: Plant) {
    //plant.diseased = true
    plant.diseaseNotes = " "
    
    PersistenceController.shared.saveContext()
}

public func undiseasePlant(plant: Plant) {
    //plant.diseased = false
    plant.diseaseNotes = ""
    
    PersistenceController.shared.saveContext()
}
