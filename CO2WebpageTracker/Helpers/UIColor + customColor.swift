//
//  UIColor + customColor.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 17.06.2024.
//

import UIKit
//Flyweight

enum Colours {
    
    enum WebPageColours {
        static let turquoise = UIColor.rgba(red: 13, green: 187, blue: 228, alpha: 1)
       // static let red = UIColor.rgba(red: 222, green: 135, blue: 134, alpha: 1)
        static let green = UIColor.rgba(red: 0, green: 194, blue: 69, alpha: 1)
        static let defaultColour = UIColor.rgba(red: 255, green: 255, blue: 255, alpha: 1)
    }
    
    enum BackgroundsColours {
        static let defaultColour = UIColor.rgba(red: 250, green: 240, blue: 218, alpha: 1)
    }
    
    enum Text {
        static let defaultColour = UIColor.rgba(red: 79, green: 77, blue: 80, alpha: 1)
        static let secondaryText = UIColor.rgba(red: 169, green: 168, blue: 172, alpha: 1)
    }

    enum Button {
        static let addButtonColour = UIColor.rgba(red: 66, green: 80, blue: 113, alpha: 1)
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

