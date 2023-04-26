//
//  Plant.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/4/23.
//  Edited by Taylor Adeline Flieg on 4/23/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI
import CoreData

public class Plant: NSManagedObject, Identifiable {
    // Attributes
    @NSManaged public var id: NSNumber?
    @NSManaged public var common_name: String?
    @NSManaged public var scientific_name: [String]?
    @NSManaged public var other_name: [String]?
    @NSManaged public var cycle: String?
    @NSManaged public var watering: String?
    @NSManaged public var sunlight: [String]?
    @NSManaged public var diseaseNotes: String?
    @NSManaged public var starred: Bool
    @NSManaged public var diseased: Bool
    @NSManaged public var lastWateringDate: Date?
    @NSManaged public var nextWateringDate: Date?
    @NSManaged public var diseasedDate: Date?
    @NSManaged public var starredDate: Date?
    @NSManaged public var primaryImage: Data?
    @NSManaged public var location: String?
    @NSManaged public var nickname: String?

    // Relationship
    @NSManaged public var photos: NSSet?
}

extension Plant {
    static func allPlantsFetchRequest() -> NSFetchRequest<Plant> {
        let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return fetchRequest
    }
    static func firstPlantFetchRequest() -> NSFetchRequest<Plant> {
        let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.fetchLimit = 1
        return fetchRequest
    }
    static func wateringNeedsFetchRequest() -> NSFetchRequest<Plant> {
        let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        //check for watering needs
        //check if watering date is less than or equal to current date and time - consider storing as date rather than string
        //fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchQuery)
        let currentDate = Date.now
        fetchRequest.predicate = NSPredicate(format: "nextWateringDate <= %@", currentDate as CVarArg)

        return fetchRequest
    }
    static func diseasedNeedsFetchRequest() -> NSFetchRequest<Plant> {
        let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        //check for diseased needs
        //either a boolean or check if there is an entry in a disease notes section
        fetchRequest.predicate = NSPredicate(format: "diseaseNotes != %@", "")

        return fetchRequest
    }
    static func starredNeedsFetchRequest() -> NSFetchRequest<Plant> {
        let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        //check for starred needs
        //boolean check
        fetchRequest.predicate = NSPredicate(format: "starred == YES")

        return fetchRequest
    }
    static func plantsInGivenLocFetchRequest(location: String) -> NSFetchRequest<Plant> {
        let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        //check that location matches
        if location != "All"{
            fetchRequest.predicate = NSPredicate(format: "location == %@", location)
        }

        return fetchRequest
    }
}
