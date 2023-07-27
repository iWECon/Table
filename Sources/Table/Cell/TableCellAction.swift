//
//  TableCellAction.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit

public protocol TableCellAction {
    var identifier: String { get }
    var cell: UITableViewCell { get }
}

public struct DefaultTableCellAction: TableCellAction {
    public var identifier: String
    public var cell: UITableViewCell
    
    public init(identifier: String, cell: UITableViewCell) {
        self.identifier = identifier
        self.cell = cell
    }
}
