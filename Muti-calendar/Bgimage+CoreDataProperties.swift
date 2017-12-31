//
//  Bgimage+CoreDataProperties.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/26.
//  Copyright © 2017年 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension Bgimage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bgimage> {
        return NSFetchRequest<Bgimage>(entityName: "Bgimage")
    }

    @NSManaged public var photoData: NSData?

}
