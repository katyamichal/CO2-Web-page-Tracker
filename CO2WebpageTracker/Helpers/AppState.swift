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
enum Tab: Int, Codable {
    case search = 0
    case webPageList
}

struct AppState: Codable {
    var id: UUID?
    var isEditingMode: Mode
    var currentTab: Tab
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case isEditingMode
        case currentTab
        case image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id)
        isEditingMode = try container.decode(Mode.self, forKey: .isEditingMode)
        currentTab = try container.decode(Tab.self, forKey: .currentTab)
        
        if let imageData = try container.decodeIfPresent(Data.self, forKey: .image) {
            image = UIImage(data: imageData)
        } else {
            image = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(isEditingMode, forKey: .isEditingMode)
        try container.encode(currentTab, forKey: .currentTab)
        
        if let image = image, let imageData = image.pngData() {
            try container.encode(imageData, forKey: .image)
        }
    }
}

extension AppState {
    init(with id: UUID, isEditing: Mode, currentTab: Tab, image: UIImage? = nil) {
        self.image = image
        self.id = id
        self.isEditingMode = isEditing
        self.currentTab = currentTab
    }
}
