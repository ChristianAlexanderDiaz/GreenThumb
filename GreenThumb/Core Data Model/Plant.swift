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
    @NSManaged public var thumbnail: String?
    
    // Relationship
    @NSManaged public var photos: NSSet?
}

extension Plant {
    static func allPlantsFetchRequest() -> NSFetchRequest<Plant> {
        let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return fetchRequest
    }
}
