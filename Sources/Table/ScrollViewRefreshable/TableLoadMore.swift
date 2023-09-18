import Foundation
import UIKit
import Combine


public protocol ScrollViewRefreshable: AnyObject {
    
    /// Indicate whether the refresh event is cancelled
    var refreshCancellable: AnyCancellable? { get set }
    /// Indicate whether the loadMore event is cancelled
    var loadMoreCancellable: AnyCancellable? { get set }
    
    /// Control the pull to refresh is enable
    var isEnableRefresh: Bool { get set }
    /// Control the load-more (load next page data) is enable
    /// set as `.none` to disable load-more
    var loadMoreDistance: TableLoadMoreDistance { get set }
    
    /// Indicates if a refresh is in progress
    var isRefreshing: Bool { get set }
    /// Indicates if a load-more is in progress
    var isLoadingMore: Bool { get set }
}

private struct ScrollViewRefreshableAssociatedKeys {
    static var refreshCancellable: UInt8 = 0
    static var loadMoreCancellable: UInt8 = 1
    static var isEnableRefresh: UInt8 = 2
    static var loadMoreDistance: UInt8 = 3
    static var isRefreshing: UInt8 = 4
    static var isLoadingMore: UInt8 = 5
}

extension ScrollViewRefreshable {
    
    public var refreshCancellable: AnyCancellable? {
        get { objc_getAssociatedObject(self, &ScrollViewRefreshableAssociatedKeys.refreshCancellable) as? AnyCancellable }
        set { objc_setAssociatedObject(self, &ScrollViewRefreshableAssociatedKeys.refreshCancellable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public var loadMoreCancellable: AnyCancellable?  {
        get { objc_getAssociatedObject(self, &ScrollViewRefreshableAssociatedKeys.loadMoreCancellable) as? AnyCancellable }
        set { objc_setAssociatedObject(self, &ScrollViewRefreshableAssociatedKeys.loadMoreCancellable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public var isEnableRefresh: Bool {
        get { objc_getAssociatedObject(self, &ScrollViewRefreshableAssociatedKeys.isEnableRefresh) as? Bool ?? true }
        set { objc_setAssociatedObject(self, &ScrollViewRefreshableAssociatedKeys.isEnableRefresh, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public var loadMoreDistance: TableLoadMoreDistance {
        get { objc_getAssociatedObject(self, &ScrollViewRefreshableAssociatedKeys.loadMoreDistance) as? TableLoadMoreDistance ?? .default }
        set { objc_setAssociatedObject(self, &ScrollViewRefreshableAssociatedKeys.loadMoreDistance, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public var isRefreshing: Bool {
        get { objc_getAssociatedObject(self, &ScrollViewRefreshableAssociatedKeys.isRefreshing) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &ScrollViewRefreshableAssociatedKeys.isRefreshing, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public var isLoadingMore: Bool {
        get { objc_getAssociatedObject(self, &ScrollViewRefreshableAssociatedKeys.isLoadingMore) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &ScrollViewRefreshableAssociatedKeys.isLoadingMore, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
