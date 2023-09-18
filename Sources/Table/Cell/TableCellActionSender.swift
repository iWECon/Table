//
//  TableCellActionSender.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit

public protocol TableCellActionSender: AnyObject {
    /// Please declare it as weak
    var actionSender: TableCellActionRespond? { get set }
}
