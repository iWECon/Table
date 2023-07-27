//
//  TableDataSource.swift
//  
//
//  Created by i on 2023/7/27.
//

import UIKit

open class TableDataSource: NSObject, UITableViewDataSource {
    
    public let viewModel: TableData
    public init(viewModel: TableData) {
        self.viewModel = viewModel
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.model(for: indexPath)
        let cellIdentifier = String(describing: cellViewModel.cellType)
        
        var cell: UITableViewCell
        if let _cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = _cell
        } else {
            // register and init
            switch cellViewModel.cellType {
            case .nib(let nib):
                tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
            case .class(let clazz):
                tableView.register(clazz, forCellReuseIdentifier: cellIdentifier)
            }
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        }
        
        if let setup = cell as? TableCellDataSetuper {
            setup.setupCellData(cellViewModel)
        }
        
        if var action = cell as? TableCellActionSender {
            action.actionSender = viewModel.tableCellActionResponder
        }
        
        print("cellForRowAt: \(indexPath)")
        return cell
    }
    
}
