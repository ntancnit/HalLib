//
//  PrimaryButton.swift
//  Digital Maintenance Timestamp
//
//  Created by Do Trong Vuong on 6/1/18.
//  Copyright © 2018 NGUYỄN THANH ÂN. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class PrimaryButton : AbstractControlView {
    
    var button : UIButton!
    
    override func setupView() {
        backgroundColor = .clear
        button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.cornerRadius = 10
        button.setBackgroundImage(.from(color: .redColor), for: .normal)
        addSubview(button)
        button.autoPinEdgesToSuperviewEdges()
    }

    func setTitle(title: String) {
        button.setTitle(title, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.cornerRadius = min(frame.width, frame.height)/5
    }

}
