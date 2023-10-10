//
//  TableDataProvider.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit
import Combine
import Paginable

public enum TableDataAction {
    case reset
    case append
}

public enum TableData {
    /// Default value (Use in XXControllerViewModel create)
    /// 默认值，创建时没有数据用这个
    case none
    
    /// Use this when refresh the data is empty
    /// 当下拉刷新或者初始化从接口数据后，结果为空时自动配置为 empty
    case empty
    
    case list(_ value: [TableCellViewModel])
    case section(_ value: [TableSectionCellViewModel])
    
    public var listValue: [TableCellViewModel] {
        switch self {
        case .list(let value):
            return value
        default:
            return []
        }
    }
    
    public var sectionValue: [TableSectionCellViewModel] {
        switch self {
        case .section(let value):
            return value
        default:
            return []
        }
    }
    
    /// Available the TableData is in `[.list, .section]`
    public var count: Int {
        switch self {
        case .list(let v):
            return v.count
        case .section(let v):
            return v.count
        default:
            return 0
        }
    }
    
    /// Available the TableData is in `[.list, .section]`
    public var isEmpty: Bool {
        switch self {
        case .list(let v):
            return v.isEmpty
        case .section(let v):
            return v.isEmpty
        case .empty:
            return true
        default:
            return false
        }
    }
}

public func += (lhs: inout TableData, rhs: TableData) {
    switch (lhs, rhs) {
    case (.list(let lvalue), .list(let rvalue)):
        lhs = .list(lvalue + rvalue)
    case (.section(let lvalue), .section(let rvalue)):
        lhs = .section(lvalue + rvalue)
    default:
        break
    }
}

public func + (lhs: TableData, rhs: TableData) -> TableData {
    switch (lhs, rhs) {
    case (.list(let lvalue), .list(let rvalue)):
        return .list(lvalue + rvalue)
    case (.section(let lvalue), .section(let rvalue)):
        return .section(lvalue + rvalue)
        
    case (.none, .list), (.empty, .list):
        return rhs
    case (.list, .none), (.list, .empty):
        return lhs
    case (.none, .section), (.empty, .section):
        return rhs
    case (.section, .none), (.section, .empty):
        return lhs
        
    case (.none, .empty):
        return .empty
    case (.empty, .none):
        return .empty
        
    default:
        fatalError("Invalid Operation, can't add two different types of tableData")
    }
}

public protocol TableDataProvider: AnyObject, Paginable.Pagingable, ScrollViewRefreshable {
    
    /// Set responders to respond to independent click events in the Cell
    /// ⚠️ Declare it as weak
    var cellActionResponder: TableCellActionRespond? { get set }
    
    /// Set responders to respond to clicks on the entire Cell
    /// ⚠️ Declare it as weak
    var cellDidSelectedResponder: TableCellDidSelectedRespond? { get set }
    
    /// When you fetch data from server,
    /// first set to `temporaryData`,
    /// then call `applyDataSubject.send()`, the `temporaryData` will be bind to `data`
    ///
    /// Example:
    ///     ```swift
    ///         UserAPI.info(userID: 100001)
    ///             .make()
    ///             .receive(on: DispatchQueue.global())
    ///             .assign(to: &self.paging)
    ///             .decode(as: [User].self)
    ///     ```
    var temporaryData: TableData? { get set }
    
    var data: TableData { get set }
    
    var cancellables: Set<AnyCancellable> { get set }
    
    /// It is recommended that this thread be `called in the main thread`
    ///
    /// Example:
    ///
    ///     viewModel.fetch()
    ///         // Data can be processed in sub-threads
    ///         .map({ values in
    ///             // convert data
    ///         })
    ///         // (⚠️ required) but need set to tableView in main thread
    ///         .receive(on: RunLoop.main)
    ///         .assign(to: self, action: .refresh)
    ///         .store(in: &cancellables)
    ///
    var applyDataSubject: PassthroughSubject<(), Never> { get }
    
    /// Fetch data from server and set as a first page's data
    var resetDataSubject: PassthroughSubject<(), Never> { get }
    
    /// Fetch data from server and append the next page data
    var nextPageDataSubject: PassthroughSubject<(), Never> { get }
    
    /// Send error to output
    var errorSubject: PassthroughSubject<Swift.Error, Never> { get }
    
    /// Fetch data from server but it is empty
    var emptyDataSubject: PassthroughSubject<(), Never> { get }
    
    /// Fetch data from server with Paging
    ///
    /// You can call refresh action with `resetDataSubject.send()`
    /// and next page data with `nextPageDataSubject.send()`
    ///
    /// Example:
    ///     ```swift
    ///     UserAPI.info(userID: 100001)
    ///         .make()
    ///         .receive(on: DispatchQueue.global())
    ///         .assign(to: &self.paging)
    ///         .decode(as: [User].self)
    ///         .ignoreFailure()
    ///     ```
    func fetch(page: Paginable.Paging) -> AnyPublisher<Table.TableData, Swift.Error>
}

extension TableDataProvider {
    
    func applyTemporaryData() {
        guard let temporaryData else { return }
        self.data = temporaryData
        self.temporaryData = nil
    }
    
    func numberOfSections() -> Int {
        switch data {
        case .list:
            return 1
        case .section(let value):
            return value.count
        case .none, .empty:
            return 0
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch data {
        case .list(let value):
            return value.count
        case .section(let value):
            return value[section].data.count
        case .none, .empty:
            return 0
        }
    }
    
    /// Append data
    ///
    /// viewModel.append(.list([]))
    /// or
    /// viewModel.append(.section([]))
    public func appendTableData(_ tableData: TableData) {
        self.temporaryData = self.data + tableData
        applyDataSubject.send()
    }
    
    /// Remove Section
    public func removeSection(where: (TableSectionCellViewModel) -> Bool) {
        var data = self.data.sectionValue
        data.removeAll(where: `where`)
        
        self.temporaryData = .section(data)
        self.applyDataSubject.send()
    }
    
    /// Remove Item from `List`
    public func remove(cellViewModel: TableCellViewModel) {
        switch data {
        case .list(let value):
            var v = value
            v.removeAll(where: { $0.identifier == cellViewModel.identifier })
            
            self.temporaryData = .list(v)
            self.applyDataSubject.send()
            
        case .section(let value):
            // Wait test
            let v = value
            v.forEach { sectionCellViewModel in
                sectionCellViewModel.data.removeAll(where: { $0.identifier == cellViewModel.identifier })
            }
            self.temporaryData = .section(v)
            self.applyDataSubject.send()
            
        default:
            break
        }
    }
    
    public func cellViewModel(for indexPath: IndexPath) -> TableCellViewModel {
        switch data {
        case .list(let value):
            return value[indexPath.row]
        case .section(let value):
            return value[indexPath.section].data[indexPath.row]
        case .none, .empty:
            fatalError()
        }
    }
    
    public func sectionCellViewModel(for section: Int) -> TableSectionCellViewModel {
        switch data {
        case .list, .none, .empty:
            fatalError("Can't access section cell viewModel from `.list or .none or .empty`")
        case .section(let value):
            return value[section]
        }
    }
}
