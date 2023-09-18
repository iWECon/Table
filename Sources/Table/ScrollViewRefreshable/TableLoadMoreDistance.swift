//
//  File.swift
//  
//
//  Created by i on 2023/9/18.
//

import Foundation
import UIKit

public enum TableLoadMoreDistance: Equatable {
    /// Disable loadMore action
    case none
    
    /// Triggers loading more when the scroll view is length px away from the bottom
    case lessLength(_ length: CGFloat)
    
    /// Triggers loading more when the scroll view is percent px away from the bottom
    case lessPercent(_ percent: CGFloat)
    
    /// default value is 120px
    case `default`
    
    func value(contentHeight: CGFloat) -> CGFloat {
        switch self {
        case .none:
            return .greatestFiniteMagnitude
            
        case .lessLength(let length):
            return length
            
        case .lessPercent(let percent):
            precondition((0 ... 1).contains(percent), "invalid percent, please set value as 0 to 1")
            return contentHeight * percent
            
        case .`default`:
            return 120
        }
    }
}
