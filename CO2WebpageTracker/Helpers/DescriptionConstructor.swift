//
//  DescriptionConstructor.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 17.06.2024.
//

import UIKit

struct DescriptionConstructor {
    
    static let shared = DescriptionConstructor()
    private var descriptions: [String: Any]?
    
    init() {
        if let path = Bundle.main.path(forResource: "Descriptions", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
            descriptions = dict
        }
    }
    
    private var co2Description: [String: Any]? {
        return descriptions?["CO2Description"] as? [String: Any]
    }
    
    func getDescription(for key: String) -> Any? {
        return co2Description?[key]
    }
    
    func getGreenDescription(isGreen: String) -> String {
        guard let greenDescriptions = co2Description?["green"] as? [String: String] else {
            return "unknown"
        }
        return greenDescriptions[isGreen] ?? "unknown green status"
    }
    
    func getScaleRating() -> [String: [String: Any]]? {
        return (co2Description?["scale"] as? [String: [String: Any]]? ?? nil)
    }
    
    func getRatingLetter(with letter: String) -> String? {
        let dict = getScaleRating()
        let letterDiscription = dict?[letter] as? [String: Any]
        let colorValue = letterDiscription?["color"] as? String
        return colorValue
    }
    
    func getRatingDescription(with letter: String) -> String {
        let dict = getScaleRating()
        let letterDiscription = dict?[letter] as? [String: Any]
        let description = letterDiscription?["description"] as? String
        guard let description else { return "There is no description"}
        return description
    }
}
