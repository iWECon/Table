//
//  TableCellActionRespond.swift
//
//
//  Created by i on 2023/7/27.
//

import UIKit

public protocol TableCellActionRespond: AnyObject {
    func tableCellActionRespond(_ action: TableCellAction)
}

/**
 final class XXController: UIViewController {
    
    // **MUST** stronger
    // `生命周期需要被持有，否则创建后立即销毁`
    let cellActionResponder = DefaultTableCellActionRespond()
 
    override func viewDidLoad() {
        cellActionResponder.respond(to: viewModel) { [weak self] action in
            self?.xxx
        }
    }
 }
 */
public class DefaultTableCellActionRespond: TableCellActionRespond {
    deinit {
        respond = nil
        print("\(Self.self) deinit")
    }
    
    private var respond: ((TableCellAction) -> Void)?
    public init(respond: ((TableCellAction) -> Void)?) {
        self.respond = respond
    }
    
    public init() { }
    
    /// Bind `viewModel.cellActionResponder = self`
    /// and set respond action
    public func respond(to viewModel: TableDataProvider, _ respond: ((TableCellAction) -> Void)?) {
        viewModel.cellActionResponder = self
        self.respond = respond
    }
    public func tableCellActionRespond(_ action: TableCellAction) {
        self.respond?(action)
    }
}

public protocol TableCellDidSelectedRespond: AnyObject {
    
    /// Default is `(true, true)`
    /// Call tableView.deselectRow(at:,animated:) when set `true`.
    var deselectRow: (deselect: Bool, animated: Bool) { get }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

extension TableCellDidSelectedRespond {
    public var deselectRow: (deselect: Bool, animated: Bool) {
        (deselect: true, animated: true)
    }
}


public final class PlainTableCellDidSelectedRespond: TableCellDidSelectedRespond {
    deinit {
        print("\(Self.self) deinit")
    }
    
    public typealias DidSelect = (_ tableView: UITableView, _ selectedIndexPath: IndexPath) -> Void
    public typealias DeselectRow = (_ tableView: UITableView, _ selectedIndexPath: IndexPath) -> (deselect: Bool, animated: Bool)
    
    let _didSelect: DidSelect
    let _deselectRow: DeselectRow
    
    public init(_ didSelect: @escaping DidSelect, deselectRow: @escaping DeselectRow) {
        self._didSelect = didSelect
        self._deselectRow = deselectRow
    }
    
    public init(_ didSelect: @escaping DidSelect, deselectRowAndAnimated: (Bool, Bool) = (true, true)) {
        self._didSelect = didSelect
        self._deselectRow = { _, _ in
            return (deselectRowAndAnimated.0, deselectRowAndAnimated.1)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = _deselectRow(tableView, indexPath)
        if value.deselect {
            tableView.deselectRow(at: indexPath, animated: value.animated)
        }
        self._didSelect(tableView, indexPath)
    }
}
