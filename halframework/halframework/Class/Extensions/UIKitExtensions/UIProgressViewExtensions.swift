//
//  UIProgressViewExtension.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit

extension UIProgressView {
    
    func setProgress(_ progress: Float, animated: Bool, completion: @escaping (() -> Void)) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.setProgress(progress, animated: animated)
        CATransaction.commit()
    }
    
}




