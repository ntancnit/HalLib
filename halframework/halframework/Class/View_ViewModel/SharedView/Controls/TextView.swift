//
//  TextView.swift
//  Digital Maintenance Timestamp
//
//  Created by Do Trong Vuong on 6/3/18.
//  Copyright © 2018 NGUYỄN THANH ÂN. All rights reserved.
//

import UIKit

class TextView: AbstractView {
    
    var contentLbl : UILabel!
    
    override func setupView() {
        backgroundColor = .cellColor
        
        contentLbl = UILabel()
        contentLbl.numberOfLines = 1
        addSubview(contentLbl)
        contentLbl.autoPinEdgesToSuperviewEdges(with: .equally(5))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cornerRadius = 5
    }
    
}
