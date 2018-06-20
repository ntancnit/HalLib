//
//  DEViewController.swift
//  Daily Esport
//
//  Created by Dao Duy Duong on 10/6/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import PureLayout

class BasePage<VM: GenericViewModel>: UIViewController, GenericPage, UIGestureRecognizerDelegate {
    
    var disposeBag: DisposeBag! = DisposeBag()
    
    var viewModel: VM!
    
    var btnMenu: UIBarButtonItem?
    
    var btnLogout: UIBarButtonItem?
    
    var loaderView: InlineLoaderView!
    
    var enableLogoutButton: Bool = false {
        didSet {
            if enableLogoutButton {
                navigationItem.rightBarButtonItem = btnLogout
            } else {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    var enableBackButton: Bool = false {
        didSet {
            if enableBackButton {
                let backBtn = UIBarButtonItem(image: UIImage(named: "icon_backButton"), style: .plain, target: self, action: #selector(backButtonPressed))
                navigationItem.leftBarButtonItem = backBtn
            } else {
                navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    init(viewModel: VM? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.primaryBackgroundColor
        loaderView = InlineLoaderView()
        view.addSubview(loaderView)
        loaderView.autoCenterInSuperview()
        
        initialize()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.varViewState.value = .willAppear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.varViewState.value = .didAppear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.varViewState.value = .willDisappear
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.varViewState.value = .didDisappear
    }
    
    // MARK: - For subclass to override
    
    func initialize() {}
    
    func bindViewAndViewModel() {}
    
    func destroy() {
        disposeBag = nil
        viewModel?.disposeBag = nil
        print("destroy", self)
    }
    
    @objc func backButtonPressed() {
        NavigationUtil.pop()
    }
    
    func onLoading(_ value: Bool) {}
    
    // MARK: - Private
    
    private func binding() {
        disposeBag = DisposeBag()
        viewModel?.disposeBag = DisposeBag()
        
        bindViewAndViewModel()
        viewModel?.react()
        
        // binding for loading
        if let viewModel = viewModel {
            viewModel.varLoading ~> loaderView.rx.show => disposeBag
            viewModel.varLoading.asObservable().subscribe(onNext: onLoading) => disposeBag
        }
    }
    
}






