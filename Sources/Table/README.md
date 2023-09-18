#  Combine 的部分类型对比 ReactiveSwift

`Combine` -> `ReactiveSwift`
PassthroughSubject<Value, Failure> -> Signal<Value, Error>.pipe()
CurrentValueSubject<Value, Never> -> MutableProperty<Value>

#### 创建空的发布者 Empty
Empty<Value, Failure>() -> SignalProducer<Value, Error>.empty()

#### 事件订阅
AnyPublisher.handleEvents(xxx) -> SignalProducer.on(value:,failed:,terminal:xxx)

#### 生命周期
类似于 ReactiveSwift 的 `Disposable`

在 Combine 中这么用 (没有 ReactiveSwift 方便: `take(duringLifetimeOf: AnyObject)`):
    ```swift
    import Combine //< ‼️ 需要
    
    var cancellables: Set<AnyCancellable> = .init()
    AnyPublisher.store(in: &cancellables)
    ```
    或者
    ```swift
    import Combine //< ‼️ 需要
        
    var loginCancellable: AnyCancellable?
    loginCancellable = AnyPublisher.xxx
    ```

#### 创建发布者 Publisher
Future<Value, Failure> { promise in 
    promise(.success(Value))
    promise(.failure(error))
} 
-> 
SignalProvuder<Value, Error> { observer, lifetime in 
    observer.send(value: Value)
    observer.send(error: Error)
}


#  快速创建静态列表

Cell 模型塞这个类 `StaticTableCellViewModel`

`StaticTableCellViewModel(model: Any, cellType: TableCellType, cellHeight: CGFloat)`

TableData 用 StaticTableData


#  The controller responds to button click events in the Cell

在控制器中响应 Cell 中的按钮点击事件

#### Cell

Cell 继承协议 `TableCellActionSender`
并添加 `weak var actionSender: TableCellActionRespond?`

按钮触发时调用：
```swift
let action = DefaultTableCellAction(id: "tapButton", cell: self)
actionSender?.tableCellActionRespond(action)
```

例子：
```swift

// implemention TableCellActionSender
// ⚠️ required mark as `weak`
weak var actionSender: TableCellActionRespond?

@objc func buttonAction(_ sender: UIButton) {
    let action = DefaultTableCellAction(id: "tapButton", cell: self)
    actionSender?.tableCellActionRespond(action)
}
```

#### Controller

控制器中给 `viewModel` 的 `cellActionResponder` 添加委托者
同时继承协议 `TableCellActionRespond`
```swift
viewModel.cellActionResponder = self 
viewModel.cellDidSelectedResponder = self

extension Controller: TableCellActionRespond {
    func tableCellActionRespond(_ action: TableCellAction) {
        // do something
    }
}

extension Controller: TableCellDidSelectedRespond {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // do something
    }
}
```

#  How to create a Section Table with Header/Footer

创建带有 Header 或 Footer 的视图

#### ControllerViewModel

```swift
final class <#View#>ControllerViewModel: TableDataProvider {
    
    // required mark as weak
    weak var cellActionResponder: TableCellActionRespond?
    // required mark as weak
    weak var cellDidSelectedResponder: TableCellDidSelectedRespond?
    
    var temporaryData: TableData? = nil
    var data: Table.TableData = .section([
        TableSectionCellViewModel(header: <#PlainTableHeaderFooterViewModel#>, data: <#[TableCellViewModel]#>),
        TableSectionCellViewModel(header: <#PlainTableHeaderFooterViewModel#>, data: <#[TableCellViewModel]#>),
    ])
    
    var applyDataSubject: PassthroughSubject<(), Never> = .init()
}
```

#### Controller

```swift

final class <#View#>Controller: UIViewController {
        
    let viewModel = <#View#>ControllerViewModel()
    
    // required use `TableheaderFooterDelegate`
    lazy var tDelegate = TableHeaderFooterDelegate(viewModel: self.viewModel)
    // required use `TableheaderFooterTitleDataSource`
    lazy var tDataSource = TableHeaderFooterTitleDataSource(viewModel: self.viewModel)
    
    let tableView = TableView(style: <#.grouped#>)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         
        tableView
            .bind(viewModel: self.viewModel)
            .setTableDelegate(tDelegate)
            .setTableDataSource(tDataSource)
        
        self.view.addSubview(tableView)
    }
}
```
