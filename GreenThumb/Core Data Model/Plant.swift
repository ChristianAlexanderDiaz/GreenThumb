//
//  Plant.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/4/23.
//  Edited by Taylor Adeline Flieg on 4/23/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//  Tutorial by Osman Balci.
//

import SwiftUI
import CoreData

//associated with the Plant entity in the core database
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
    @NSManaged public var watering_history: [Date]?

    // Relationship
    @NSManaged public var photos: Set<Photo>
}

extension Plant {
    //defined fetch request for all plants, ordered by their id number
    static func allPlantsFetchRequest() -> NSFetchRequest<Plant> {
        let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return fetchRequest
    }
    //defined fetch request for one plant (the first)
    static func firstPlantFetchRequest() -> NSFetchRequest<Plant> {
        let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.fetchLimit = 1
        return fetchRequest
    }
    //defined fetch request for all plants which need watering, ordered by their watering date
    static func wateringNeedsFetchRequest() -> NSFetchRequest<Plant> {
        let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nextWateringDate", ascending: true)]

        let currentDate = Date.now
        fetchRequest.predicate = NSPredicate(format: "nextWateringDate <= %@", currentDate as CVarArg)

        return fetchRequest
    }
    //defined fetch request for all plants marked as diseased, ordered by their diseased date
    static func diseasedNeedsFetchRequest() -> NSFetchRequest<Plant> {
        let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "diseasedDate", ascending: true)]

        fetchRequest.predicate = NSPredicate(format: "diseased == YES", "")

        return fetchRequest
    }
    //defined fetch request for all plants which are starred, ordered by their starred date
    static func starredNeedsFetchRequest() -> NSFetchRequest<Plant> {
        let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "starredDate", ascending: true)]

        fetchRequest.predicate = NSPredicate(format: "starred == YES")

        return fetchRequest
    }
    //defined fetch request for all plants in a given location, ordered by their id number
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
