//
//  TableSectionCellViewModel.swift
//
//
//  Created by i on 2023/9/7.
//

import Foundation

public final class TableSectionCellViewModel {
    
    public let header: TableHeaderFooterViewModel?
    public var data: [TableCellViewModel]
    public let footer: TableHeaderFooterViewModel?
    
    public init(header: TableHeaderFooterViewModel?, data: [TableCellViewModel], footer: TableHeaderFooterViewModel? = nil) {
        self.header = header
        self.data = data
        self.footer = footer
    }
    
}

