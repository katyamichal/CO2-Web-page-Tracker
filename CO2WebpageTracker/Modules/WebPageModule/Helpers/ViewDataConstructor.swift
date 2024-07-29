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
    
    // MARK: - Data for Carbon Rating Cell
    
    var scaleDescription: [String: [String: Any]]? {
        return DescriptionConstructor.shared.getScaleRating()
    }
    
    var ratingColor: UIColor {
        guard
            let viewData,
            let letterColour = DescriptionConstructor.shared.getRatingLetter(with: viewData.ratingLetter)?.lowercased(),
            let colour = UIColor.init(hex: letterColour)
        else {
            return UIColor.gray
        }
        return colour
    }
    
    var ratingDescription: String {
        guard let viewData else { return WebPageHelperStrings.noData }
        return DescriptionConstructor.shared.getRatingDescription(with: viewData.ratingLetter)
    }
    
    var urlDescription: String {
        guard let viewData else { return WebPageHelperStrings.noData }
        return (DescriptionConstructor.shared.getDescription(for: "url") as? String ?? "") + "\n" + viewData.url
    }
    
    var cleanerThanDescription: NSAttributedString {
        guard let viewData else {
            return NSAttributedString(string: WebPageHelperStrings.noData)
        }
        
        let headString = NSAttributedString(string: "This is ")
        
        let percentageString = (DescriptionConstructor.shared.getDescription(for: "cleanerThan") as? String ?? "") + "\(Int(viewData.cleanerThan * 100))" + "%"
        
        let attributes: [NSAttributedString.Key : Any] = [
            .font: Fonts.Body.defaultFont,
            .backgroundColor: ratingColor
        ]
        
        let midString = NSAttributedString(string: "cleaner than " + percentageString, attributes: attributes)
        
        let tailString = NSAttributedString(string: WebPageHelperStrings.globally)
        
        let fullString = NSMutableAttributedString()
        fullString.append(headString)
        fullString.append(midString)
        fullString.append(tailString)
        return fullString
    }

    var lastTestDate: String {
        guard let viewData else { return WebPageHelperStrings.noData }
        let headString = WebPageHelperStrings.testOn
        let tailString = dateFormatter.string(from: viewData.date)
        return headString + tailString
    }
    
    // MARK: - Data for Renewable Cell
    
    var co2PerPageviewDescription: NSAttributedString {
        guard let viewData else {
            return NSAttributedString(string: WebPageHelperStrings.noData)
        }
        let grams = NSAttributedString(string: String(format: "%.2f", viewData.energy) + " grams of ", attributes: attributes)
        
        let descriptionString = " " + (DescriptionConstructor.shared.getDescription(for: "co2PerPageview") as? String ?? "")
        let description = NSAttributedString(string: descriptionString, attributes: attributes)
    
        let fullString = NSMutableAttributedString()
        fullString.append(grams)
        fullString.append(co2String)
        fullString.append(description)
        return fullString
    }
    
    var greenDescription: String {
        guard let viewData else { return WebPageHelperStrings.noData}
        return DescriptionConstructor.shared.getGreenDescription(isGreen: viewData.isGreen)
    }
    
    // MARK: - Data for Energy Waste Type Cell
    
    var stepperValue: Int = 1
    var previousValue: Int = 1
    
    var energyHeadTitle: String {
        guard viewData != nil else { return WebPageHelperStrings.noData}
        let headString = WebPageHelperStrings.overAYear
        let valueString = String(stepperValue)
        return headString + valueString
    }
    
    var energy: String {
        guard let viewData else { return WebPageHelperStrings.noData }
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
    
    static func convertGreenToString(_ isGreen: BoolOrString) -> String {
        switch isGreen {
        case .bool(let status):
            switch status {
            case true:
                return "true"
            case false:
                return "false"
            }
        case .string(let str):
            return str
        }
    }
    
    // MARK: - Addintional
    
    private let attributes: [NSAttributedString.Key : Any] = [
        .font: Fonts.Body.defaultFont
    ]
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    private var co2String: NSAttributedString {
        let baseString = NSMutableAttributedString(string: "CO", attributes: attributes)
        
        let subsriptAttributes: [NSAttributedString.Key: Any] = [
            .baselineOffset: -3,
            .font: Fonts.Body.secondaryFont
        ]
        let subscriptString = NSAttributedString(string: "2", attributes: subsriptAttributes)
        baseString.append(subscriptString)
        
        return baseString
    }
}
