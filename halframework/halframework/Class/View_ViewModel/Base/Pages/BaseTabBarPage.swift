//
//  BaseUITabBarController.swift
//  Snapshot
//
//  Created by NGUYỄN THANH ÂN on 3/7/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseTabBarPage<VM: GenericViewModel>: UITabBarController, GenericPage {
    
    var disposeBag: DisposeBag! = DisposeBag()
    var viewModel: VM!
    
    init(viewModel: VM? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .primaryBackgroundColor
        
        initialize()
        binding()
    }
    
    func initialize() {}
    func bindViewAndViewModel() {}
    
    func destroy() {
        disposeBag = nil
        viewModel?.destroy()
        print("destroy", self)
    }
    
    private func binding() {
        bindViewAndViewModel()
        viewModel?.react()
    }
}
