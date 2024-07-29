//
//  WebPageListViewData.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import UIKit

struct WebPageListViewData {
    let url: String
    let date: Date
    let rating: String
    
//    func colourRandomizer() -> UIColor {
//        [Colours.WebPageColours.blueish,
//         Colours.WebPageColours.lavender,
//         Colours.WebPageColours.green,
//         Colours.WebPageColours.lightBrown,
//         Colours.WebPageColours.skyBlue,
//         Colours.WebPageColours.turquoise,
//         Colours.WebPageColours.lightGrey,
//         Colours.WebPageColours.lemonYellow,
//         Colours.WebPageColours.plum,
//         Colours.WebPageColours.mintGreen,
//         Colours.WebPageColours.peach,
//         Colours.WebPageColours.salmon].randomElement()!
//    }
}

extension WebPageListViewData {
    init(with url: String, date: Date, rating: String) {
        self.url = url
        self.date = date
        self.rating = rating
    }
}
