//
//  TableDelegate.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit

open class TableDelegate: NSObject, UITableViewDelegate {
    
    public let viewModel: TableDataProvider
    public init(viewModel: TableDataProvider) {
        self.viewModel = viewModel
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.cellViewModel(for: indexPath).cellHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let responder = viewModel.cellDidSelectedResponder else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        if responder.deselectRow.deselect {
            tableView.deselectRow(at: indexPath, animated: responder.deselectRow.animated)
        }
        responder.tableView(tableView, didSelectRowAt: indexPath)
    }
}
