//
//  Photo.swift
//  GreenThumb
//
//  Created by Taylor Flieg on 4/23/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI
import CoreData

//associated with the Photo entity in the core database
public class Photo: NSManagedObject, Identifiable {

    // Attributes
    @NSManaged public var title: String?
    @NSManaged public var date: String?
    @NSManaged public var image: Data?
    
    // Relationship
    @NSManaged public var plant: Plant?
}
