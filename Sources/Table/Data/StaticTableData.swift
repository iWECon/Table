//
//  PlainTableData.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit
import Combine
import Paginable

/**
 For quick creation of simple lists (single data model).
 
 Example Module:
    RecommendUserList, Settings
 
 用于快速创建单模型列表，比如：设置列表等`静态`列表
*/

public final class StaticTableData: TableViewModel {
    
    public init(
        data: TableData,
        cellActionResponder: TableCellActionRespond? = nil,
        cellDidSelectedResponder: TableCellDidSelectedRespond? = nil
    ) {
        super.init()
        self.data = data
        self.cellActionResponder = cellActionResponder
        self.cellDidSelectedResponder = cellDidSelectedResponder
    }
    
    /// Reset data
    public func reset(as data: TableData) {
        self.data = data
        self.applyDataSubject.send()
    }
}

open class StaticTableCellViewModel: TableCellViewModel {
    open var identifier: String
    open var cellType: TableCellType
    open var cellHeight: CGFloat
    
    open var model: Any
    
    public init(model: Any, identifier: String = UUID().uuidString, cellType: TableCellType, cellHeight: CGFloat) {
        self.model = model
        self.identifier = identifier
        self.cellType = cellType
        self.cellHeight = cellHeight
    }
    
    public init(model: Any, identifier: String = UUID().uuidString, cellType: (_ model: Any) -> TableCellType, cellHeight: (_ model: Any) -> CGFloat) {
        self.model = model
        self.identifier = identifier
        self.cellHeight = cellHeight(model)
        self.cellType = cellType(model)
    }
    
    public init(model: Any, identifier: String = UUID().uuidString, cellType: (_ model: Any) -> TableCellType, cellHeight: CGFloat) {
        self.model = model
        self.identifier = identifier
        self.cellHeight = cellHeight
        self.cellType = cellType(model)
    }
    
    public init(model: Any, identifier: String = UUID().uuidString, cellType: TableCellType, cellHeight: (_ model: Any) -> CGFloat) {
        self.model = model
        self.identifier = identifier
        self.cellHeight = cellHeight(model)
        self.cellType = cellType
    }
}
