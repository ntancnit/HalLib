//
//  UITextField.swift
//  Snapshot
//
//  Created by NGUYỄN THANH ÂN on 3/19/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import UIKit

extension UITextField {
    
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    func setDefaultStyle (hintText: String = "") {
        self.attributedPlaceholder = NSAttributedString(string: hintText, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightText])
        self.textContentType = .username
        self.backgroundColor = .darkGray
        self.layer.cornerRadius = 10
        self.textColor = .white
        self.addPadding(.both(5))
    }
    
    func addPadding(_ padding: PaddingSide) {
        
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        
        
        switch padding {
            
        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always
            
        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always
            
        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}
