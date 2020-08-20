//  The converted code is limited to 4 KB.
//  Upgrade your plan to remove this limitation.
//
//  Converted to Swift 4 by Swiftify v4.1.6669 - https://objectivec2swift.com/
//
//  HUTransitionHorizontalLinesAnimator.m
//  EasyBeats
//
//  Created by Christian Inkster on 16/09/13.
//
//

import UIKit

class HUTransitionHorizontalLinesAnimator: HUTransitionAnimator {
    let HLANIMATION_TIME1 = 0.01
    let HLANIMATION_TIME2 = 1.70 // 4.70

    override func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return HLANIMATION_TIME1 + HLANIMATION_TIME2
    }

    let HLINEHEIGHT = 4.0
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning?) {
        let fromVC: UIViewController? = transitionContext?.viewController(forKey: .from)
        let toVC: UIViewController? = transitionContext?.viewController(forKey: .to)
        // get the container view
        let containerView: UIView? = transitionContext?.containerView
        // lets get a snapshot of the outgoing view
        let mainSnap: UIView? = fromVC?.view.snapshotView(afterScreenUpdates: false)
        // cut it into vertical slices
        let outgoingLineViews = cut(mainSnap, intoSlicesOfHeight: Float(HLINEHEIGHT), yOffset: Float((fromVC?.view.frame.origin.y)!))
        // add the slices to the content view.
        for v in outgoingLineViews! {
//            if let aV: UIView = v as? UIView {
            containerView?.addSubview(v)
//           }
        }
        let toView: UIView? = toVC?.view
        if let aVC = toVC {
            toView?.frame = (transitionContext?.finalFrame(for: aVC))!
        }
        if let aView = toView {
            containerView?.addSubview(aView)
        }
        let toViewStartX: CGFloat? = toView?.frame.origin.x
        toView?.alpha = 0
        fromVC?.view.isHidden = true
        let presenting: Bool = self.presenting
        UIView.animate(withDuration: HLANIMATION_TIME1, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
        }, completion: { (_: Bool) -> Void in
            toVC?.view.alpha = 1
            let mainInSnap: UIView? = toView?.snapshotView(afterScreenUpdates: true)
            // cut it into vertical slices
            let incomingLineViews = self.cut(mainInSnap, intoSlicesOfHeight: Float(self.HLINEHEIGHT), yOffset: Float((toView?.frame.origin.y)!))
            // move the slices in to start position (incoming comes from the right)
            self.repositionViewSlices(incomingLineViews, moveLeft: !presenting)
            // add the slices to the content view.
            for v in incomingLineViews! {
//                if let aV:UIView = v as! UIView {
                containerView?.addSubview(v)
//                }
            }
            toView?.isHidden = true
            UIView.animate(withDuration: self.HLANIMATION_TIME2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: { () -> Void in
                self.repositionViewSlices(outgoingLineViews, moveLeft: presenting)
                self.resetViewSlices(incomingLineViews, toXOrigin: toViewStartX!)
            }, completion: { (_: Bool) -> Void in
                fromVC?.view.isHidden = false
                toView?.isHidden = false
                toView?.setNeedsUpdateConstraints()
                for v in incomingLineViews! {
//                    let vi: UIView = v as! UIView
                    v.removeFromSuperview()
                }
                for v in outgoingLineViews! {
//                    var vi : UIView = v as! UIView
                    v.removeFromSuperview()
                }
                transitionContext?.completeTransition(true)
            })
        })
    }

    func cut(_ view: UIView?, intoSlicesOfHeight height: Float, yOffset: Float) -> [UIView]? {
        let lineWidth: CGFloat = (view?.frame.width)!
        var lineViews = [UIView]()
        var y: Float = 0
        while CGFloat(y) < (view?.frame.height)! {
            var subrect = CGRect(x: 0, y: CGFloat(y), width: CGFloat(lineWidth), height: CGFloat(height))
            var subsnapshot: UIView?
            subsnapshot = view?.resizableSnapshotView(from: subrect, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
            subrect.origin.y += CGFloat(yOffset)
            subsnapshot?.frame = subrect
            if let aSubsnapshot = subsnapshot {
                lineViews.append(aSubsnapshot)
            }
            y += height
        }
        return lineViews
    }

    func repositionViewSlices(_ views: [UIView]?, moveLeft left: Bool) {
        var frame: CGRect
        var width: Float
        for line in views! {
            frame = line.frame
            width = Float(frame.width * CGFloat(arc4random() / UInt32(0x1000_0000)) * 8) // HUTransitionAnimator.randomFloat(min: 1.0, max: 8.0))
            print("width: \(width)")
            frame.origin.x += CGFloat(left ? -width : width)
            // save the new position
            line.frame = frame
        }
    }

    /**
     resets the views back to a specified x origin.
     @param views The array of uiview objects to reposition
     @param x The x origin to set all the views frames to.
     */
    func resetViewSlices(_ views: [UIView]?, toXOrigin x: CGFloat) {
        var frame: CGRect
        for line in views! {
            frame = line.frame
            frame.origin.x = x
            line.frame = frame
        }
    }
}
