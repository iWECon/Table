import UIKit
import Combine
import Dispatch

/**
 TableView(style: .plain)
     .bind(viewModel: `TableData`)
     .setTableDelegate(_: `TableDelegate`)
     .setTableDataSource(_: `TableDataSource`)
 */

open class TableView: UITableView {
    
    deinit {
        reloadCancellable = nil
        offsetYCancellable = nil
    }
    
    /// Indicator of Pull to refresh
    ///
    /// Change color: Use `tableRefreshControl.tintColor = UIColor`
    public let tableRefreshControl = UIRefreshControl()
    
    /// Subscriber for reloading table view data
    internal var reloadCancellable: AnyCancellable?
    /// Indicate whether the publisher offset.y event is cancelled
    internal var offsetYCancellable: AnyCancellable?
    
    /// Indicator of LoadMore
    public let loadMoreIndicator = LoadMoreIndicator()
    
    /// Indicator of Empty Data
    public var emptyView: UIView?
    
    public var viewModel: TableDataProvider!
    public required init(style: UITableView.Style) {
        super.init(frame: .zero, style: style)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Set up table view `dataSource`, `delegate` and bind `reloadDataSubject`
    func setup() {
        reloadCancellable?.cancel()
        reloadCancellable = viewModel.applyDataSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.loadMoreIndicator.stopLoadMore()
                self?.viewModel.applyTemporaryData()
                self?.reloadData()
                
                if self?.viewModel.data.isEmpty == true {
                    self?.viewModel.emptyDataSubject.send()
                } else {
                    self?.emptyView?.removeFromSuperview()
                }
            }
        
        viewModel.emptyDataSubject
            .receive(on: RunLoop.main)
            .compactMap({ [weak self] _ in
                self?.emptyView
            })
            .sink { [weak self] emptyV in
                guard let self else { return }
                self.addSubview(emptyV)
                // fix self.bounds (bounds.origin will follow the change of scrollView.contentOffset)
                emptyV.frame = CGRect(origin: .zero, size: self.bounds.size)
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.noMoreDataSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.loadMoreIndicator.noMoreData(on: self)
            }
            .store(in: &viewModel.cancellables)
        
        if viewModel.isEnableRefresh {
            setupRefreshEvent()
        }
        if viewModel.loadMoreDistance != .none {
            setupLoadMoreEvent()
        }
        
        // 创建时自动初始化数据
        viewModel.resetDataSubject.send()
    }
    
    private func setupRefreshEvent() {
        viewModel.refreshCancellable?.cancel()
        tableRefreshControl.removeTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        
        viewModel.refreshCancellable = viewModel.resetDataSubject
            .receive(on: DispatchQueue.global())
            .filter({ [weak self] in
                self?.viewModel.isRefreshing == false
                && self?.viewModel.isLoadingMore == false
                && self?.viewModel.isEnableRefresh == true
            })
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.viewModel.isRefreshing = true
                self.viewModel.paging.reset()
                
                self.viewModel.fetch(page: self.viewModel.paging)
                    .endRefresh(self, action: .refresh)
                    .assign(to: self.viewModel, action: .reset)
                    .store(in: &self.viewModel.cancellables)
            }
        
        refreshControl = tableRefreshControl
        tableRefreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
    }
    
    private func setupLoadMoreEvent() {
        viewModel.loadMoreCancellable?.cancel()
        offsetYCancellable?.cancel()
        
        viewModel.loadMoreCancellable = viewModel.nextPageDataSubject
            .receive(on: DispatchQueue.global())
            .filter({ [weak self] in
                self?.viewModel.isRefreshing == false
                && self?.viewModel.isLoadingMore == false
                && self?.viewModel.loadMoreDistance != .some(.none)
                && self?.viewModel.paging.noMoreData == false
            })
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.viewModel.isLoadingMore = true
                
                DispatchQueue.main.async {
                    self.loadMoreIndicator.startLoadMore(on: self)
                }
                
                self.viewModel.fetch(page: self.viewModel.paging)
                    .endRefresh(self, action: .loadMore)
                    .assign(to: self.viewModel, action: .append)
                    .store(in: &self.viewModel.cancellables)
            }
        
        offsetYCancellable = publisher(for: \.contentOffset)
            .map(\.y)
            .removeDuplicates()
            .sink(receiveValue: { [weak self] offsetY in
                self?.offsetYChangedAction(offsetY)
            })
    }
    
    private func refreshNoMoreDataIndicator(isNoMoreData: Bool) {
        guard isNoMoreData else { return }
        
        DispatchQueue.main.async {
            self.loadMoreIndicator.noMoreData(on: self)
        }
    }
    
    /// Handling the triggering of the `LoadMore` event
    private func offsetYChangedAction(_ offsetY: CGFloat) {
        guard !viewModel.isLoadingMore, !viewModel.isRefreshing else { return }
        guard offsetY > 0 else { return }
        
        if case .none = viewModel.data {
            return
        }
        if case .empty = viewModel.data {
            return
        }
        
        let lessValue = viewModel.loadMoreDistance.value(contentHeight: contentSize.height)
        guard abs(offsetY + frame.size.height - contentSize.height) <= lessValue else {
            return
        }
        self.viewModel.nextPageDataSubject.send()
    }
    
    /// Handling the triggering of the `Refresh` event
    @objc private func refreshAction(_ sender: UIRefreshControl) {
        self.viewModel.resetDataSubject.send()
    }
    
}

// MARK: Chainable
extension TableView {
    
    @discardableResult
    public func bind(
        viewModel: TableDataProvider
    ) -> TableView {
        self.viewModel = viewModel
        self.setup()
        return self
    }
    
    @discardableResult
    public func setTableDelegate(_ delegate: TableDelegate?) -> TableView {
        self.delegate = delegate
        return self
    }
    
    @discardableResult
    public func setTableDataSource(_ dataSource: TableDataSource?) -> TableView {
        self.dataSource = dataSource
        return self
    }
}
