//
//  InlineLoaderView.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 4/24/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: InlineLoaderView {
    
    var show: Binder<Bool> {
        return Binder(self.base) { view, value in
            if value {
                view.isHidden = false
                view.indicatorView.startAnimating()
            } else {
                view.isHidden = true
                view.indicatorView.stopAnimating()
            }
        }
    }
    
}

class InlineLoaderView: AbstractControlView {
    
    let label = UILabel()
    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    override func setupView() {
        indicatorView.hidesWhenStopped = true
        indicatorView.color = .white
        addSubview(indicatorView)
        indicatorView.autoAlignAxis(toSuperviewAxis: .vertical)
        indicatorView.autoPinEdge(toSuperviewEdge: .top)
        
        label.textColor = .lightText
        label.font = Font.helvetica.normal(withSize: 15)
        addSubview(label)
        label.autoPinEdge(.top, to: .bottom, of: indicatorView, withOffset: 3)
        label.autoAlignAxis(toSuperviewAxis: .vertical)
        label.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
}
