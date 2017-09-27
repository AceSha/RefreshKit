//
//  CustomView.swift
//  RefreshKit
//
//  Created by sy on 2017/9/27.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import RefreshKit

class CustomView: UIView, Refreshable {
    func animationForState(state: RefreshState) {
        switch state {
        case .initial:
            print("initail")
        default:
            break
        }
    }
}
