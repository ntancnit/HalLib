//
//  SyncButton.swift
//  DMT
//
//  Created by Dao Duy Duong on 6/13/18.
//  Copyright © 2018 NGUYỄN THANH ÂN. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: SyncButton {
    
    var isSyncing: Binder<Bool> {
        return Binder(base) { $0.isSyncing = $1 }
    }
    
}


class SyncButton: UIButton {
    
    lazy var syncAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = 2*Float.pi
        animation.duration = 1
        animation.repeatCount = Float.infinity
        
        return animation
    }()
    
    var isSyncing: Bool = false {
        didSet {
            if isSyncing {
                layer.add(syncAnimation, forKey: "syncanimation")
            } else {
                layer.removeAllAnimations()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        setImage(UIImage(named: "sync_icon"), for: .normal)
    }
    
    
    
}
