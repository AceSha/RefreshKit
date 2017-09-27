//
//  RefreshKit.swift
//  RefreshKit
//
//  Created by sy on 2017/9/19.
//  Copyright © 2017年 AceSha. All rights reserved.
//

import UIKit


public protocol ExtensionsCompatible {
    associatedtype CompatibleType
    var refresh: CompatibleType { get }
}

public struct Extensions<Base> {
    internal let base: Base
    fileprivate init(_ base: Base) {
        self.base = base
    }
}

public extension ExtensionsCompatible {
    public var refresh: Extensions<Self> {
        return Extensions(self)
    }
}


extension UIScrollView: ExtensionsCompatible { }

