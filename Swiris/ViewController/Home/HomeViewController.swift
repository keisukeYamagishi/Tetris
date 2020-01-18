import UIKit

@available(iOS 10.0, *)
class HomeViewController: UIViewController,UINavigationControllerDelegate {

    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var startGame: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startGame.layer.cornerRadius = 10
        self.gameTitle.layer.cornerRadius = 10
    }
    
    @IBAction func pushInButton(_ sender: Any) {
        let brewris = (self.storyboard?.instantiateViewController(withIdentifier: "Swiris"))! as! Swiris
        self.navigationController?.pushViewController(brewris, animated: true)
    }
    
//    func navigationController(_ navigationController: UINavigationController,
//                              animationControllerFor operation: UINavigationController.Operation,
//                              from fromVC: UIViewController,
//                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
//        let tngition: HUTransitionAnimator = HUTransitionVerticalLinesAnimator()
//        tngition.presenting = (operation == .pop) ? false:true
//        return tngition
//    }
}

