//
//  DEViewController+UICollectionView.swift
//  Daily Esport
//
//  Created by Dao Duy Duong on 10/16/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

extension Reactive where Base: CollectionPage {
    
    var endReach: Observable<Void> {
        guard let collectionView = base.collectionView else { return Observable.never() }
        return Observable.create { observer in
            return collectionView.rx.contentOffset.subscribe(onNext: { offset in
                let scrollViewHeight = collectionView.frame.size.height
                let scrollContentSizeHeight = collectionView.contentSize.height
                let scrollOffset = offset.y
                
                let scrollSize = scrollOffset + scrollViewHeight
                
                // at the bottom
                if scrollSize >= scrollContentSizeHeight - 50 {
                    observer.onNext(())
                }
            })
        }
    }
    
}

class BasePage_CollectionView<VM: GenericListViewModel>: BasePage<VM>, CollectionPage, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    typealias CVM = VM.CellViewModelElement
    
    typealias CollectionDataSourceType = CollectionViewSectionedDataSource<SectionModel<String, CVM>>
    
    var collectionView: UICollectionView!
    var layout: UICollectionViewLayout!
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<String, CVM>>!
    
    override init(viewModel: VM? = nil) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, CVM>>(configureCell: configureCell, configureSupplementaryView: configureSupplementaryView)
        
        setupLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.layout?.invalidateLayout()
        }, completion: nil)
    }
    
    // MARK: - Collection view setup
    
    override func initialize() {
        super.initialize()
        
        collectionView.autoPinEdgesToSuperviewEdges()
    }
    
    override func onLoading(_ value: Bool) {
        collectionView.isHidden = value
    }
    
    func setupLayout() {
        layout = UICollectionViewFlowLayout()
    }
    
    // MARK: - Binding
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        collectionView.rx.setDelegate(self) => disposeBag
        viewModel.getDataSource() ~> collectionView.rx.items(dataSource: dataSource) => disposeBag
        
        collectionView.rx.itemSelected
            .subscribe(onNext: {
                guard let cvm = self.viewModel.itemAt($0) else { return }
                self.selectedItemWillChange(cvm)
                self.viewModel.itemSelected($0)
                self.selectedItemDidChange(cvm)
            }) => disposeBag
    }
    
    override func destroy() {
        super.destroy()
        collectionView.removeFromSuperview()
    }
    
    // MARK: - Collection view factories
    
    func cellIdentifier(_ cellViewModel: CVM) -> String {
        return "Cell"
    }
    
    func configureCell(_ dataSource: CollectionDataSourceType, collectionView: UICollectionView, indexPath: IndexPath, cellViewModel: CVM) -> UICollectionViewCell {
        let identifier = cellIdentifier(cellViewModel)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! BaseCollectionCell<CVM>
        cell.viewModel = cellViewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func configureSupplementaryView(_ dataSource: CollectionDataSourceType, collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        return (nil as UICollectionReusableView?)!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func selectedItemWillChange(_ cellViewModel: CVM) {}
    
    func selectedItemDidChange(_ cellViewModel: CVM) {}

}













