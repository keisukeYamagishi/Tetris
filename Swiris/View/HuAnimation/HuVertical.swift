//  The converted code is limited to 4 KB.
//  Upgrade your plan to remove this limitation.
//
//  Converted to Swift 4 by Swiftify v4.1.6669 - https://objectivec2swift.com/
//
//  HUTransitionVerticalLinesAnimator.m
//  EasyBeats
//
//  Created by Christian Inkster on 16/09/13.
//
//
import UIKit

class HUTransitionVerticalLinesAnimator: HUTransitionAnimator {
    let VLANIMATION_TIME1 = 0.01
    let VLANIMATION_TIME2 = 1.0 // 4.0
    /// returns the duration of the verticalLinesAnimation

    override func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return VLANIMATION_TIME1 + VLANIMATION_TIME2
    }

    let VLINEWIDTH = 4.0
    /**
     verticalLinesTransition
     snapshots the outgoing view, slices it into vertical lines, then animates them at random rates off the screen.
     @param transitionContext
     */
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning?) {
        let fromVC: UIViewController? = transitionContext?.viewController(forKey: .from)
        let toVC: UIViewController? = transitionContext?.viewController(forKey: .to)
        // get the container view
        let containerView: UIView? = transitionContext?.containerView
        // lets get a snapshot of the outgoing view
        let mainSnap: UIView? = fromVC?.view.snapshotView(afterScreenUpdates: false)
        // cut it into vertical slices
        let outgoingLineViews = cut(mainSnap!, intoSlicesOfWidth: CGFloat(VLINEWIDTH))
        // add the slices to the content view.
        for v in outgoingLineViews! {
//            if let aV = v {
            containerView?.addSubview(v)
//            }
        }
        let toView: UIView? = toVC?.view
        if let aVC = toVC {
            toView?.frame = (transitionContext?.finalFrame(for: aVC))!
        }
        if let aView = toView {
            containerView?.addSubview(aView)
        }
        let toViewStartY: CGFloat? = toView?.frame.origin.y
        toView?.alpha = 0
        fromVC?.view.isHidden = true
        UIView.animate(withDuration: VLANIMATION_TIME1, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            // This is basically a hack to get the incoming view to render before I snapshot it.
        }, completion: { (_: Bool) -> Void in
            toVC?.view.alpha = 1
            let mainInSnap: UIView? = toView?.snapshotView(afterScreenUpdates: true)
            // cut it into vertical slices
            let incomingLineViews = self.cut(mainInSnap!, intoSlicesOfWidth: CGFloat(self.VLINEWIDTH))
            // move the slices in to start position (mess them up)
            self.repositionViewSlices(incomingLineViews, moveFirstFrameUp: false)
            // add the slices to the content view.
            for v in incomingLineViews! {
                containerView?.addSubview(v)
            }

            toView?.isHidden = true
            UIView.animate(withDuration: self.VLANIMATION_TIME2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: { () -> Void in
                self.repositionViewSlices(outgoingLineViews, moveFirstFrameUp: true)
                self.resetViewSlices(views: incomingLineViews!, toYOrigin: toViewStartY!)
            }, completion: { (_: Bool) -> Void in
                fromVC?.view.isHidden = false
                toView?.isHidden = false
                toView?.setNeedsUpdateConstraints()
                for v in incomingLineViews! {
                    v.removeFromSuperview()
                }
                for v in outgoingLineViews! {
                    v.removeFromSuperview()
                }
                transitionContext?.completeTransition(true)
            })
        })
    }

    /**
     cuts a \a view into an array of smaller views of \a width
     @param view the view to be sliced up
     @param width The width of each slice
     @returns A mutable array of the sliced views with their frames representative of their position in the sliced view.
     */
    func cut(_ view: UIView, intoSlicesOfWidth width: CGFloat) -> [UIView]? {
        let lineHeight: CGFloat = view.frame.height
        var lineViews = [UIView]()
        var x: CGFloat = 0
        while x < view.frame.width {
            let subrect = CGRect(x: x, y: 0, width: CGFloat(width), height: lineHeight)
            var subsnapshot: UIView?
            subsnapshot = view.resizableSnapshotView(from: subrect, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
            subsnapshot?.frame = subrect
            if let aSubsnapshot = subsnapshot {
                lineViews.append(aSubsnapshot)
            }
            x += width
        }
        return lineViews
    }

    /**
     repositions an array of \a views alternatively up and down by their frames height
     @param views The array of views to reposition
     @param startUp start with the first view moving up (YES) or down (NO)
     */
    func repositionViewSlices(_ views: [UIView]?, moveFirstFrameUp startUp: Bool) {
        var up: Bool = startUp
        var frame: CGRect
        var height: Float
        for line in views! {
            frame = line.frame
            height = Float(frame.height * HUTransitionAnimator.randomFloat(min: 1.0, max: 4.0))
            frame.origin.y += CGFloat(up ? -height : height)
            // save the new position
            line.frame = frame
            up = !up
        }
    }

    /**
     resets the views back to a specified y origin.
     @param views The array of uiview objects to reposition
     @param y The y origin to set all the views frames to.
     */
    func resetViewSlices(views: [UIView], toYOrigin y: CGFloat) {
        var frame: CGRect = CGRect.zero
        for line in views {
            frame = line.frame
            frame.origin.y = y
            // save the new position
            line.frame = frame
        }
    }
}
