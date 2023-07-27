//
//  TableCellActionSender.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit

public protocol TableCellActionSender {
    var actionSender: TableCellActionRespond? { get set }
}

private struct TableCellActionSenderAssociatedKeys {
    static var actionSender = "actionSender"
}

extension TableCellActionSender where Self: UITableViewCell {
    
    public var actionSender: TableCellActionRespond? {
        get {
            objc_getAssociatedObject(self, &TableCellActionSenderAssociatedKeys.actionSender) as? TableCellActionRespond
        }
        set {
            objc_setAssociatedObject(self, &TableCellActionSenderAssociatedKeys.actionSender, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
