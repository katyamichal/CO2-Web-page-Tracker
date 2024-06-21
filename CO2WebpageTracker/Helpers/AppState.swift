//
//  AppState.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 20.06.2024.
//

import UIKit
enum Mode {
    case none
    case edinitig
}
enum Tab: Int {
    case search = 0
    case webPageList
}

struct AppState {
    var id: UUID?
    var isEditingMode: Mode
    var currentTab: Tab
    var image: UIImage?
}
