//
//  Course+CoreDataProperties.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/23.
//  Copyright © 2017年 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var endhour: Int32
    @NSManaged public var endminute: Int32
    @NSManaged public var isOnlyToday: Bool
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var starthour: Int32
    @NSManaged public var startminute: Int32
    @NSManaged public var weekday: Int32
    @NSManaged public var year: Int32
    @NSManaged public var month: Int32
    @NSManaged public var day: Int32

}
