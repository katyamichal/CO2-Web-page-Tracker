//
//  URLConstructor.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 29.07.2024.
//

import Foundation

struct URLConstructor {
    
    private init() {}
    
    static func createURLForShare(with urlString: String) -> URL? {
        guard URL(string: urlString) != nil else {
            print("viewData or url is nil or invalid")
            return nil
        }
        let prefixes = ["https://", "http://"]
        var modifiedURLString = urlString
        for prefix in prefixes {
            if modifiedURLString.hasPrefix(prefix) {
                modifiedURLString.removeFirst(prefix.count)
                break
            }
        }
        if modifiedURLString.hasPrefix("www.") {
            modifiedURLString.removeFirst(4)
        }
        let modifiedPath = modifiedURLString.replacingOccurrences(of: "/", with: "-")
        let baseURLString = Constants.Urls.websitecarbon
        let urlString = baseURLString + "website/" + modifiedPath
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        return url
    }
    
    static func createURLRequest(with urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
}
