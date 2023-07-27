import UIKit
import Combine

open class TableView: UITableView {
    
    public var cancellables = Set<AnyCancellable>()
    
    /// Subscriber for reloading table view data
    public var reloadCancellable: AnyCancellable?
    
    public let viewModel: TableData
    public init(viewModel: TableData) {
        self.viewModel = viewModel
        super.init(frame: .zero, style: viewModel.style)
        self.setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Set up table view `dataSource`, `delegate` and bind `reloadDataSubject`
    open func setup() {
        self.dataSource = viewModel.dataSource
        self.delegate = viewModel.delegate
        
        reloadCancellable = viewModel.reloadDataSubject
            .receive(on: ImmediateScheduler.shared)
            .sink { [weak self] _ in
                self?.reloadData()
            }
    }
    
}
