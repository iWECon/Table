//
//  TableDataSource.swift
//  
//
//  Created by i on 2023/7/27.
//

import UIKit
import Dispatch

/// Default inhert `UITableViewDataSource`, `UITableViewDataSourcePrefetching`
open class TableDataSource: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    public let viewModel: TableDataProvider
    public init(viewModel: TableDataProvider) {
        self.viewModel = viewModel
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.cellViewModel(for: indexPath)
        let cellIdentifier = String(describing: cellViewModel.cellType)
        
        var cell: UITableViewCell
        if let _cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = _cell
        } else {
            // register and dequeue reuseable 
            switch cellViewModel.cellType {
            case .nib(let nib):
                tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
            case .class(let clazz):
                tableView.register(clazz, forCellReuseIdentifier: cellIdentifier)
            }
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        }
        
        // setup data
        if let setup = cell as? TableCellDataSetuper {
            setup.setupData(cellViewModel)
        }
        
        // bind action responder
        if let action = cell as? TableCellActionSender {
            action.actionSender = viewModel.cellActionResponder
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let prefetchingViewModel = viewModel as? TablePrefetchData else { return }
        prefetchingViewModel.prefetch(rowsAt: indexPaths)
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        guard let prefetchingViewModel = viewModel as? TablePrefetchData else { return }
        prefetchingViewModel.cancelPrefetching(rowsAt: indexPaths)
    }
}
