//
//  File.swift
//  
//
//  Created by i on 2023/9/4.
//

import UIKit

/// `TablePrefetchData`, it will call with `UITableViewDataSourcePrefetching` (`TableDataSource`)
public protocol TablePrefetchData {
    func prefetch(rowsAt indexPaths: [IndexPath])
    func cancelPrefetching(rowsAt indexPaths: [IndexPath])
}

extension TablePrefetchData {
    public func cancelPrefetching(rowsAt indexPaths: [IndexPath]) { }
}
