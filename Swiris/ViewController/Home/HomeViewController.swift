import UIKit

@available(iOS 10.0, *)
final class HomeViewController: UIViewController {
    @IBOutlet var gameTitle: UILabel!
    @IBOutlet var startGame: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
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
