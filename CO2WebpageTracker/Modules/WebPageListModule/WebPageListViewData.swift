//
//  WebPageListViewData.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import UIKit

struct WebPageListViewData {
    let id: UUID
    let url: String
    let date: Date
    let rating: String
}

extension WebPageListViewData {
    init(url: String, date: Date, rating: String) {
        self.id = UUID()
        self.url = url
        self.date = date
        self.rating = rating
    }
}
