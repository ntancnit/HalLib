//
//  BaseView.swift
//  Daily Esport
//
//  Created by Dao Duy Duong on 10/7/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import UIKit
import RxSwift

class BaseView<VM: GenericViewModel>: UIView, GenericView {
    
    typealias ViewModelElement = VM
    
    var disposeBag: DisposeBag! = DisposeBag()
    var viewModel: VM! {
        didSet { resetBinding() }
    }
    
    init(viewModel: VM? = nil) {
        self.viewModel = viewModel
        super.init(frame: CGRect.zero)
        setup()
        resetBinding()
    }
    
    init(frame: CGRect, viewModel: VM? = nil) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setup()
        resetBinding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        backgroundColor = .clear
        initialize()
    }
    
    private func resetBinding() {
        guard let viewModel = viewModel else { return }
        
        disposeBag = DisposeBag()
        viewModel.disposeBag = DisposeBag()
        
        bindViewAndViewModel()
        viewModel.react()
    }
    
    func initialize() {}
    func bindViewAndViewModel() {}
    
    func destroy() {
        disposeBag = nil
        viewModel?.destroy()
    }

}

class BaseCollectionCell<VM: GenericCellViewModel>: UICollectionViewCell, GenericView {
    
    typealias ViewModelElement = VM
    
    var disposeBag: DisposeBag! = DisposeBag()
    var viewModel: VM! {
        didSet { resetBinding() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        destroy()
    }
    
    private func setup() {
        backgroundColor = .clear
        initialize()
    }
    
    private func resetBinding() {
        disposeBag = DisposeBag()
        viewModel?.disposeBag = DisposeBag()
        
        bindViewAndViewModel()
        viewModel?.react()
    }
    
    func destroy() {
        disposeBag = nil
        viewModel?.disposeBag = nil
    }
    
    func initialize() {}
    func bindViewAndViewModel() {}
    
}

class BaseTableCell<VM: GenericCellViewModel>: UITableViewCell, GenericView {
    
    typealias ViewModelElement = VM
    
    var disposeBag: DisposeBag! = DisposeBag()
    var viewModel: VM! {
        didSet { resetBinding() }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        destroy()
    }
    
    private func setup() {
        backgroundColor = .clear
        separatorInset = .zero
        layoutMargins = .zero
        preservesSuperviewLayoutMargins = false
        
        initialize()
    }
    
    private func resetBinding() {
        disposeBag = DisposeBag()
        viewModel?.disposeBag = DisposeBag()
        
        bindViewAndViewModel()
        viewModel?.react()
    }
    
    func destroy() {
        disposeBag = nil
        viewModel?.disposeBag = nil
    }
    
    func initialize() {}
    func bindViewAndViewModel() {}
    
}










