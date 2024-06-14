//
//  WebPageListViewData.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import UIKit

struct WebPageListViewData {
    var webpageId: UUID
    var lastDateTest: String
    var wepPageInfo: WebPageInfo
}

struct WebPageInfo {
    var image: String?
    let url: String
//    let rating: String
//    let isGreen: Bool
//    let gramsForVisit: Float
}

extension WebPageInfo {
    init(with url: String) {
        self.url = url
       // self.rating = rating
//        self.isGreen = isGreen
//        self.gramsForVisit = gramsForVisit
    }
}
