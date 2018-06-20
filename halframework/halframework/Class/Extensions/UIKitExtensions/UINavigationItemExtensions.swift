//
//  UINavigationItemExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit

extension UINavigationItem {
    
    @discardableResult
    func setTitle(_ title: String? = nil, alignment: NSTextAlignment = .center) -> UILabel {
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLbl.textColor = .white
        titleLbl.text = title
        titleLbl.textAlignment = alignment
        titleLbl.font = Font.system.bold(withSize: 18)
        titleView = titleLbl
    
        return titleLbl
    }
    
}








