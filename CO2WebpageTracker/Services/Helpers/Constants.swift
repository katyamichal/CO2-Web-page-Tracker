//
//  Constants.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import Foundation

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
        static let searchLabel1 = "Estimate yoour web page carbon footprint:"
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
                return "Please, enter an image name"
            }
        }
        var buttonTitle: String {
            "Ok"
        }
    }
}

