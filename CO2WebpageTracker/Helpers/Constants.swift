//
//  Constants.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import UIKit

enum Constants {
    
    enum URLSessionsIndentifiers {
        static let session = "URLSearchSession"
    }
    
    enum PlaceholderStrings {
        static let searchBarPlaceholder = "Web Page URL"
    }
    
    enum UIElementNameStrings {
        static let deleteActionImage = "trash"
        static let pausedImage = "pause.circle"
        static let activeImage = "xmark.circle"
    }
    
    enum SearchLoadingMessage {
        static let noInternetConnection = "Poor Internet Connection. Please check your network settings and try again."
        static let waitForLoad = "We're just loading your result..."
        static let failFetchData = "We're sorry but something hasn't worked. Please check the URL and try testing again."
        static let urlSessionError = "Oops! Something went wrong while getting your result. Please try again."
        static let serverError = "Our server is currently unavailable. Please try again later."
    }
    
    enum LabelPlaceHolders {
        static let searchLabel1 = "Estimate your web page carbon footprint:"
        static let searchLabel2 = "Your web page address"
    }
    
    enum AlerMessagesType {
        case emptyTextField
        
        var title: String {
            switch self {
            case .emptyTextField:
                return "The text field is empty"
            }
        }
        
        var message: String {
            switch self {
            case .emptyTextField:
                return "Please enter a URL"
            }
        }
        var buttonTitle: String {
            "Ok"
        }
    }
}

//import Foundation
//
//func loadWebsiteData(fromPlistNamed plistName: String) -> WebsiteData? {
//    guard let url = Bundle.main.url(forResource: plistName, withExtension: "plist") else {
//        print("Failed to locate or load plist file.")
//        return nil
//    }
//    
////    let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject]
////    // и здесь из словаря ты можешь собрать модельку
////    // или сделать
//    let data = try? Data(contentsOf: url)
//    // и из Data собрать Codable модель
//}
