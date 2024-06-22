//
//  UIColor + customColor.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 17.06.2024.
//

import UIKit

enum Colours {
    
    enum WebPageColours {
        static let darkBlue = UIColor.rgba(red: 10, green: 11, blue: 122, alpha: 1)
        static let red = UIColor.rgba(red: 222, green: 135, blue: 134, alpha: 1)
        static let blue = UIColor.rgba(red: 13, green: 187, blue: 238, alpha: 1)
        static let defaultColour = UIColor.rgba(red: 240, green: 248, blue: 255, alpha: 1)
        static let green = UIColor.rgba(red: 0, green: 194, blue: 69, alpha: 1)
//
//        static let khaki = UIColor.rgba(red: 89, green: 126, blue: 82, alpha: 1)
//        static let red = UIColor.rgba(red: 222, green: 135, blue: 134, alpha: 1)
//        static let blue = UIColor.rgba(red: 48, green: 129, blue: 208, alpha: 1)
//        static let defaultColour = UIColor.rgba(red: 255, green: 255, blue: 236, alpha: 1)
//        static let yellowish = UIColor.rgba(red: 183, green: 196, blue: 182, alpha: 1)
    }
    
    enum BackgroundsColours {
        static let defaultColour = UIColor.rgba(red: 250, green: 240, blue: 218, alpha: 1)
    }
    
    enum Text {
        static let defaultColour = UIColor.rgba(red: 79, green: 77, blue: 80, alpha: 1)
        static let secondaryText = UIColor.rgba(red: 169, green: 168, blue: 172, alpha: 1)
    }

    enum Button {
        static let addButtonColour = UIColor.rgba(red: 0, green: 255, blue: 189, alpha: 1)
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

