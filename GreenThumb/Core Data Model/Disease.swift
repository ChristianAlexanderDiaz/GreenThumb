//
//  Disease.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 5/3/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

//import SwiftUI
//import CoreData
//
//public class Disease: NSManagedObject, Identifiable {
//    @NSManaged public var id: NSNumber?
//    @NSManaged public var common_name: String?
//    @NSManaged public var scientific_name: String
//    @NSManaged public var other_name: [String]
//    @NSManaged public var descriptionValue: String?
//    @NSManaged public var thumbnail: String
//}
//
//extension Disease {
//    static func allDiseasesFetchRequest() -> NSFetchRequest<Disease> {
//        let fetchRequest = NSFetchRequest<Disease>(entityName: "Disease")
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
//        return fetchRequest
//    }
//}
