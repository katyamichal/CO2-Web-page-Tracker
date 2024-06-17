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
    
    // first cell ---> carbonRating
    var urlDescription: String {
        return (DescriptionConstructor.shared.getDescription(for: "url") as? String ?? "") + " " + url
    }
    
    var scaleDescription: [String: [String: Any]]? {
        return DescriptionConstructor.shared.getRatingDescription()
    }
    
    var letter: String {
        ratingLetter
    }
    
    var greenDescription: String {
        return DescriptionConstructor.shared.getGreenDescription(isGreen: isGreen) ?? ""
    }
    
    var cleanerThanDescription: String {
        return ((DescriptionConstructor.shared.getDescription(for: "cleanerThan") as? String ?? "") + "\(diertierThan)")
    }
    
    var co2PerPageviewDescription: String {
        return DescriptionConstructor.shared.getDescription(for: "co2PerPageview") as? String ?? ""
    }
    var ratingColor: String {
        return DescriptionConstructor.shared.getRatingLetter(with: ratingLetter)?.lowercased() ?? ""
       }

    var ratingDescription: String {
        return DescriptionConstructor.shared.getRatingDescription(with: ratingLetter)
    }
}

extension WebPageViewData {
    init(url: String, date: Date, diertierThan: Int, ratingLetter: String, isGreen: Bool, gramForVisit: Float) {
        self.id = UUID()
        self.url = url
        self.date = date
        self.ratingLetter = ratingLetter
        self.diertierThan = diertierThan
        self.isGreen = isGreen
        self.gramForVisit = gramForVisit
    }
}
