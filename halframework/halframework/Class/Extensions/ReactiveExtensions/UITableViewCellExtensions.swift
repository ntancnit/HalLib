//
//  UITableViewCellExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITableViewCell {
    
    var accessoryType: Binder<UITableViewCellAccessoryType> {
        return Binder(self.base) { $0.accessoryType = $1 }
    }
    
    var selectionStyle: Binder<UITableViewCellSelectionStyle> {
        return Binder(self.base) { $0.selectionStyle = $1 }
    }
    
}







