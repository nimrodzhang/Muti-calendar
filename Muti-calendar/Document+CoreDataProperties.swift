//
//  Document+CoreDataProperties.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var courseName: String?
    @NSManaged public var docName: String?
    @NSManaged public var docPath: String?
    @NSManaged public var docType: String?

}
