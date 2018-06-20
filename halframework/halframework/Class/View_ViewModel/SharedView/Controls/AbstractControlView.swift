//
//  AbstractControlView.swift
//  phimbo
//
//  Created by Dao Duy Duong on 10/8/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import UIKit

public class AbstractControlView: UIControl {

    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {}

}







