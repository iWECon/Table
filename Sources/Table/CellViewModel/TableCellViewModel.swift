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

struct TableCellViewModelDiffIdentifierAssociatedKeys {
    static var identifier: UInt8 = 0
}

extension TableCellViewModelDiffIdentifier {
    
    public var identifier: String {
        get {
            if let existed = objc_getAssociatedObject(self, &TableCellViewModelDiffIdentifierAssociatedKeys.identifier) as? String {
                return existed
            }
            let newIdentifier = UUID().uuidString
            objc_setAssociatedObject(
                self,
                &TableCellViewModelDiffIdentifierAssociatedKeys.identifier,
                newIdentifier,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            return newIdentifier
        }
        set {
            objc_setAssociatedObject(
                self,
                &TableCellViewModelDiffIdentifierAssociatedKeys.identifier,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}

public typealias TableCellViewModel = TableCellTypeProvider & TableCellHeightProvider & TableCellViewModelDiffIdentifier
