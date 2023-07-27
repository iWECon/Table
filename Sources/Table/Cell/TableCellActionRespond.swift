//
//  TableCellActionRespond.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit

public protocol TableCellActionRespond {
    func tableCellActionRespond(_ action: TableCellAction)
}

public protocol TableCellDidSelectedRespond {
    
    /// Default is `(true, true)`
    /// Call tableView.deselectRow(at:,animated:) when set `true`.
    var deselectRow: (deselect: Bool, animated: Bool) { get }
    
    func tableCellDidSelect(at indexPath: IndexPath)
}

extension TableCellDidSelectedRespond {
    public var deselectRow: (deselect: Bool, animated: Bool) {
        (deselect: true, animated: true)
    }
}
