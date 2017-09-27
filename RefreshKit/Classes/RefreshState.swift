//
//  RefreshState.swift
//  RefreshKit
//
//  Created by sy on 2017/9/19.
//  Copyright © 2017年 AceSha. All rights reserved.
//

import Foundation
import UIKit


public enum RefreshStateStringKey {
    case initial
    case isPulling
    case shouldRelease
    case isRefreshing
    case finished
}

extension RefreshStateStringKey: Hashable {
    public var hashValue: Int {
        switch self {
        case .initial: return 0
        case .isPulling: return 1
        case .shouldRelease: return 2
        case .isRefreshing: return 3
        case .finished: return 4
        }
    }
}


public enum RefreshState {
    case initial
    case isPulling(progress: CGFloat)
    case isRefreshing
    case finished
}

extension RefreshState: Equatable {

    public static func ==(lhs: RefreshState, rhs: RefreshState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case (.isPulling, .isPulling):
            return true
        case (.isRefreshing, .isRefreshing):
            return true
        case (.finished, .finished):
            return true
        default:
            return false
        }
    }
}

