//
//  RefreshContainer.swift
//  RefreshKit
//
//  Created by pan on 2017/9/19.
//  Copyright © 2017年 AceSha. All rights reserved.
//

import UIKit


fileprivate let KVOKeyOffset = "contentOffset"
fileprivate let KVOKeyContentSize = "contentSize"
fileprivate var KVOContext = "RefreshKVOContext"

public typealias action = (() -> Void)

final public class RefreshContainer: UIView {
    
    public var fireHeight: CGFloat = 0
    
    public var finishedStayDuration: TimeInterval = 0
    
    public var tintColorForDefaultRefreshView: UIColor = .lightGray {
        willSet {
            guard let rf = refreshView as? DefaultRefreshView else {
                fatalError("this property can only be used for default refresh header or footer")
            }
            rf.color = newValue
        }
    }
    
    
    public var dictForDefaultRefreshView: [RefreshStateStringKey: String]? {
        willSet {
            guard let rf = refreshView as? DefaultRefreshView else {
                fatalError("this property can only be used for default refresh header or footer")
            }
            rf.singleCustomDictForStates = newValue
        }
    }
    
    internal var endRefreshingWithMessage: String? {
        willSet {
            guard let rf = refreshView as? DefaultRefreshView else {
                fatalError("this property can only be used for default refresh header or footer")
            }
            if var _ = rf.dictForStates {
                rf.dictForStates![.finished] = newValue ?? ""
            }
        }
    }
    
    
    internal var action: action?
    
    internal var state: RefreshState = .initial {
        didSet {
            refreshView?.animationForState(state: state)
            if state != oldValue {
                if state == .isRefreshing  {
                    action?()
                    animationToRefreshing()
                }
                if state == .finished {
                    endAnimation()
                }
            }
        }
    }
    
    private var type: RefreshType = .header
    
    private var refreshView: Refreshable?
    
    private var defaultBounces: Bool = true
    
    private var defaultInset: UIEdgeInsets = .zero
    
    private var defaultContentOffSet: CGPoint = .zero
    
    private var previousOffsetY: CGFloat = 0
    
    
    public init(refreshView: Refreshable, scrollView: UIScrollView, type: RefreshType = .header) {
        super.init(frame: .zero)
        self.type = type
        scrollView.addSubview(self)
        if let rf = refreshView as? UIView {
            addSubview(rf)
        }else{
            fatalError("Custom Refreshable Class is Not subclass of UIView")
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let scrollView = superview as? UIScrollView {
            removeScrollViewObservers(scrollView: scrollView)
        }
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        if let scrollView = superview as? UIScrollView {
            removeScrollViewObservers(scrollView: scrollView)
        }
        if let scrollView = newSuperview as? UIScrollView {
            addScrollViewObservers(scrollView: scrollView)
            defaultBounces = scrollView.bounces
            defaultInset = scrollView.contentInset
            defaultContentOffSet = scrollView.contentOffset
        }
        
        self.autoresizingMask = [
            .flexibleLeftMargin,
            .flexibleRightMargin,
        ]
        
    }
    
    public override func addSubview(_ view: UIView) {
        super.addSubview(view)
        
        if view is Refreshable {
            refreshView = view as? Refreshable
            
            if type == .header {
                frame = CGRect(x: 0, y: -view.bounds.height, width: view.bounds.width, height: view.bounds.height)
            }
            guard var fireHeight = refreshView?.fireHeight() else { return }
            if fireHeight == 0 {
                fireHeight = view.frame.height
            }
            self.fireHeight = fireHeight
            
            finishedStayDuration = refreshView?.finishedStayDuration() ?? 0
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let scrollView = object as? UIScrollView else { return }
        if context == &KVOContext{
            
            if keyPath == KVOKeyOffset {
                
                var offset: CGFloat
                if type == .header {
                    offset = previousOffsetY + defaultInset.top
                }else{
                    if scrollView.contentSize.height > scrollView.bounds.height {
                        offset = scrollView.contentSize.height - previousOffsetY - scrollView.bounds.height
                    } else {
                        offset = scrollView.contentSize.height - previousOffsetY
                    }
                }
                
                switch offset {
                case 0 where state != .isRefreshing:
                    state = .initial
                case -fireHeight ... 0 where (state != .isRefreshing && state != .finished):
                    state = .isPulling(progress: -offset / fireHeight)
                case -10000 ... -fireHeight:
                    if !scrollView.isDragging && state == .isPulling(progress: 1) {
                        state = .isRefreshing
                    }
                    else if state != .finished && state != .isRefreshing {
                        state = .isPulling(progress: 1)
                    }
                default:
                    break
                }
            }
            
            if keyPath == KVOKeyContentSize {
                if type == .footer {
                    if let rf = refreshView as? UIView{
                        frame = CGRect(x: 0, y: scrollView.contentSize.height, width: scrollView.bounds.width, height: rf.bounds.height)
                    }
                }
            }
        }
        previousOffsetY = scrollView.contentOffset.y
    }
    
    private func addScrollViewObservers(scrollView: UIScrollView) {
        scrollView.addObserver(self, forKeyPath: KVOKeyOffset, options: .initial, context: &KVOContext)
        scrollView.addObserver(self, forKeyPath: KVOKeyContentSize, options: .initial, context: &KVOContext)
    }
    
    private func removeScrollViewObservers(scrollView: UIScrollView) {
        scrollView.removeObserver(self, forKeyPath: KVOKeyOffset, context: &KVOContext)
        scrollView.removeObserver(self, forKeyPath: KVOKeyContentSize, context: &KVOContext)
    }
    
    
    private func animationToRefreshing() {
        guard let scrollView = superview as? UIScrollView else { return }
        let inset = scrollView.contentInset
        var offset: CGFloat
        if type == .header {
            offset = -fireHeight - inset.top
        }else{
            offset = scrollView.contentSize.height + fireHeight + inset.bottom - scrollView.bounds.height
        }
        
        UIView.animate(withDuration: 0.3) {
            scrollView.contentInset = UIEdgeInsets(top: -offset, left: 0, bottom: 0, right: 0)
        }
        
    }
    
    private func endAnimation() {
        guard let scrollView = superview as? UIScrollView else { return }
        
        removeScrollViewObservers(scrollView: scrollView)
        
        let previousContentHeight = scrollView.contentSize.height
        
        UIView.animate(withDuration: 0.3, delay: finishedStayDuration, options: .curveLinear, animations: {
            scrollView.contentInset = self.defaultInset
            if self.type == .header {
                scrollView.contentOffset = self.defaultContentOffSet
            }else{
                if scrollView.contentSize.height > previousContentHeight {
                    scrollView.contentOffset.y += self.fireHeight
                }
            }
        }) { _ in
            self.state = .initial
            self.addScrollViewObservers(scrollView: scrollView)
        }
    }
}




