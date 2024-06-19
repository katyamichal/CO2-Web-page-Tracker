//
//  SearchViewData.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit

struct SearchViewData {
    var searchStatus: SearchStatus
}

enum SearchStatus {
    case load(status: LoadingStatus)
    case search
}

enum LoadingStatus: Equatable, Hashable {
    case nonActive
    case loading(message: String)
    case completed(url: String)
    case paused
    case failed(message: String)
}

