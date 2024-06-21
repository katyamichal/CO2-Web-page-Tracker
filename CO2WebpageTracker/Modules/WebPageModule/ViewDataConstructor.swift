//
//  DataMapper.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 18.06.2024.
//

import UIKit

final class ViewDataConstructor {
    private var viewData: WebPageViewData?
    
    private enum WebPageHelperStrings {
        static let noData = "no data"
        static let cleanerThan = "This is cleaner then "
        static let globally = " of all web pages globally"
        static let testOn = "This page was tested on "
        static let overAYear = "Over a year, with "
        static let monthlyView = "monthly page views, this page produces "
        static let co2Equivalent = " of CO2 equivalent"
        static let urlTitle = "Web page screen with URL: "
    }
    
    init(viewData: WebPageViewData?) {
        self.viewData = viewData
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    // MARK: - Data for Carbon Rating Cell
    
    var scaleDescription: [String: [String: Any]]? {
        return DescriptionConstructor.shared.getScaleRating()
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
        guard let viewData else { return WebPageHelperStrings.noData}
        return DescriptionConstructor.shared.getRatingDescription(with: viewData.ratingLetter)
    }
    
    var urlDescription: String {
        guard let viewData else { return WebPageHelperStrings.noData}
        return (DescriptionConstructor.shared.getDescription(for: "url") as? String ?? "") + " " + viewData.url
    }
    
    var cleanerThanDescription: String {
        guard let viewData else { return WebPageHelperStrings.noData}
        let headString = WebPageHelperStrings.cleanerThan
        let midString = ((DescriptionConstructor.shared.getDescription(for: "cleanerThan") as? String ?? "") + "\(Int(viewData.cleanerThan * 100))" + "%")
        let tailString = WebPageHelperStrings.globally
        let fullString = headString + midString + tailString
        return fullString
    }
    
    var lastTestDate: String {
        guard let viewData else { return WebPageHelperStrings.noData}
        let headString = WebPageHelperStrings.testOn
        let tailString = dateFormatter.string(from: viewData.date)
        return headString + tailString
    }
    
    // MARK: - Data for Renewable Cell

    var co2PerPageviewDescription: String {
        guard let viewData else { return WebPageHelperStrings.noData}
        return (String(format: "%.2f", viewData.energy)) + " " + (DescriptionConstructor.shared.getDescription(for: "co2PerPageview") as? String ?? "")
    }
    
    var greenDescription: String {
        guard let viewData else { return WebPageHelperStrings.noData}
        return DescriptionConstructor.shared.getGreenDescription(isGreen: viewData.isGreen)
    }
    
    // MARK: - Data for Energy Waste Type Cell
    
    var stepperValue: Int = 1
    var previousValue: Int = 1
    
    var energyHeadTitle: String {
        guard let viewData else { return WebPageHelperStrings.noData}
        let headString = WebPageHelperStrings.overAYear
        let valueString = String(stepperValue)
        return headString + valueString
    }
   
    var energy: String {
        guard let viewData else { return WebPageHelperStrings.noData}
        let headString = WebPageHelperStrings.monthlyView
        let midString = String(format: "%.3f", (viewData.gramForVisit * Double(stepperValue)))
        let tailString = WebPageHelperStrings.co2Equivalent
        let fullString = headString + midString + tailString
        return fullString
    }
    
    // MARK: - Data for Energy Waste Type Cell
    
    var urlTitle: String {
        guard let viewData else { return WebPageHelperStrings.noData}
        return WebPageHelperStrings.urlTitle + "\(viewData.url)"
    }
}
