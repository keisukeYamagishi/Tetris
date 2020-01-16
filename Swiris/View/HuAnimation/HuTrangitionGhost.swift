//  The converted code is limited to 4 KB.
//  Upgrade your plan to remove this limitation.
//
//  Converted to Swift 4 by Swiftify v4.1.6669 - https://objectivec2swift.com/
//
//  HUTransitionGhostAnimator.m
//  EasyBeats
//
//  Created by Christian Inkster on 16/09/13.
//
//
import UIKit

class HUTransitionGhostAnimator: HUTransitionAnimator {
    let GHOSTANIMATION_TIME1 = 0.1
    let GHOSTANIMATION_TIME2 = 0.20
    /// returns the duration of the oldPushAnimation
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return GHOSTANIMATION_TIME1 + GHOSTANIMATION_TIME2
    }
    
    /**
     ghostPushTransition
     Simulates the original push and pop transitions available in iOS 6 and earlier, but gives a short ghosting effect first
     @param transitionContext
     */
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning?) {
        let fromVC: UIViewController? = transitionContext?.viewController(forKey: .from)
        let toVC: UIViewController? = transitionContext?.viewController(forKey: .to)
        var endFrame: CGRect = CGRect.zero
        if let aVC = fromVC {
            endFrame = (transitionContext?.initialFrame(for: aVC))!
        }
        if presenting {
            //lets get a snapshot of the outgoing view
            let ghost: UIView? = fromVC?.view.snapshotView(afterScreenUpdates: false)
            //get the container view
            let containerView: UIView? = transitionContext?.containerView
            //put the ghost in the container
            if let aGhost = ghost {
                containerView?.addSubview(aGhost)
            }
            fromVC?.view.frame = endFrame
            transitionContext?.containerView.addSubview((fromVC?.view)!)
            let toView: UIView? = toVC?.view
            if let aView = toView {
                transitionContext?.containerView.addSubview(aView)
            }
            //get the original position of the frame
            var startFrame: CGRect = (toView?.frame)!
            //save the unmodified frame as our end frame
            endFrame = startFrame
            //now move the start frame to the left by our width
            startFrame.origin.x += (startFrame.width)
            toView?.frame = startFrame
            //now set up the destination for the outgoing view
            let fromView: UIView? = fromVC?.view
            var outgoingEndFrame: CGRect = (fromView?.frame)!
            outgoingEndFrame.origin.x -= (outgoingEndFrame.width)
            UIView.animateKeyframes(withDuration: GHOSTANIMATION_TIME1, delay: 0, options: .beginFromCurrentState, animations: {() -> Void in
                var ghostRect: CGRect? = ghost?.frame
                ghostRect?.origin.x += 25
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3, animations: {() -> Void in
                    ghost?.frame = ghostRect!
                })
                ghostRect?.origin.x -= 100
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7, animations: {() -> Void in
                    ghost?.frame = ghostRect!
                })
                ghost?.alpha = 0
            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: self.GHOSTANIMATION_TIME2, delay: 0.0, options: .curveEaseIn, animations: {() -> Void in
                    toView?.frame = endFrame
                    toView?.alpha = 1
                    fromView?.frame = outgoingEndFrame
                    fromView?.alpha = 0
                }, completion: {(_ finished: Bool) -> Void in
                    fromView?.alpha = 1
                    toView?.setNeedsUpdateConstraints()
                    transitionContext?.completeTransition(true)
                })
            })
        } else {
            let toView: UIView? = toVC?.view
            //incoming view
            var toFrame: CGRect = endFrame
            toFrame.origin.x -= toFrame.width
            toView?.frame = toFrame
            toFrame = endFrame
            if let aView = toView {
                transitionContext?.containerView.addSubview(aView)
            }
            transitionContext?.containerView.addSubview((fromVC?.view)!)
            //outgoing view
            endFrame.origin.x += endFrame.width
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseOut, animations: {() -> Void in
                toView?.frame = toFrame
                toView?.alpha = 1
                fromVC?.view.frame = endFrame
                fromVC?.view.alpha = 0
            }, completion: {(_ finished: Bool) -> Void in
                fromVC?.view.alpha = 1
                transitionContext?.completeTransition(true)
            })
        }
    }
}
