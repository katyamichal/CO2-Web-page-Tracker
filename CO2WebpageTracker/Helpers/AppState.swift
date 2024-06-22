//
//  AppState.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 20.06.2024.
//

import UIKit

enum Mode: Codable {
    case none
    case edinitig
}

struct AppState: Codable {
    var url: String
    var isEditingMode: Mode
    var stepperValue: Int
    var previosValue: Int
}

