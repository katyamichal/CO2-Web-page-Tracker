//
//  WebPageViewData.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import Foundation

// energy == over a year, with 1 monthly page views, this web page produces
#warning("private set??")
struct WebPageViewData {
    let id: UUID
    let url: String
    let date: Date
    let ratingLetter: String
    let cleanerThan: Double
    let isGreen: String
    let gramForVisit: Double
    let energy: Double
}

extension WebPageViewData {
    init(url: String, date: Date, cleanerThan: Double, ratingLetter: String, isGreen: String, gramForVisit: Double, energy: Double) {
        self.id = UUID()
        self.url = url
        self.date = date
        self.ratingLetter = ratingLetter
        self.cleanerThan = cleanerThan
        self.isGreen = isGreen
        self.gramForVisit = gramForVisit
        self.energy = energy
    }
}
