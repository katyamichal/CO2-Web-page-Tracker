//
//  UIColor + customColor.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 17.06.2024.
//

import UIKit

enum Colours {
    
    enum WebPageColours {
        static let darkOrange = UIColor.rgba(red: 232, green: 160, blue: 60, alpha: 1)
        static let green = UIColor.rgba(red: 97, green: 178, blue: 115, alpha: 1)
        static let redish = UIColor.rgba(red: 233, green: 103, blue: 77, alpha: 1)
        static let blueish = UIColor.rgba(red: 206, green: 234, blue: 220, alpha: 1)
        static let lightBrown = UIColor.rgba(red: 236, green: 214, blue: 198, alpha: 1)
    }
    
    enum BackgroundsColours {
        static let light = UIColor.rgba(red: 245, green: 235, blue: 233, alpha: 1)
        static let green = UIColor.rgba(red: 97, green: 178, blue: 115, alpha: 1)
    }
    
    enum Text {
        static let secondaryText = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 1)
    }

    enum Button {
        static let black = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 1)
        static let grey = UIColor.rgba(red: 51, green: 51, blue: 51, alpha: 1)
        
    }
}

extension UIColor {
    
    private static var colourCache: [String: UIColor] = [:]
    
    public static func rgba(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        
        let key = "\(red)\(green)\(blue)\(alpha)"
        if let cachedColour = self.colourCache[key] {
            return cachedColour
        }
        self.clearColourCacheIfNeeded()
        let colour = UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
        self.colourCache[key] = colour
        
        return colour
    }
    
    private static func clearColourCacheIfNeeded() {
        let maxObjectCount = 100
        
        guard self.colourCache .count >= maxObjectCount else {return}
        self.colourCache = [:]
    }
}

