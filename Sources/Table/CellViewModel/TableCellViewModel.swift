//
//  File.swift
//  
//
//  Created by i on 2023/9/4.
//

import Foundation

public protocol TableCellViewModelDiffIdentifier {
    var identifier: String { get }
}

extension TableCellViewModelDiffIdentifier {
    public var identifier: String { "" }
}

public typealias TableCellViewModel = TableCellTypeProvider & TableCellHeightProvider & TableCellViewModelDiffIdentifier
