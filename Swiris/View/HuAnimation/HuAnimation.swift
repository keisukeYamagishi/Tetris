//  Converted to Swift 4 by Swiftify v4.1.6669 - https://objectivec2swift.com/
//
//  HUOldStylePushPopAnimator.m
//  EasyBeats
//
//  Created by Christian Inkster on 13/09/13.
//
//

import Foundation
import UIKit

class HUTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var presenting: Bool = false
    let OLDPUSHANIMATION_TIME = 0.10
    /// returns the duration of the oldPushAnimation

    static func randomFloat(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(arc4random() / UInt32(0x1000_0000)) * ((max - min) - min)
    }

    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return OLDPUSHANIMATION_TIME
    }

    /**
     oldPushTransition
     Simulates the original push and pop transitions available in iOS 6 and earlier.
     @param transitionContext
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC: UIViewController? = transitionContext.viewController(forKey: .from)
        let toVC: UIViewController? = transitionContext.viewController(forKey: .to)
        var endFrame: CGRect = CGRect.zero

        if let aVC = fromVC {
            endFrame = transitionContext.initialFrame(for: aVC)
        }

        if presenting {
            fromVC?.view.frame = endFrame
            transitionContext.containerView.addSubview((fromVC?.view)!)
            let toView: UIView? = toVC?.view
            if let aView = toView {
                transitionContext.containerView.addSubview(aView)
            }
            // get the original position of the frame
            let startFrame: CGRect = (toView?.frame)!
            // save the unmodified frame as our end frame
            endFrame = startFrame
            // now move the start frame to the left by our width
//            let start = startFrame.origin.x += (startFrame.width)
            toView?.frame = startFrame
            // now set up the destination for the outgoing view
            let fromView: UIView? = fromVC?.view
            var outgoingEndFrame: CGRect = (fromView!.frame)
            outgoingEndFrame.origin.x -= outgoingEndFrame.width
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
                toView?.frame = endFrame
                toView?.alpha = 1
                fromView?.frame = outgoingEndFrame
                fromView?.alpha = 0
            }, completion: { (_: Bool) -> Void in
                fromView?.alpha = 1
                toView?.setNeedsUpdateConstraints()
                transitionContext.completeTransition(true)
            })
        } else {
            let toView: UIView? = toVC?.view
            // incoming view
            var toFrame: CGRect = CGRect.zero
            if let aVC = toVC {
                toFrame = transitionContext.finalFrame(for: aVC)
            }
            toFrame.origin.x -= toFrame.width
            toView?.frame = toFrame
            if let aVC = toVC {
                toFrame = transitionContext.finalFrame(for: aVC)
            }
            if let aView = toView {
                transitionContext.containerView.addSubview(aView)
            }
            transitionContext.containerView.addSubview((fromVC?.view)!)
            // outgoing view
            endFrame.origin.x += endFrame.width
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                toView?.frame = toFrame
                toView?.alpha = 1
                fromVC?.view.frame = endFrame
                fromVC?.view.alpha = 0
            }, completion: { (_: Bool) -> Void in
                fromVC?.view.alpha = 1
                transitionContext.completeTransition(true)
            })
        }
    }
}
