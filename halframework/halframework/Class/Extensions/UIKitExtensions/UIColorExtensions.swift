//
//  UIColorExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int) {
        self.init(hex: hex, a: 1.0)
    }
    
    convenience init(hex: Int, a: CGFloat) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff, a: a)
    }
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    static func hex(_ hexString: String) -> UIColor {
        return UIColor(hexString: hexString) ?? UIColor.clear
    }
    
    convenience init?(hexString: String) {
        let hexString = hexString.replacingOccurrences(of: "#", with: "")
        guard let hex = hexString.hex else { return nil }
        self.init(hex: hex)
    }

}

extension UIColor {
    
    static let cellColor: UIColor = UIColor(r: 205, g: 217, b: 222)
    static let buttonNormal: UIColor = UIColor(r: 120, g: 141, b: 146)
    static let headerBackground: UIColor = UIColor(r: 127, g: 146, b: 151)
    
    static let textColor : UIColor = UIColor(r: 152, g: 167, b: 172)
    
    static let primaryColor: UIColor = .hex("#ff2a00")
    static let secondaryColor: UIColor = .hex("#2979FF")
    
    static let primaryTextColor: UIColor = .white
    static let secondaryTextColor: UIColor = UIColor(r: 155, g: 155, b: 155)
    static let primaryBackgroundColor: UIColor = UIColor(hexString: "#282828")!

    static let secondaryBackgroundColor: UIColor = .black
    static let jobSummaryHeaderColor: UIColor = UIColor(r: 238, g: 542, b: 546)
    static let grayText: UIColor = UIColor(r: 155, g: 155, b: 155)
    static let tableSeparator: UIColor = .hex("#aeadb2")
    static let nptStatusColor: UIColor = .hex("#c90b14")
    static let locationViewBackgroundColor: UIColor = UIColor(r: 228, g: 228, b: 228)
    static let iconStarGrayColor: UIColor = UIColor(r: 216, g: 216, b: 216)
    static let iconYellowColor: UIColor = UIColor(r: 248, g: 231, b: 28)
    
    static let redColor: UIColor = UIColor(r: 204, g: 0, b: 0)
    static let greenColor: UIColor = UIColor(r: 102, g:186, b: 0)
}










