//
//  DefaultRefreshView.swift
//  RefreshKit
//
//  Created by sy on 2017/9/19.
//  Copyright © 2017年 AceSha. All rights reserved.
//

import UIKit


public enum RefreshType {
    case header
    case footer
}

public class DefaultRefreshView: UIView, Refreshable{
    
    public var dictForStates: [RefreshStateStringKey: String]?
    
    public var singleCustomDictForStates: [RefreshStateStringKey: String]?
    
    public static func instance(type: RefreshType) -> DefaultRefreshView {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        let rv = DefaultRefreshView(type: type, frame: frame)
        return rv
    }
    
    internal var color: UIColor = .lightGray {
        willSet {
            imageView.image = imageView.image?.imageRenderTintColor(newValue)
            label.textColor = newValue
        }
    }
    
    private var type: RefreshType?
    
    private let label = UILabel()
    
    private let imageView = UIImageView()
    
    private let refreshC = UIActivityIndicatorView()
    
    convenience public init(type: RefreshType, frame: CGRect) {
        self.init(frame: frame)
        self.type = type
        var image = UIImage(named: "a_arrow", in: Bundle(for: DefaultRefreshView.self), compatibleWith: nil)
        if type == .footer {
            image = image?.verticalFlip()
        }
        imageView.image = image?.imageRenderTintColor(.lightGray)
        imageView.sizeToFit()
        configureDict()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.textColor = UIColor.lightGray
        addSubview(imageView)
        addSubview(refreshC)
        refreshC.isHidden = true
        refreshC.color = .lightGray
        label.textAlignment = .center
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        label.sizeToFit()
        label.frame = frame
        imageView.frame = CGRect(x: frame.width * 0.3, y: (frame.height - imageView.frame.height) / 2, width: imageView.frame.width, height: imageView.frame.height)
        refreshC.frame = imageView.frame
        super.layoutSubviews()
    }
    
    public func animationForState(state: RefreshState) {
        guard let dictForStates = dictForStates else { return }
        switch state {
        case .initial:
            label.text = dictForStates[.initial]
            refreshC.stopAnimating()
        case .isPulling(let p):
            if p >= 1 {
                if let sr = dictForStates[.shouldRelease] {
                    label.text = sr
                }
            }else {
                label.text = dictForStates[.isPulling]
            }
            
            animation(p: p)
        case .isRefreshing:
            label.text = dictForStates[.isRefreshing]
            refreshC.startAnimating()
        case .finished:
            label.text = dictForStates[.finished]
            refreshC.stopAnimating()
        }
        
        imageViewHidden(state: state)
    }
    
    private func configureDict() {
        var dictForStates: [RefreshStateStringKey: String]
        if let dict = singleCustomDictForStates {
            dictForStates = dict
        }else{
            switch type! {
            case .header:
                dictForStates = defaultDictForHeaderStates
            default:
                dictForStates = defaultDictForFooterStates
            }
        }

        self.dictForStates = dictForStates
    }
    
    private func imageViewHidden(state: RefreshState) {
        switch state {
        case .isPulling:
            imageView.isHidden = false
        default:
            imageView.isHidden = true
        }
    }
    
    private func animation(p: CGFloat) {
        if type == .footer { return }
        if p >= 1 {
            UIView.animate(withDuration: 0.2, animations: {
                self.imageView.layer.setAffineTransform(CGAffineTransform.init(rotationAngle: CGFloat(-Double.pi)))
            })
        }else{
            UIView.animate(withDuration: 0.2, animations: { 
                self.imageView.layer.setAffineTransform(CGAffineTransform.identity)
            })
        }
    }
}

extension UIImage {
    func imageRenderTintColor(_ color: UIColor) -> UIImage {
        
        let size = self.size
        
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        self.draw(at: CGPoint.zero, blendMode: CGBlendMode.normal, alpha: 1.0)
        
        context!.setFillColor(color.cgColor)
        context!.setBlendMode(CGBlendMode.sourceIn)
        context!.setAlpha(1.0)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsGetCurrentContext()!.fill(rect)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage!
    }
    
    func verticalFlip() -> UIImage {
        //翻转图片的方向
        var flipImageOrientation = (self.imageOrientation.rawValue + 4) % 8
        flipImageOrientation += flipImageOrientation % 2 == 0 ? 1 : -1
        //翻转图片
        return UIImage(cgImage: self.cgImage!,
                                scale: self.scale,
                                orientation: .downMirrored)
    }
}


fileprivate var defaultDictForHeaderStates: [RefreshStateStringKey: String] = [
    .isPulling : "下拉刷新",
    .shouldRelease: "释放更新",
    .isRefreshing: "加载中...",
    .finished: "刷新成功"
]

fileprivate var defaultDictForFooterStates: [RefreshStateStringKey: String] = [
    .isPulling : "加载更多",
    .isRefreshing: "刷新中...",
]




