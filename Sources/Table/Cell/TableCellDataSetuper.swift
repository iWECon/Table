//
//  TableCellDataSetuper.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit

/**
 
 final class Cell: UITableViewCell, TableCellDataSetuper {

     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     // Implementing the method
     func setupData(_ data: Any) {
  
     }
 
 }
 */

public protocol TableCellDataSetuper: AnyObject {
    
    func setupData(_ data: Any)
    
}
