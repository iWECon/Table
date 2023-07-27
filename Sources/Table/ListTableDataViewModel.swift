//
//  DefaultListTableDataViewModel.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit
import Combine

open class DefaultListTableDataViewModel: ListTableData {
    public var dataSource: TableDataSource
    public var delegate: TableDelegate
    public var tableCellActionResponder: TableCellActionRespond?
    public var tableCellDidSelectedResponder: TableCellDidSelectedRespond?
    public var reloadDataSubject: PassthroughSubject<(), Never> = PassthroughSubject<(), Never>()
    
    @Published public var data: [TableCellViewModel] = []
    
    public init(
        dataSource: TableDataSource,
        delegate: TableDelegate,
        tableCellActionResponder: TableCellActionRespond? = nil,
        tableCellDidSelectedResponder: TableCellDidSelectedRespond? = nil,
        reloadDataSubject: PassthroughSubject<(), Never>,
        data: [TableCellViewModel]
    ) {
        self.dataSource = dataSource
        self.delegate = delegate
        self.tableCellActionResponder = tableCellActionResponder
        self.tableCellDidSelectedResponder = tableCellDidSelectedResponder
        self.reloadDataSubject = reloadDataSubject
        self.data = data
    }
}
