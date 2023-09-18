//
//  LoadMoreIndicator.swift
//
//
//  Created by i on 2023/9/8.
//

import UIKit

public final class LoadMoreIndicator: UIView {
    
    public struct Appearance {
        public var noMoreDataTips: [String] = ["已经到底啦😊~", "我也是有底线的啦😠!!!", "没有更多了😭"]
    }
    public static var `default`: Appearance = Appearance()
    
    public let indicatorView = UIActivityIndicatorView(style: .medium)
    public let tipsLabel = UILabel()
    
    public let contentHeight: CGFloat = 34
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        indicatorView.hidesWhenStopped = true
        indicatorView.stopAnimating()
        indicatorView.sizeToFit()
        addSubview(indicatorView)
        
        tipsLabel.font = .systemFont(ofSize: 12, weight: .medium)
        tipsLabel.textColor = .gray
        tipsLabel.text = Self.default.noMoreDataTips.randomElement() ?? "no more data :)"
        addSubview(tipsLabel)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var previousContentSize: CGSize = .zero
    
    func reset(on scrollView: UIScrollView) -> Bool {
        guard let screenSize = scrollView.window?.windowScene?.screen.bounds.size else { return false }
        guard previousContentSize.height != scrollView.contentSize.height - self.contentHeight else { return false }
        previousContentSize.height = scrollView.contentSize.height
        scrollView.addSubview(self)
        
        self.frame.size = CGSize(width: screenSize.width, height: self.contentHeight)
        self.frame.origin = CGPoint(x: 0, y: scrollView.contentSize.height)
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height + self.frame.height)
        return true
    }
    
    public func startLoadMore(on scrollView: UIScrollView) {
        guard self.reset(on: scrollView) else { return }
        
        self.tipsLabel.isHidden = true
        self.indicatorView.frame.origin.x = (frame.width - indicatorView.frame.width) / 2
        self.indicatorView.frame.origin.y = (frame.height - indicatorView.frame.height) / 2
        self.indicatorView.startAnimating()
    }
    
    public func stopLoadMore() {
        indicatorView.stopAnimating()
        self.removeFromSuperview()
    }
    
    public func noMoreData(on scrollView: UIScrollView) {
        guard self.reset(on: scrollView) else { return }
        
        self.tipsLabel.isHidden = false
        tipsLabel.sizeToFit()
        tipsLabel.frame.origin = CGPoint(x: (frame.width - tipsLabel.frame.width) / 2, y: (frame.height - tipsLabel.frame.height) / 2)
    }
    
}
