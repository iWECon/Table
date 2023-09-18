//
//  TableCellTypeProvider.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit

public protocol TableCellTypeProvider {
    var cellType: TableCellType { get }
}

extension TableCellTypeProvider {
    
    public var cellType: TableCellType {
        .class(UITableViewCell.self)
    }
    
}
