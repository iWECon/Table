//
//  TableHeaderFooterDelegate.swift
//
//
//  Created by i on 2023/9/7.
//

import Foundation
import UIKit

/// Implemention `titleForheader` and `titleForFooter`
open class TableHeaderFooterDelegate: TableDelegate {
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewType = viewModel.sectionCellViewModel(for: section).header?.viewType else {
            return nil
        }
        switch viewType {
        case .view(let _view):
            return _view.init(frame: .zero)
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let viewType = viewModel.sectionCellViewModel(for: section).footer?.viewType else {
            return nil
        }
        switch viewType {
        case .view(let _view):
            return _view.init(frame: .zero)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let viewHeight = viewModel.sectionCellViewModel(for: section).header?.viewHeight else {
            return .leastNonzeroMagnitude
        }
        return viewHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let viewHeight = viewModel.sectionCellViewModel(for: section).footer?.viewHeight else {
            return .leastNonzeroMagnitude
        }
        return viewHeight
    }
    
}
