//
//  WebPageViewData.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import Foundation
struct WebPageViewData {
    let id: UUID
    let url: String
    let date: Date
    let rating: String
    let isGreen: Bool
    let gramForVisit: Float
 
}

extension WebPageViewData {
    init(url: String, date: Date, rating: String, isGreen: Bool, gramForVisit: Float) {
        self.id = UUID()
        self.url = url
        self.date = date
        self.rating = rating
        self.isGreen = isGreen
        self.gramForVisit = gramForVisit
    }
}
