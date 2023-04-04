//
//  Plant.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/4/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI
import CoreData

public class Video: NSManagedObject, Identifiable {
    @NSManaged public var id: NSNumber?
    @NSManaged public var name: String?
}

extension Video {
    static func allVideoFetchRequest() -> NSFetchRequest<Video> {
        let fetchRequest = NSFetchRequest<Video>(entityName: "Plant")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return fetchRequest
    }
}
