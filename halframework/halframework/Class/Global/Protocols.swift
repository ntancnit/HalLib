//
//  Protocols.swift
//  phimbo
//
//  Created by Dao Duy Duong on 8/29/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

protocol Destroyable: class {
    var disposeBag: DisposeBag! { get set }
    func destroy()
}

protocol GenericPage: Destroyable {
    associatedtype ViewModelElement
    
    var viewModel: ViewModelElement! { get set }
    
    func initialize()
    func bindViewAndViewModel()
}

protocol CollectionPage {
    var collectionView: UICollectionView! { get }
    var layout: UICollectionViewLayout! { get }
}

protocol TablePage {
    var tableView: UITableView! { get }
}

// MARK: - Viewmodel protocols

protocol GenericViewModel: Destroyable {
    associatedtype ModelElement
    
    var model: ModelElement! { get }
    var disposeBag: DisposeBag! { get set }
    
    var varViewState: Variable<ViewState> { get }
    var varLoading: Variable<Bool> { get }
    
    init(model: ModelElement?)
    func react()
}

protocol GenericListViewModel: GenericViewModel {
    associatedtype CellViewModelElement: GenericCellViewModel
    
    var varItemsSource: Variable<[SectionModel<String, CellViewModelElement>]> { get }
    var varSelectedItem: Variable<CellViewModelElement?> { get }
    
    func getDataSource() -> Observable<[SectionModel<String, CellViewModelElement>]>
    
    func itemSelected(_ indexPath: IndexPath)
    func itemAt(_ indexPath: IndexPath) -> CellViewModelElement?
}

protocol GenericAnimatableListViewModel: GenericViewModel {
    associatedtype CellViewModelElement: GenericCellViewModel
    
    var varItemsSource: Variable<[AnimatableSectionModel<String, CellViewModelElement>]> { get }
    var varSelectedItem: Variable<CellViewModelElement?> { get }
    
    func getDataSource() -> Observable<[AnimatableSectionModel<String, CellViewModelElement>]>
    
    func itemSelected(_ indexPath: IndexPath)
    func itemAt(_ indexPath: IndexPath) -> CellViewModelElement?
}

protocol GenericHeaderListViewModel: GenericListViewModel {
    associatedtype HeaderViewModelElement: GenericCellViewModel
    
    var varHeadersSource: Variable<[HeaderViewModelElement?]> { get }
    
    func headerAt(_ sectionIndex: Int) -> HeaderViewModelElement?
}

protocol GenericCellViewModel: GenericViewModel, IdentifiableType, Hashable { }

// MARK: - View protocols

protocol GenericView: Destroyable {
    associatedtype ViewModelElement
    
    var viewModel: ViewModelElement! { get set }
    
    func initialize()
    func bindViewAndViewModel()
}
















