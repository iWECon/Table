//
//  TableHeaderFooterTitleDataSource.swift
//
//
//  Created by i on 2023/9/7.
//

import Foundation
import UIKit

/// Implemention `titleForheader` and `titleForFooter`
/// the title height implemention in `TableHeaderFooterDelegate`
///
/// If you want to use a custom view as a header or footer,
/// just use `TableData` and `TableHeaderFooterDelegate`
/// cuz the `viewForHeader` implemention in `UITableViewDelegate`
///
/// use custom view as a header or footer:
/// Example:
///     tableView.setTableData(TableHeaderFooterTitleDataSource)
///         .setTableDelegate(TableHeaderFooterDelegate)
///
open class TableHeaderFooterTitleDataSource: TableDataSource {
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let str = viewModel.sectionCellViewModel(for: section).header?.data as? String else {
            return nil
        }
        return str
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let str = viewModel.sectionCellViewModel(for: section).footer?.data as? String else {
            return nil
        }
        return str
    }
    
}
