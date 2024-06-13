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
    let green: Bool
    let bytes: Int
    let cleanerThan: Double
    let rating: String
    let statistics: WebsiteStatistics
//    let timestamp: TimeInterval

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
