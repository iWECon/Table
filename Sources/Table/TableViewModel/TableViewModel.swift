//
//  TableViewModel.swift
//  
//
//  Created by i on 2023/9/15.
//

import Foundation
import Combine
import Paginable
import UIKit

final class DefaultTableCellActionRespond: TableCellActionRespond {
    deinit {
        respond = nil
        print("\(Self.self) deinit")
    }
    
    private var respond: ((TableCellAction) -> Void)?
    init(respond: ((TableCellAction) -> Void)?) {
        self.respond = respond
    }
    
    init() { }
    
    /// Bind `viewModel.cellActionResponder = self`
    /// and set respond action
    func respond(to viewModel: TableDataProvider, _ respond: ((TableCellAction) -> Void)?) {
        viewModel.cellActionResponder = self
        self.respond = respond
    }
    func tableCellActionRespond(_ action: TableCellAction) {
        self.respond?(action)
    }
}

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
    
    private var _plainTableCellActionRespond: DefaultTableCellActionRespond?
    private var _plainTableCellDidSelectedRespond: PlainTableCellDidSelectedRespond?
    
    open func fetch(page: Paginable.Paging) -> AnyPublisher<TableData, Error> {
        Empty<TableData, Error>()
            .eraseToAnyPublisher()
    }
    
    open var paging: Paginable.Paging = Page(1)
    
    public init() { }
    
    open func cellActionRespond(_ respond: ((_ actionID: String, _ cell: UITableViewCell, _ indexPath: IndexPath) -> Void)?) {
        guard respond != nil else {
            _plainTableCellActionRespond = nil
            cellActionResponder = nil
            return
        }
        _plainTableCellActionRespond = DefaultTableCellActionRespond { action in
            guard let indexPath = action.cell.indexPath else {
                return
            }
            respond?(action.id, action.cell, indexPath)
        }
        cellActionResponder = _plainTableCellActionRespond!
    }
    
    open func cellDidSelectedRespond(_ respond: ((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)?) {
        guard let respond else {
            _plainTableCellDidSelectedRespond = nil
            cellDidSelectedResponder = nil
            return
        }
        _plainTableCellDidSelectedRespond = PlainTableCellDidSelectedRespond(respond)
        cellDidSelectedResponder = _plainTableCellDidSelectedRespond!
    }
}
