//
//  ListTableData.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit

public protocol ListTableData: TableData {
    var data: [TableCellViewModel] { get }
}

extension ListTableData where Self: TableData {
    
    public var style: UITableView.Style {
        .plain
    }
    
    public func numberOfSections() -> Int {
        1
    }
    
    public func numberOfRows(in section: Int) -> Int {
        data.count
    }
    
    public func model(for indexPath: IndexPath) -> TableCellViewModel {
        data[indexPath.row]
    }
    
}
