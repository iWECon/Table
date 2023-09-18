//
//  Combine+.swift
//
//
//  Created by i on 2023/9/1.
//

import Foundation
import Dispatch
import Combine
import ScrollViewRefreshable

public enum AssignTableAction {
    case reset
    case append
}

/**
 The extension of protocol `Publisher` cannot have an inheritance clause
 */

public enum MapToTableData {
    case list, section
}

extension Publisher {
    
    public func compactMapTo(tableData: MapToTableData) -> some Publisher<TableData, Self.Failure> {
        self.compactMap { array in
            switch tableData {
            case .list:
                let res = array as? [TableCellViewModel] ?? []
                return .list(res)
            case .section:
                let res = array as? [TableSectionCellViewModel] ?? []
                return .section(res)
            }
        }
    }
}

extension Publisher where Self.Output == TableData {
    
    public func assign(to tableDataProvider: TableDataProvider, action: AssignTableAction) -> AnyCancellable {
        sink { [weak tableDataProvider] completion in
            switch completion {
            case .finished:
                // finished
                break
            case .failure(let err):
                tableDataProvider?.errorSubject.send(err)
            }
        } receiveValue: { [weak tableDataProvider] output in
            guard let tableDataProvider else { return }
            
            if output.isEmpty {
                tableDataProvider.temporaryData = .empty
                tableDataProvider.applyDataSubject.send()
                tableDataProvider.emptyDataSubject.send()
            } else {
                switch action {
                case .reset:
                    tableDataProvider.temporaryData = output
                case .append:
                    tableDataProvider.temporaryData = tableDataProvider.data + output
                }
                tableDataProvider.applyDataSubject.send()
                
                if tableDataProvider.paging.noMoreData {
                    tableDataProvider.noMoreDataSubject.send()
                }
            }
        }
    }
}

public enum EndRefreshAction {
    case refresh, loadMore
}

extension Publisher {
    
    public func endRefresh(_ tableView: TableView?, action: EndRefreshAction) -> Combine.Publishers.HandleEvents<Self> {
        handleEvents(receiveCompletion:  { [weak tableView] _ in
            DispatchQueue.main.async {
                switch action {
                case .refresh:
                    tableView?.viewModel.isRefreshing = false
                case .loadMore:
                    tableView?.viewModel.isLoadingMore = false
                    tableView?.loadMoreIndicator.stopLoadMore()
                    tableView?.viewModel.paging.noMoreData = true
                }
                tableView?.tableRefreshControl.endRefreshing()
            }
        }, receiveCancel: { [weak tableView] in
            DispatchQueue.main.async {
                switch action {
                case .refresh:
                    tableView?.viewModel.isRefreshing = false
                case .loadMore:
                    tableView?.viewModel.isLoadingMore = false
                    tableView?.loadMoreIndicator.stopLoadMore()
                    tableView?.viewModel.paging.noMoreData = true
                }
                tableView?.tableRefreshControl.endRefreshing()
            }
        })
    }
}