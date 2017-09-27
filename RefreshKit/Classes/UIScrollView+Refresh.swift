//
//  UIScrollView+Refresh.swift
//  RefreshKit
//
//  Created by sy on 2017/9/19.
//  Copyright © 2017年 AceSha. All rights reserved.
//

import UIKit

private var headerRefreshKey: UInt8 = 0
private var footerRefreshKey: UInt8 = 0
private var refreshStateKey: UInt8 = 0


public extension Extensions where Base: UIScrollView {
     fileprivate(set) var header: RefreshContainer {
        get {
            if let controller = objc_getAssociatedObject(base, &headerRefreshKey) as? RefreshContainer {
                return controller
            }
            let control = RefreshContainer(refreshView: DefaultRefreshView.instance(type: .header), scrollView: base)
            objc_setAssociatedObject(base, &headerRefreshKey, control, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return control
        }
        set {
            base.addSubview(newValue)
            objc_setAssociatedObject(base, &headerRefreshKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    fileprivate(set) var footer: RefreshContainer {
        get {
            if let controller = objc_getAssociatedObject(base, &footerRefreshKey) as? RefreshContainer {
                return controller
            }
            let control = RefreshContainer(refreshView: DefaultRefreshView.instance(type: .footer), scrollView: base, type: .footer)
            objc_setAssociatedObject(base, &footerRefreshKey, control, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return control
        }
        set {
            base.addSubview(newValue)
            objc_setAssociatedObject(base, &footerRefreshKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    func setHeadher<U: Refreshable>(_ view: U) -> RefreshContainer {
        let control = RefreshContainer(refreshView: view, scrollView: base)
        objc_setAssociatedObject(base, &headerRefreshKey, control, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return control
    }
    
    @discardableResult
    func setFooter<U: Refreshable>(_ view: U) -> RefreshContainer {
        let control = RefreshContainer(refreshView: view, scrollView: base, type: .footer)
        objc_setAssociatedObject(base, &headerRefreshKey, control, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return control
    }
}


public extension RefreshContainer {
    @discardableResult
    func configure(_ closure: (RefreshContainer) -> Void) -> Self {
        closure(self)
        return self
    }
    
    @discardableResult
    func addAction(_ a: @escaping () -> Void) -> Self {
        action = a
        return self
    }
    
    func endRefreshing() {
        if let _ = superview as? UIScrollView {
            if self.state == .isRefreshing {
                self.state = .finished
            }
        }
    }
    
    func beginRefreshing() {
        if let _ = superview as? UIScrollView {
            if state != .isRefreshing {
                action?()
                state = .isRefreshing
            }
        }
    }
    
    func endRefreshingWithMessage(msg: String, delay: TimeInterval) {
        if let _ = superview as? UIScrollView {
            if state == .isRefreshing {
                self.endRefreshingWithMessage = msg
                self.finishedStayDuration = delay
                self.state = .finished
            }
        }
    }
}


public protocol Refreshable: class {
    //required
    func animationForState(state: RefreshState)
    
    // optional
    func fireHeight() -> CGFloat
    func finishedStayDuration() -> TimeInterval
}


// Default configures
extension Refreshable {
    
    public func fireHeight() -> CGFloat {
        return 0
    }
    
    public func finishedStayDuration() -> TimeInterval {
        return 0
    }
}



