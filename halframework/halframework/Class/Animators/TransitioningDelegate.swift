//
//  BaseTransition.swift
//  WTHeo
//
//  Created by Dao Duy Duong on 8/7/17.
//  Copyright © 2017 Nover, Inc. All rights reserved.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    static var defaultAnimator: TransitioningDelegate = {
        return TransitioningDelegate(withAnimator: DefaultAnimator())
    }()
    
    let animator: Animator
    
    init(withAnimator animator: Animator) {
        self.animator = animator
        super.init()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = false
        return animator
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}

class Animator: NSObject, UIViewControllerAnimatedTransitioning  {
    
    var isPresenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("Subclassess have to impleted this method")
    }
    
}

class PresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool { return true }
}











