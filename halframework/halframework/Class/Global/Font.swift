//
//  Font.swift
//  phimbo
//
//  Created by Dao Duy Duong on 10/23/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import UIKit

struct Font {
    
    static let system = System()
    static let helvetica = Helvetica()
    
    fileprivate static let standardScreenWidth: CGFloat = 375
    
}

protocol FontFactory {
    
    var normalName: String { get }
    var lightName: String { get }
    var boldName: String { get }
    
    func normal(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool) -> UIFont
    func light(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool) -> UIFont
    func bold(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool) -> UIFont
    
}

extension FontFactory {
    
    func normal(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        return UIFont(name: normalName, size: shouldScale ? calculateFontSize(size) : size)!
    }
    
    func light(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        return UIFont(name: lightName, size: shouldScale ? calculateFontSize(size) : size)!
    }
    
    func bold(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        return UIFont(name: boldName, size: shouldScale ? calculateFontSize(size) : size)!
    }
    
    fileprivate func calculateFontSize(_ standardSize: CGFloat) -> CGFloat {
        let maxSize = standardSize + (standardSize*0.15)
        let minSize = standardSize - (standardSize*0.15)
        
        let bounds = UIScreen.main.bounds
        let ratio = bounds.width/Font.standardScreenWidth
        
        var fontSize = standardSize*ratio
        
        if fontSize > maxSize {
            fontSize = maxSize
        }
        
        if fontSize < minSize {
            fontSize = minSize
        }
        
        return fontSize
    }
    
}

struct System: FontFactory {
    
    internal var normalName: String {
        return ""
    }
    internal var lightName: String {
        return ""
    }
    internal var boldName: String {
        return ""
    }
    
    func normal(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        return UIFont.systemFont(ofSize:  shouldScale ? calculateFontSize(size) : size)
    }
    
    func light(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        return UIFont.systemFont(ofSize:  shouldScale ? calculateFontSize(size) : size, weight: UIFont.Weight.light)
    }
    
    func bold(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        return UIFont.boldSystemFont(ofSize:  shouldScale ? calculateFontSize(size) : size)
    }
    
}

class Helvetica: FontFactory {
    
    internal var normalName: String {
        return "Helvetica"
    }
    internal var lightName: String {
        return "Helvetica-Light"
    }
    internal var boldName: String {
        return "Helvetica-Bold"
    }
    
}



