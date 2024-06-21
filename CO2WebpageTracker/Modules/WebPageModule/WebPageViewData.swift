//
//  WebPageViewData.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit

struct WebPageViewData {
    let url: String
    let date: Date
    let ratingLetter: String
    let cleanerThan: Double
    let isGreen: String
    let gramForVisit: Double
    let energy: Double
    var image: UIImage?
}

extension WebPageViewData {
    init(url: String, date: Date, cleanerThan: Double, ratingLetter: String, isGreen: String, gramForVisit: Double, energy: Double, image: UIImage? = nil) {
        self.url = url
        self.date = date
        self.ratingLetter = ratingLetter
        self.cleanerThan = cleanerThan
        self.isGreen = isGreen
        self.gramForVisit = gramForVisit
        self.energy = energy
        self.image = image
    }
}
