//
//  WebPageInfo+CoreDataProperties.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 18.06.2024.
//
//

import Foundation
import CoreData


extension WebPageInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WebPageInfo> {
        return NSFetchRequest<WebPageInfo>(entityName: "WebPageInfo")
    }

    @NSManaged public var cleanerThan: Double
    @NSManaged public var date: Date?
    @NSManaged public var energy: Double
    @NSManaged public var gramForVisit: Double
    @NSManaged public var identifier: UUID?
    @NSManaged public var isGreen: String?
    @NSManaged public var rating: String?
    @NSManaged public var url: String?

}

extension WebPageInfo : Identifiable {

}
