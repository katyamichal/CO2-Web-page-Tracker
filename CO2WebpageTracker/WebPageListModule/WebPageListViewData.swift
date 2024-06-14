//
//  WebPageListViewData.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import UIKit

enum LoadingStatus: Equatable, Hashable {
    case nonActive
    case waitToLoad(message: String)
    case loading(progress: Float, image: UIImage?)
    case completed(url: String)
    case paused(image: UIImage?)
    case failed(message: String)
}

struct WebPageListViewData {
    var webpageId: UUID
    var loadingStatus: LoadingStatus
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
