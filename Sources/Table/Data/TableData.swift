//
//  TableData.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit
import Combine

public protocol TableData: AnyObject {
    
    var tableCellActionResponder: TableCellActionRespond? { get set }
    var tableCellDidSelectedResponder: TableCellDidSelectedRespond? { get set }
    
    var dataSource: TableDataSource { get set }
    var delegate: TableDelegate { get set }
    
    var style: UITableView.Style { get }
    var reloadDataSubject: PassthroughSubject<(), Never> { get }
    
    func numberOfSections() -> Int
    
    func numberOfRows(in section: Int) -> Int
    
    func model(for indexPath: IndexPath) -> TableCellViewModel
    
}

private struct TableDataAssociatedKeys {
    static var actionResponder = "actionResponder"
    static var didSelectedResponder = "didSelectedResponder"
}

extension TableData {
    
    public var tableCellActionResponder: TableCellActionRespond? {
        get {
            objc_getAssociatedObject(self, &TableDataAssociatedKeys.actionResponder) as? TableCellActionRespond
        }
        set {
            objc_setAssociatedObject(self, &TableDataAssociatedKeys.actionResponder, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var tableCellDidSelectedResponder: TableCellDidSelectedRespond? {
        get {
            objc_getAssociatedObject(self, &TableDataAssociatedKeys.didSelectedResponder) as? TableCellDidSelectedRespond
        }
        set {
            objc_setAssociatedObject(self, &TableDataAssociatedKeys.didSelectedResponder, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
