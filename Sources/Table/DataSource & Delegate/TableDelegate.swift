//
//  TableDelegate.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit

open class TableDelegate: NSObject, UITableViewDelegate {
    
    public let viewModel: TableData
    public init(viewModel: TableData) {
        self.viewModel = viewModel
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.model(for: indexPath).cellHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let responder = viewModel.tableCellDidSelectedResponder else {
            return
        }
        
        if responder.deselectRow.deselect {
            tableView.deselectRow(at: indexPath, animated: responder.deselectRow.animated)
        }
        responder.tableCellDidSelect(at: indexPath)
    }
}
