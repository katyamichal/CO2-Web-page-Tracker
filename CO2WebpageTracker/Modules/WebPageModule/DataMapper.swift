//
//  DataMapper.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 18.06.2024.
//

import UIKit

final class DataMapper {
    private var viewData: WebPageViewData?
    var stepperValue: Int = 1
    
    init(viewData: WebPageViewData?) {
        self.viewData = viewData
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    
    var lastTestDate: String {
        guard let viewData else { return "No Data" }
        return dateFormatter.string(from: viewData.date)
    }
    
    var urlDescription: String {
        guard let viewData else { return "No Data" }
        return (DescriptionConstructor.shared.getDescription(for: "url") as? String ?? "") + " " + viewData.url
    }
    
    var scaleDescription: [String: [String: Any]]? {
        return DescriptionConstructor.shared.getScaleRating()
    }
    
    var greenDescription: String {
        guard let viewData else { return "No Data" }
        return DescriptionConstructor.shared.getGreenDescription(isGreen: viewData.isGreen)
    }
    
    var cleanerThanDescription: String {
        guard let viewData else { return "No Data" }
        return ((DescriptionConstructor.shared.getDescription(for: "cleanerThan") as? String ?? "") + "\(Int(viewData.cleanerThan * 100))" + "%")
    }
    
    var co2PerPageviewDescription: String {
        guard let viewData else { return "No Data" }
        return (String(format: "%.2f", viewData.energy)) + " " + (DescriptionConstructor.shared.getDescription(for: "co2PerPageview") as? String ?? "").lowercased()
    }
    
    var ratingColor: UIColor {
        guard
            let viewData,
            let letterColour = DescriptionConstructor.shared.getRatingLetter(with: viewData.ratingLetter)?.lowercased(),
            let colour = UIColor.init(hex: letterColour)
        else { return UIColor.gray }
        return colour
    }
    
    var ratingDescription: String {
        guard let viewData else { return "No Data" }
        return DescriptionConstructor.shared.getRatingDescription(with: viewData.ratingLetter)
    }
    var energy: String {
        guard let viewData else { return "No Data" }
        return String(format: "%.2f", (viewData.energy * Double(stepperValue)))
    }
}
