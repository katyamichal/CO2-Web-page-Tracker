//
//  UIFont + CustomFont.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 17.06.2024.
//

import UIKit

enum Fonts {

    enum Titles {
        static let mainTitle = UIFont.cachedFont(name: "Georgia-Bold", size: 21)
        static let subtitle = UIFont.cachedFont(name: "Georgia", size: 18)
    }

    enum Body {
        static let largeFont = UIFont.cachedFont(name: "Georgia-Bold", size: 60)
        static let defaultFont = UIFont.cachedFont(name: "CourierNewPS-BoldMT", size: 16)
        static let secondaryFont = UIFont.cachedFont(name: "CourierNewPS-BoldMT", size: 14)
        static let descriptionFont = UIFont.cachedFont(name: "CourierNewPS-BoldMT", size: 21)
    }

    enum Buttons {
        static let primaryButtonFont = UIFont.cachedFont(name: "Georgia-Bold", size: 16)
    }
}

extension UIFont {
    
    private static var fontCache: [String: UIFont] = [:]
    
    public static func cachedFont(name: String, size: CGFloat) -> UIFont {
        
        let key = "\(name)\(size)"
        if let cachedFont = self.fontCache[key] {
            return cachedFont
        }
        self.clearFontCacheIfNeeded()
        guard let font = UIFont(name: name, size: size) else {
            fatalError("Failed to load font: \(name) with size: \(size)")
        }
        self.fontCache[key] = font
        
        return font
    }
    
    private static func clearFontCacheIfNeeded() {
        let maxObjectCount = 100
        
        guard self.fontCache.count >= maxObjectCount else { return }
        self.fontCache = [:]
    }
}
