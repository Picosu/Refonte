//
//  Region+CoreDataProperties.swift
//  France3Refonte
//
//  Created by Maxence DE CUSSAC on 02/11/2015.
//  Copyright © 2015 Maxence DE CUSSAC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Region {

    @NSManaged var name: String?
    @NSManaged var id_region: String?
    @NSManaged var disqus: String?
    @NSManaged var id_atinternet: String?

}
