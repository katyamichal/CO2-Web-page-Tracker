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
        static let delete = "trash"
        static let pausedImage = "pause.circle"
        static let activeImage = "xmark.circle"
        static let co2 = "leaf.arrow.triangle.circlepath"
        static let sortBy = "arrow.up.arrow.down"
        static let actionMenu = "ellipsis.circle"
        static let share =  "square.and.arrow.up"
        static let save = "tray.full"
        static let select = "checkmark.circle"
        static let globe = "globe.asia.australia.fill"
    }
    
    enum UIElementTitle {
        static let delete = "Delete"
        static let save = "Save"
        static let share = "Share"
        static let sortBy = "Sort by CO2"
        static let selectWebPage = "Select Web Pages"
        static let groubByCO2 = "Group by CO2 rating"
        static let webPageList = "Wep Pages"
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
        static let testAgain = "Try testing again"
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
