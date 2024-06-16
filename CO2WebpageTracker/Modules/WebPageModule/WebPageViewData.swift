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
    let ratingLetter: String
    let diertierThan: Int
    let isGreen: Bool
    let gramForVisit: Float
 
}

extension WebPageViewData {
    init(url: String, date: Date, diertierThan: Int, rating: String, isGreen: Bool, gramForVisit: Float) {
        self.id = UUID()
        self.url = url
        self.date = date
        self.ratingLetter = rating
        self.diertierThan = diertierThan
        self.isGreen = isGreen
        self.gramForVisit = gramForVisit
    }
}
