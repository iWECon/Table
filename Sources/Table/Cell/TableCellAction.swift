//
//  TableCellAction.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit

/**
 Cell: TableCellActionSender
 Controller: TableCellActionResponder, TableCellDidSelectedRespond
 
 final class Controller: UIViewController {
    
    let viewModel = ControllerViewModel()
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // ...
        viewModel.cellActionResponder = self
        viewModel.cellDidSelectedResponder = self
    }
 }
 
 extension Controller: TableCellActionRespond {
 
 }
 
 extension Controller: TableCellDidSelectedRespond {
 
 }
 */

public protocol TableCellAction {
    var id: String { get }
    var cell: UITableViewCell { get }
}

public struct DefaultTableCellAction: TableCellAction {
    public var id: String
    public var cell: UITableViewCell
    
    public init(id: String, cell: UITableViewCell) {
        self.id = id
        self.cell = cell
    }
}
