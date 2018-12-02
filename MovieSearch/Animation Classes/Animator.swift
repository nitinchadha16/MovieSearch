//
//  Animator.swift
//  MovieSearch
//
//  Created by Nitin Chadha on 03/12/18.
//  Copyright © 2018 Nitin Chadha. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.3
    var presenting = true
    var originFrame = CGRect.zero
    
    var dismissCompletion: (()->Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let detailImageView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        let initialFrame = presenting ? originFrame : detailImageView.frame
        let finalFrame = presenting ? detailImageView.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            detailImageView.transform = scaleTransform
            detailImageView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            detailImageView.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: detailImageView)
        
        
        UIView.animate(withDuration: duration, delay:0.0,
                       usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0,
                       animations: {
                        detailImageView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
                        detailImageView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        })
    }
}
