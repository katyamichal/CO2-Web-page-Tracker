//
//  CorboneDTO.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import Foundation

// MARK: - WebsiteData
struct WebsiteData: Codable {
    let url: String
    let green: BoolOrString
    let bytes: Int
    let cleanerThan: Double
    let rating: String
    let statistics: WebsiteStatistics
}

enum BoolOrString: Codable {
    case bool(Bool)
    case string(String)
}

extension BoolOrString {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(BoolOrString.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Bool or String"))
        }
    }
}

// MARK: - WebsiteStatistics
struct WebsiteStatistics: Codable {
    let adjustedBytes: Double
    let energy: Double
    let co2: CO2
}

// MARK: - CO2
struct CO2: Codable {
    let grid: Emission
    let renewable: Emission
}

// MARK: - Emission
struct Emission: Codable {
    let grams: Double
    let litres: Double
}
