//
//  UIAlertAction.swift
//  Snapshot
//
//  Created by NGUYỄN THANH ÂN on 3/8/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import UIKit

extension UIAlertAction {
    
    func setTextColor(_ color: UIColor) {
        self.setValue(color, forKey: "titleTextColor")
    }

}
