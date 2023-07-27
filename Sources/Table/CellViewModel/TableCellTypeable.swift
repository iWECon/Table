//
//  TableCellTypeable.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit

public protocol TableCellTypeable {
    var cellType: CellType { get }
}

extension TableCellTypeable {
    
    public var cellType: CellType {
        .class(UITableViewCell.self)
    }
    
}

public typealias TableCellViewModel = TableCellTypeable & TableCellHeightProvider
