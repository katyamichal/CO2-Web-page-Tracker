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
    
    enum UIElementSystemNames {
        static let deleteActionImage = "trash"
        static let pausedImage = "pause.circle"
        static let activeImage = "xmark.circle"
    }
    enum UIElementNames {
        static let calculateButton = "Calculate"
    }
     
    enum SearchLoadingMessage {
        static let noInternetConnection = "Poor Internet Connection. Please check your network settings and try again."
        static let waitForLoad = "We're just loading your result..."
        static let failFetchData = "We're sorry but something hasn't worked. Please check the URL and try testing again."
        static let urlSessionError = "Oops! Something went wrong while getting your result. Please try again."
        static let serverError = "Our server is currently unavailable. Please try again later."
    }
    
    enum CoreDataMessage {
        static let fetchError = "Sorry, we couldn't get your web pages, try later."
    }
    
    enum LabelPlaceHolders {
        static let searchLabel1 = "Estimate your web page carbon footprint:"
        static let searchLabel2 = "Your web page address"
    }
    
    enum AlerMessagesType {
        case emptyTextField
        case webPageDublicated
        
        var title: String {
            switch self {
            case .emptyTextField:
                return "The text field is empty"
            case .webPageDublicated:
                return "It seems that you've already had this web page in your list"
            }
        }
        
        var message: String {
            switch self {
            case .emptyTextField:
                return "Please enter a URL"
            case .webPageDublicated:
                return "Do you want to resave it?"
            }
        }
        var cancelButtonTitle: String {
            switch self {
            case .emptyTextField:
                return "OK"
            case .webPageDublicated:
                return "Leave"
            }
        }
        
        var actionButtonTitle: String {
            switch self {
            case .webPageDublicated:
                return "Resave"
            case .emptyTextField:
                return ""
            }
        }
    }
}
