import UIKit

@available(iOS 10.0, *)
final class HomeViewController: UIViewController {
    @IBOutlet private var gameTitle: UILabel!
    @IBOutlet private var startGame: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startGame.layer.cornerRadius = 10
        gameTitle.layer.cornerRadius = 10
    }

    @IBAction func pushInButton(_: Any) {
        let storyboard = UIStoryboard(name: "Swiris", bundle: nil)
        let brewris = storyboard.instantiateInitialViewController()
        navigationController?.pushViewController(brewris!, animated: true)
    }
}

@available(iOS 10.0, *)
extension HomeViewController: UINavigationControllerDelegate {
    func navigationController(_: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from _: UIViewController,
                              to _: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        let tngition: HUTransitionAnimator = HUTransitionVerticalLinesAnimator()
        tngition.presenting = (operation == .pop) ? false : true
        return tngition
    }
}
