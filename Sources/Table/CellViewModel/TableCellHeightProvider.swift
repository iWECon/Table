//
//  TableCellHeightProvider.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit

public protocol TableCellHeightProvider {
    var cellHeight: CGFloat { get }
}

extension TableCellHeightProvider {
    public var cellHeight: CGFloat { 44.0 }
}
