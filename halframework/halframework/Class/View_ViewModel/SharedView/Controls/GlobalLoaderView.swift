 //
//  GlobalLoaderView.swift
//  FDS
//
//  Created by Dao Duy Duong on 5/29/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit

public class GlobalLoaderView: AbstractControlView {
    
    static var rootView: UIView {
        return UIApplication.shared.keyWindow!
    }
    
    static let myTag = 10001
    
    var indicatorImageView: UIImageView!
    var rotationImageView: UIImageView!
    var label: UILabel!
    
    lazy var rotationAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = NSNumber(value: 0)
        animation.toValue = NSNumber(value: Float.pi*2)
        animation.duration = 1
        animation.repeatCount = Float.infinity
        return animation
    }()

    override func setupView() {
        let holderView = UIView()
        holderView.cornerRadius = 7
        holderView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        addSubview(holderView)
        holderView.autoCenterInSuperview()
        
        let paddingView = UIView()
        holderView.addSubview(paddingView)
        paddingView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        
        indicatorImageView = UIImageView()
        indicatorImageView.contentMode = .scaleAspectFit
        indicatorImageView.image = Image.make(fromName: "loading")
        paddingView.addSubview(indicatorImageView)
        indicatorImageView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        indicatorImageView.autoSetDimension(.height, toSize: 53)
        
        rotationImageView = UIImageView()
        rotationImageView.contentMode = .scaleAspectFit
        rotationImageView.image = Image.make(fromName: "processing")
        paddingView.addSubview(rotationImageView)
        rotationImageView.autoConstrainAttribute(.top, to: .top, of: indicatorImageView)
        rotationImageView.autoConstrainAttribute(.leading, to: .leading, of: indicatorImageView)
        rotationImageView.autoMatch(.width, to: .width, of: indicatorImageView)
        rotationImageView.autoMatch(.height, to: .height, of: indicatorImageView)
        
        label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        paddingView.addSubview(label)
        label.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        label.autoPinEdge(.top, to: .bottom, of: indicatorImageView, withOffset: 5)
    }
    
    @discardableResult
    static func showWithTitle(_ title: String?, forView view: UIView?) -> GlobalLoaderView {
        let superview = view ?? rootView
        var loaderView = superview.viewWithTag(myTag) as? GlobalLoaderView
        if loaderView == nil {
            loaderView = GlobalLoaderView()
            loaderView?.tag = myTag
            superview.addSubview(loaderView!)
            loaderView?.autoPinEdgesToSuperviewEdges()
        }
        
        loaderView?.label.text = title ?? "Loading..."
        
        loaderView?.show()
        
        return loaderView!
    }
    
    static func hide(forView view: UIView?) {
        let superview = view ?? rootView
        if let loaderView = superview.viewWithTag(myTag) as? GlobalLoaderView {
            loaderView.hide()
        }
    }
    
    func show() {
        transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        alpha = 0
        rotationImageView.layer.add(self.rotationAnimation, forKey: "rotation")
        
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
            self.transform = .identity
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { _ in
            self.rotationImageView.layer.removeAllAnimations()
            self.removeFromSuperview()
        }
    }

}

public class GlobalSuccessLoaderView: AbstractControlView {
    
    static var rootView: UIView {
        return UIApplication.shared.keyWindow!
    }
    
    static let myTag = 10002
    
    var imageView: UIImageView!
    var titleLbl: UILabel!
    
    override func setupView() {
        let holderView = UIView()
        holderView.cornerRadius = 7
        holderView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        addSubview(holderView)
        holderView.autoCenterInSuperview()
        
        let paddingView = UIView()
        holderView.addSubview(paddingView)
        paddingView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Image.make(fromName: "WhiteCheckmark")
        paddingView.addSubview(imageView)
        imageView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        titleLbl = UILabel()
        titleLbl.textColor = .white
        titleLbl.font = Font.system.bold(withSize: 17)
        paddingView.addSubview(titleLbl)
        titleLbl.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        titleLbl.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: 5)
    }
    
    @discardableResult
    static func showWithTitle(_ title: String?, dismissAfter seconds: Double) -> GlobalSuccessLoaderView {
        var loaderView = rootView.viewWithTag(myTag) as? GlobalSuccessLoaderView
        if loaderView == nil {
            loaderView = GlobalSuccessLoaderView()
            loaderView?.tag = myTag
            rootView.addSubview(loaderView!)
            loaderView?.autoPinEdgesToSuperviewEdges()
        }
        
        loaderView?.titleLbl.text = title
        
        loaderView?.show()
        delay(seconds) {
            loaderView?.hide()
        }
        
        return loaderView!
    }
    
    static func hide(forView view: UIView?) {
        let superview = view ?? rootView
        if let loaderView = superview.viewWithTag(myTag) as? GlobalLoaderView {
            loaderView.hide()
        }
    }
    
    func show() {
        UIView.animate(withDuration: 0.25, animations: { self.alpha = 1 })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.25, animations: { self.alpha = 0 }) { _ in
            self.removeFromSuperview()
        }
    }
    
}








