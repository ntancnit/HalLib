//
//  ViewModel.swift
//  Daily Esport
//
//  Created by Dao Duy Duong on 10/7/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

// MARK: - Base view model

class ViewModel<M: Model>: NSObject, GenericViewModel {
    
    typealias ModelElement = M
    
    var model: M!
    var disposeBag: DisposeBag! = DisposeBag()
    
    let varViewState = Variable<ViewState>(.none)
    let varLoading = Variable(false)
    
    required init(model: M?) {
        self.model = model
    }
    
    func destroy() {
        disposeBag = nil
    }
    
    func react() {}
    
}

// MARK: - list viewmodel, support multiple sections

class ListViewModel<M: Model, CVM: GenericCellViewModel & Hashable>: ViewModel<M>, GenericListViewModel where CVM.ModelElement: Model {
    
    typealias CellViewModelElement = CVM
    
    typealias SectionType = SectionModel<String, CVM>
    typealias ItemsSourceType = [SectionType]
    
    let varItemsSource = Variable<ItemsSourceType>([SectionModel(model: "", items: [])])
    let varSelectedItem = Variable<CVM?>(nil)
    
    let varSelectedIndex = Variable<IndexPath?>(nil)
    
    required init(model: M?) {
        super.init(model: model)
    }
    
    override func destroy() {
        super.destroy()
        
        for section in varItemsSource.value {
            for cvm in section.items {
                cvm.destroy()
            }
        }
    }
    
    // MARK: - Insert & Remove
    
    func insertItem(_ item: CVM, toRow rowIndex: Int, ofSection sectionIndex: Int) {
        if sectionIndex >= 0 && sectionIndex < varItemsSource.value.count {
            varItemsSource.value[sectionIndex].items.insert(item, at: rowIndex)
        }
    }
    
    func insertSection(_ sectionIndex: Int, items: [CVM]) {
        let section = SectionModel(model: "", items: items)
        varItemsSource.value.insert(section, at: sectionIndex)
    }
    
    func insertItems(_ items: [CVM], atRow rowIndex: Int, ofSection sectionIndex: Int) {
        if sectionIndex >= 0 && sectionIndex < varItemsSource.value.count {
            varItemsSource.value[sectionIndex].items.insert(contentsOf: items, at: rowIndex)
        }
    }
    
    func appendItems(_ items: [CVM], toSection sectionIndex: Int = 0) {
        if let _ = sectionAt(sectionIndex) {
            varItemsSource.value[sectionIndex].items.append(contentsOf: items)
        }
        
        if sectionIndex < 0 {
            varItemsSource.value.append(SectionModel(model: "", items: items))
        }
    }
    
    func appendItemsToTop(_ items: [CVM], toSection sectionIndex: Int = 0) {
        if let _ = sectionAt(sectionIndex) {
            insertItems(items, atRow: 0, ofSection: sectionIndex)
        }
        
        if sectionIndex < 0 {
            varItemsSource.value.append(SectionModel(model: "", items: items))
        }
    }
    
    @discardableResult
    func removeAt(_ rowIndex: Int, ofSection sectionIndex: Int) -> CVM? {
        if sectionIndex >= 0 && sectionIndex < varItemsSource.value.count {
            let cvm = varItemsSource.value[sectionIndex].items.remove(at: rowIndex)
            return cvm
        }
        
        return nil
    }
    
    // MARK: - Return data source for table/collection view
    
    func getDataSource() -> Observable<ItemsSourceType> {
        return varItemsSource.asObservable()
    }
    
    func reloadDataSource() {
        varItemsSource.value = varItemsSource.value
    }
    
    // MARK: - Sources manipulating
    
    func makeSources(_ items: [String:[CVM.ModelElement]]) -> ItemsSourceType {
        return items.map { group in
            let cvms = Util.transformResponses(group.value) as [CVM]
            return SectionModel(model: group.key, items: cvms)
        }
    }
    
    func makeSources(_ items: [String:[CVM]]) -> ItemsSourceType {
        return items.map { SectionModel(model: $0.key, items: $0.value) }
    }
    
    func makeSources(_ items: [[CVM.ModelElement]]) -> ItemsSourceType {
        return items.map { SectionModel(model: "", items: Util.transformResponses($0)) }
    }
    
    func makeSources(_ items: [[CVM]]) -> ItemsSourceType {
        return items.map { SectionModel(model: "", items: $0) }
    }
    
    func makeSources(_ items: [CVM.ModelElement]) -> ItemsSourceType {
        return [SectionModel(model: "", items: Util.transformResponses(items))]
    }
    
    func makeSources(_ items: [CVM]) -> ItemsSourceType {
        return [SectionModel(model: "", items: items)]
    }
    
    func setSources(_ items: [[CVM.ModelElement]]) {
        varItemsSource.value = makeSources(items)
    }
    
    func setSources(_ items: [[CVM]]) {
        varItemsSource.value = makeSources(items)
    }
    
    func setSources(_ items: [CVM.ModelElement]) {
        varItemsSource.value = makeSources(items)
    }
    
    func setSources(_ items: [CVM]) {
        varItemsSource.value = makeSources(items)
    }
    
    func itemSelected(_ indexPath: IndexPath) {
        guard let cvm = itemAt(indexPath) else { return }
        
        selectedItemWillChange(cvm)
        
        varSelectedIndex.value = indexPath
        varSelectedItem.value = itemAt(indexPath)
        
        selectedItemDidChange(cvm)
    }
    
    // MARK: - Selected item
    
    func selectedItemWillChange(_ cellViewModel: CVM) {}
    
    func selectedItemDidChange(_ cellViewModel: CVM) {}
    
    // MARK: - Get item at specific index/section
    
    func sectionsCount() -> Int {
        return varItemsSource.value.count
    }
    
    func itemsCount(_ sectionIndex: Int) -> Int {
        return sectionAt(sectionIndex)?.items.count ?? 0
    }
    
    func sectionAt(_ index: Int) -> SectionType? {
        if index >= 0 && index < varItemsSource.value.count {
            return varItemsSource.value[index]
        }
        
        return nil
    }
    
    func itemAt(row: Int, section: Int = 0) -> CVM? {
        let sectionModel = sectionAt(section)
        return sectionModel?.items[row]
    }
    
    func itemAt(_ indexPath: IndexPath) -> CVM? {
        return itemAt(row: indexPath.row, section: indexPath.section)
    }
    
    // MARK: - Find helpers
    
    func find(_ model: CVM.ModelElement) -> CVM? {
        for sectionModel in varItemsSource.value {
            let items = sectionModel.items.filter {
                return $0.model == model
            }
            
            if items.count > 0 {
                return items.first
            }
        }
        
        return nil
    }
    
    func findIndex(_ model: CVM.ModelElement) -> IndexPath? {
        for (i, sectionModel) in varItemsSource.value.enumerated() {
            let row = sectionModel.items.index { $0.model == model }
            
            if let row = row {
                return IndexPath(row: row, section: i)
            }
        }
        
        return nil
    }
    
    func findIndex(_ cvm: CVM) -> IndexPath? {
        for (i, sectionModel) in varItemsSource.value.enumerated() {
            let row = sectionModel.items.index(of: cvm)
            
            if let row = row {
                return IndexPath(row: row, section: i)
            }
        }
        
        return nil
    }
    
}

class AnimatableListViewModel<M: Model, CVM: GenericCellViewModel>: ViewModel<M>, GenericAnimatableListViewModel where CVM.ModelElement: Model {
    
    typealias CellViewModelElement = CVM
    
    typealias SectionType = AnimatableSectionModel<String, CVM>
    typealias ItemsSourceType = [SectionType]
    
    let varItemsSource = Variable<ItemsSourceType>([AnimatableSectionModel(model: "", items: [])])
    let varSelectedItem = Variable<CVM?>(nil)
    
    let varSelectedIndex = Variable<IndexPath?>(nil)
    
    required init(model: M?) {
        super.init(model: model)
    }
    
    override func destroy() {
        super.destroy()
        
        for section in varItemsSource.value {
            for cvm in section.items {
                cvm.destroy()
            }
        }
    }
    
    // MARK: - Append, Insert & Remove
    
    func insertItem(_ item: CVM, toRow rowIndex: Int, ofSection sectionIndex: Int) {
        if sectionIndex >= 0 && sectionIndex < varItemsSource.value.count {
            varItemsSource.value[sectionIndex].items.insert(item, at: rowIndex)
        }
    }
    
    func insertSection(_ sectionIndex: Int, items: [CVM]) {
        let section = AnimatableSectionModel(model: "", items: items)
        varItemsSource.value.insert(section, at: sectionIndex)
    }
    
    func insertItems(_ items: [CVM], atRow rowIndex: Int, ofSection sectionIndex: Int) {
        if sectionIndex >= 0 && sectionIndex < varItemsSource.value.count {
            varItemsSource.value[sectionIndex].items.insert(contentsOf: items, at: rowIndex)
        }
    }
    
    func appendItems(_ items: [CVM], toSection sectionIndex: Int = 0) {
        if let _ = sectionAt(sectionIndex) {
            varItemsSource.value[sectionIndex].items.append(contentsOf: items)
        }
        
        if sectionIndex < 0 {
            varItemsSource.value.append(AnimatableSectionModel(model: "", items: items))
        }
    }
    
    func appendItemsToTop(_ items: [CVM], toSection sectionIndex: Int = 0) {
        if let _ = sectionAt(sectionIndex) {
            insertItems(items, atRow: 0, ofSection: sectionIndex)
        }
        
        if sectionIndex < 0 {
            varItemsSource.value.append(AnimatableSectionModel(model: "", items: items))
        }
    }
    
    @discardableResult
    func removeAt(_ rowIndex: Int, ofSection sectionIndex: Int) -> CVM? {
        if sectionIndex >= 0 && sectionIndex < varItemsSource.value.count {
            let cvm = varItemsSource.value[sectionIndex].items.remove(at: rowIndex)
            return cvm
        }
        
        return nil
    }
    
    // MARK: - Return data source for table/collection view
    
    func getDataSource() -> Observable<ItemsSourceType> {
        return varItemsSource.asObservable()
    }
    
    func reloadDataSource() {
        varItemsSource.value = varItemsSource.value
    }
    
    // MARK: - Sources manipulating
    
    func makeSources(_ items: [String:[CVM.ModelElement]]) -> ItemsSourceType {
        return items.map { group in
            let cvms = Util.transformResponses(group.value) as [CVM]
            return AnimatableSectionModel(model: group.key, items: cvms)
        }
    }
    
    func makeSources(_ items: [String:[CVM]]) -> ItemsSourceType {
        return items.map { AnimatableSectionModel(model: $0.key, items: $0.value) }
    }
    
    func makeSources(_ items: [[CVM.ModelElement]]) -> ItemsSourceType {
        return items.map { AnimatableSectionModel(model: "", items: Util.transformResponses($0)) }
    }
    
    func makeSources(_ items: [[CVM]]) -> ItemsSourceType {
        return items.map { AnimatableSectionModel(model: "", items: $0) }
    }
    
    func makeSources(_ items: [CVM.ModelElement]) -> ItemsSourceType {
        return [AnimatableSectionModel(model: "", items: Util.transformResponses(items))]
    }
    
    func makeSources(_ items: [CVM]) -> ItemsSourceType {
        return [AnimatableSectionModel(model: "", items: items)]
    }
    
    func setSources(_ items: [[CVM.ModelElement]]) {
        varItemsSource.value = makeSources(items)
    }
    
    func setSources(_ items: [[CVM]]) {
        varItemsSource.value = makeSources(items)
    }
    
    func setSources(_ items: [CVM.ModelElement]) {
        varItemsSource.value = makeSources(items)
    }
    
    func setSources(_ items: [CVM]) {
        varItemsSource.value = makeSources(items)
    }
    
    func itemSelected(_ indexPath: IndexPath) {
        guard let cvm = itemAt(indexPath) else { return }
        
        selectedItemWillChange(cvm)
        
        varSelectedIndex.value = indexPath
        varSelectedItem.value = itemAt(indexPath)
        
        selectedItemDidChange(cvm)
    }
    
    // MARK: - Selected item
    
    func selectedItemWillChange(_ cellViewModel: CVM) {}
    
    func selectedItemDidChange(_ cellViewModel: CVM) {}
    
    // MARK: - Get item at specific index/section
    
    func sectionsCount() -> Int {
        return varItemsSource.value.count
    }
    
    func itemsCount(_ sectionIndex: Int) -> Int {
        return sectionAt(sectionIndex)?.items.count ?? 0
    }
    
    func sectionAt(_ index: Int) -> SectionType? {
        if index >= 0 && index < varItemsSource.value.count {
            return varItemsSource.value[index]
        }
        
        return nil
    }
    
    func itemAt(row: Int, section: Int = 0) -> CVM? {
        let sectionModel = sectionAt(section)
        return sectionModel!.items[row]
    }
    
    func itemAt(_ indexPath: IndexPath) -> CVM? {
        return itemAt(row: indexPath.row, section: indexPath.section)
    }
    
    // MARK: - Find helpers
    
    func find(_ model: CVM.ModelElement) -> CVM? {
        for sectionModel in varItemsSource.value {
            let items = sectionModel.items.filter {
                return $0.model == model
            }
            
            if items.count > 0 {
                return items.first
            }
        }
        
        return nil
    }
    
    func findIndex(_ model: CVM.ModelElement) -> IndexPath? {
        for (i, sectionModel) in varItemsSource.value.enumerated() {
            let row = sectionModel.items.index { $0.model == model }
            
            if let row = row {
                return IndexPath(row: row, section: i)
            }
        }
        
        return nil
    }
    
    func findIndex(_ cvm: CVM) -> IndexPath? {
        for (i, sectionModel) in varItemsSource.value.enumerated() {
            let row = sectionModel.items.index(of: cvm)
            
            if let row = row {
                return IndexPath(row: row, section: i)
            }
        }
        
        return nil
    }
    
}

class HeaderListViewModel<M: Model, CVM: GenericCellViewModel & Hashable, HVM: GenericCellViewModel>: ListViewModel<M, CVM>, GenericHeaderListViewModel where CVM.ModelElement: Model, HVM.ModelElement: Model {
    
    typealias HeaderViewModelElement = HVM
    
    let varHeadersSource = Variable<[HVM?]>([])
    
    required init(model: M?) {
        super.init(model: model)
    }
    
    override func destroy() {
        super.destroy()
        
        for cvm in varHeadersSource.value {
            cvm?.destroy()
        }
    }
    
    func headerAt(_ sectionIndex: Int) -> HVM? {
        if sectionIndex >= 0 && sectionIndex < varHeadersSource.value.count {
            return varHeadersSource.value[sectionIndex]
        }
        
        return nil
    }
    
}

// MARK: - Cell viewmodel

class CellViewModel<M: Model>: ViewModel<M>, GenericCellViewModel {
    
    typealias Identity = String
    
    var identity: String {
        return UUID().uuidString
    }
    
    required init(model: M?) {
        super.init(model: model)
    }
    
}

class SuperCellViewModel: CellViewModel<Model> {
    
    required init(model: Model?) {
        super.init(model: model)
    }
}














