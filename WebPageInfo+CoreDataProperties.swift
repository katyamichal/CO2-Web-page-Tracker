//
//  WebPageInfo+CoreDataProperties.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 16.06.2024.
//
//

import Foundation
import CoreData


extension WebPageInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WebPageInfo> {
        return NSFetchRequest<WebPageInfo>(entityName: "WebPageInfo")
    }

    @NSManaged public var url: String
    @NSManaged public var identifier: UUID
    @NSManaged public var rating: String
    @NSManaged public var isGreen: Bool
    @NSManaged public var gramForVisit: Float
    @NSManaged public var date: Date
    

}

extension WebPageInfo : Identifiable {

}