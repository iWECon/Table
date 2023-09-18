//
//  TableViewModel.swift
//  
//
//  Created by i on 2023/9/15.
//

import Foundation
import Combine
import Paginable

/// 用于构造 XXControllerViewModel
///
/// 继承该类型时，只需关注 `data` 以及 `fetch(page:)` 的实现即可
/// 
open class TableViewModel: TableDataProvider {
    
    deinit {
        cellActionResponder = nil
        cellDidSelectedResponder = nil
        cancellables.removeAll()
    }
    
    public weak var cellActionResponder: TableCellActionRespond?
    public weak var cellDidSelectedResponder: TableCellDidSelectedRespond?
    
    public var temporaryData: TableData?
    open var data: TableData = .none
    
    public var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public var applyDataSubject: PassthroughSubject<(), Never> = PassthroughSubject<(), Never>()
    public var resetDataSubject: PassthroughSubject<(), Never> = PassthroughSubject<(), Never>()
    public var nextPageDataSubject: PassthroughSubject<(), Never> = PassthroughSubject<(), Never>()
    public var errorSubject: PassthroughSubject<Error, Never> = PassthroughSubject<Error, Never>()
    public var emptyDataSubject: PassthroughSubject<(), Never> = PassthroughSubject<(), Never>()
    public var noMoreDataSubject: PassthroughSubject<(), Never> = PassthroughSubject<(), Never>()
    
    open func fetch(page: Paginable.Paging) -> AnyPublisher<TableData, Error> {
        Empty<TableData, Error>()
            .eraseToAnyPublisher()
    }
    
    open var paging: Paginable.Paging = Page(1)
    
    public init() {
        
    }
}
