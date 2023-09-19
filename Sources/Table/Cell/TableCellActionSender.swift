//
//  TableCellActionSender.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit

public protocol TableCellActionSender: AnyObject {
    /// Please declare it as weak
    var actionSender: TableCellActionRespond? { get set }
    
    /// The indexPath of cell (will be set in `tableView(_:cellForRow:)`)
    var indexPath: IndexPath? { get set }
}

private struct TableCellActionSenderAssociatedKeys {
    static var indexPath: UInt8 = 0
}

extension TableCellActionSender {
    public var indexPath: IndexPath? {
        get { objc_getAssociatedObject(self, &TableCellActionSenderAssociatedKeys.indexPath) as? IndexPath }
        set {
            objc_setAssociatedObject(self, &TableCellActionSenderAssociatedKeys.indexPath, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
