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
    case completed(image: UIImage)
    case paused(image: UIImage?)
    case failed(message: String)
}

struct WebPageListViewData {
    var webpageId: UUID
    var loadingStatus: LoadingStatus
    var wepPageData: WebsiteData
}
