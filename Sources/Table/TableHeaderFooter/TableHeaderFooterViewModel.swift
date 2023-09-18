//
//  File.swift
//  
//
//  Created by i on 2023/9/7.
//

import Foundation

public protocol TableHeaderFooterViewModel {
    
    var viewType: TableHeaderFooterViewType? { get }
    var viewHeight: CGFloat { get }
    
    var data: Any { get }
}

public final class PlainTableHeaderFooterViewModel: TableHeaderFooterViewModel {
    
    public var viewType: TableHeaderFooterViewType? = nil
    public var viewHeight: CGFloat
    public var data: Any
    
    public init(data: Any, viewHeight: CGFloat, viewType: TableHeaderFooterViewType? = nil) {
        self.data = data
        self.viewHeight = viewHeight
        self.viewType = viewType
    }
}
