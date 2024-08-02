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
    
    enum UserDefaultKeys {
        static let appState = "appState"
    }
    
    enum PlaceholderStrings {
        static let searchBarPlaceholder = "Web Page URL"
    }
    
    enum NavigationTitles {
        static let webPageNavigationTitle = "Web Pages"
    }
    
    enum Urls {
        static let websitecarbon = "https://www.websitecarbon.com/website/"
        static let learnAboutURLString = "https://www.websitecarbon.com/introducing-the-website-carbon-rating-system/"
        static let howDoesItWork = "https://www.websitecarbon.com/how-does-it-work/"
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
        static let camera = "camera"
        static let calendar = "calendar"
    }
    
    enum UIElementTitle {
        static let delete = "Delete"
        static let save = "Save"
        static let share = "Share"
        static let sortByCO2 = "Sort by CO2"
        static let sortByDate = "Sort by Date"
        static let webPageList = "Wep Pages"
        static let addPhoto = "Add Photo"
        static let done = "Done"
    }
    
    enum UIElementNames {
        static let calculateButton = "Calculate"
        static let cancelButton = "Cancel"
    }
     
    enum SearchLoadingMessage {
        static let noInternetConnection = "Poor Internet Connection. Please check your network settings and try again."
        static let waitForLoad = "We're just loading your result..."
        static let failFetchData = "We're sorry but something hasn't worked. Please check the URL and try testing again."
        static let urlSessionError = "Oops! Something went wrong while getting your result. Please try again."
        static let serverError = "Our server is currently unavailable. Please try again later."
        static let testAgain = "Try testing again"
        static let loading = "We're loading you result. The test requires a full load of the page, so the bigger the webpage, the longer it takes."
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
        case errorToLoadWebKit
        
        var title: String {
            switch self {
            case .emptyTextField:
                return "The text field is empty"
            case .webPageDublicated:
                return "It seems that you've already had this web page in your list"
            case .errorToLoadWebKit:
                return "Oops!"
            }
        }
        
        var message: String {
            switch self {
            case .emptyTextField:
                return "Please enter a URL"
            case .webPageDublicated:
                return "Do you want to resave it?"
            case .errorToLoadWebKit:
                return "The page is not available atm, please try later"
            }
        }
        var cancelButtonTitle: String {
            switch self {
            case .emptyTextField, .errorToLoadWebKit:
                return "OK"
            case .webPageDublicated:
                return "Leave"
            }
        }
        
        var actionButtonTitle: String {
            switch self {
            case .webPageDublicated, .errorToLoadWebKit:
                return "Resave"
            case .emptyTextField:
                return ""
            }
        }
    }
}
