//
//  DEViewController+UITableView.swift
//  Daily Esport
//
//  Created by Dao Duy Duong on 10/16/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

extension Reactive where Base: TablePage {
    
    var endReach: Observable<Void> {
        guard let tableView = base.tableView else { return Observable.never() }
        return Observable.create { observer in
            return tableView.rx.contentOffset.subscribe(onNext: { offset in
                let scrollViewHeight = tableView.frame.size.height
                let scrollContentSizeHeight = tableView.contentSize.height
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

class BasePage_TableView<VM: GenericListViewModel>: BasePage<VM>, TablePage, UITableViewDelegate {
    
    typealias CVM = VM.CellViewModelElement
    
    typealias TableDataSourceType = TableViewSectionedDataSource<SectionModel<String, CVM>>
    
    var tableView: UITableView!
    
    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, CVM>>!
    
    var tableViewStyle: UITableViewStyle = .plain
    
    override init(viewModel: VM? = nil) {
        super.init(viewModel: viewModel)
    }
    
    init(viewModel: VM? = nil, style: UITableViewStyle) {
        tableViewStyle = style
        super.init(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CVM>>(configureCell: configureCell)
        dataSource.canEditRowAtIndexPath = canEditRowAtIndexPath
        
        tableView = UITableView(frame: .zero, style: tableViewStyle)
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 500
        tableView.isExclusiveTouch = true
        view.addSubview(tableView)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initialize() {
        tableView.autoPin(toTopLayoutOf: self)
        tableView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        tableView.rx.setDelegate(self) => disposeBag
        
        viewModel.getDataSource() ~> tableView.rx.items(dataSource: dataSource) => disposeBag
        
        tableView.rx.itemSelected
            .subscribe(onNext: {
                guard let cvm = self.viewModel.itemAt($0) else { return }
                self.selectedItemWillChange(cvm)
                self.viewModel.itemSelected($0)
                self.selectedItemDidChange(cvm)
            }) => disposeBag
        
    }
    
    override func destroy() {
        super.destroy()
        tableView?.removeFromSuperview()
    }
    
    override func onLoading(_ value: Bool) {
        tableView.isHidden = value
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = viewModel.varItemsSource.value[indexPath.section]
        return heightFor(section.items[indexPath.row], ofSection: indexPath.section)
    }
    
    // MARK: - Table view factories
    
    func cellIdentifier(_ cellViewModel: CVM) -> String {
        return "Cell"
    }
    
    func heightFor(_ cellViewModel: CVM, ofSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func canEditRowAtIndexPath(_ dataSource: TableDataSourceType, indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func configureCell(_ dataSource: TableDataSourceType, tableView: UITableView, indexPath: IndexPath, cellViewModel: CVM) -> UITableViewCell {
        // default for on section list
        let identifier = cellIdentifier(cellViewModel)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! BaseTableCell<CVM>
        cell.viewModel = cellViewModel
        return cell
    }
    
    func selectedItemWillChange(_ cellViewModel: CVM) {}
    
    func selectedItemDidChange(_ cellViewModel: CVM) {}

}

class BasePage_AnimatableTableView<VM: GenericAnimatableListViewModel>: BasePage<VM>, TablePage, UITableViewDelegate {
    
    typealias CVM = VM.CellViewModelElement
    
    typealias TableDataSourceType = TableViewSectionedDataSource<AnimatableSectionModel<String, CVM>>
    
    var tableView: UITableView!
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, CVM>>!
    
    var tableViewStyle: UITableViewStyle = .plain
    
    override init(viewModel: VM? = nil) {
        super.init(viewModel: viewModel)
    }
    
    init(viewModel: VM? = nil, style: UITableViewStyle) {
        tableViewStyle = style
        super.init(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, CVM>>(configureCell: configureCell)
        dataSource.canEditRowAtIndexPath = canEditRowAtIndexPath
        tableView = UITableView(frame: .zero, style: tableViewStyle)
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 500
        tableView.isExclusiveTouch = true
        view.addSubview(tableView)
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func initialize() {
        tableView.autoPin(toTopLayoutOf: self)
        tableView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    override func onLoading(_ value: Bool) {
        tableView.isHidden = value
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        tableView.rx.setDelegate(self) => disposeBag
        
        viewModel.getDataSource() ~> tableView.rx.items(dataSource: dataSource) => disposeBag
        
        tableView.rx.itemSelected
            .subscribe(onNext: {
                guard let cvm = self.viewModel.itemAt($0) else { return }
                self.selectedItemWillChange(cvm)
                self.viewModel.itemSelected($0)
                self.selectedItemDidChange(cvm)
            }) => disposeBag
    }
    
    override func destroy() {
        super.destroy()
        tableView?.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = viewModel.varItemsSource.value[indexPath.section]
        return heightFor(section.items[indexPath.row], ofSection: indexPath.section)
    }
    
    // MARK: - Table view factories
    
    func cellIdentifier(_ cellViewModel: CVM) -> String {
        return "Cell"
    }
    
    func heightFor(_ cellViewModel: CVM, ofSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func canEditRowAtIndexPath(_ dataSource: TableDataSourceType, indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func configureCell(_ dataSource: TableDataSourceType, _ tableView: UITableView, _ indexPath: IndexPath, _ cellViewModel: CVM) -> UITableViewCell {
        // default for on section list
        let identifier = cellIdentifier(cellViewModel)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! BaseTableCell<CVM>
        cell.viewModel = cellViewModel
        return cell
    }
    
    func selectedItemWillChange(_ cellViewModel: CVM) {}
    
    func selectedItemDidChange(_ cellViewModel: CVM) {}
    
}











