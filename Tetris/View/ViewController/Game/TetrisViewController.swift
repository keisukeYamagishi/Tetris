import UIKit

final class TetrisViewController: UIViewController {
    var score: Int = 0
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var nextBarField: NextBarField!
    @IBOutlet var rotstionButton: UIButton!
    var firstTap: CGFloat = 0
    @IBOutlet var fieldView: FieldView!
    @IBOutlet var levelLbl: UILabel!
    var nextTheBar: [[Int]]!
    var moveBar: Timer!
    var levelMng: LevelManager!
    var bars = Bars()

    @IBOutlet var brewViewHeightConstraint: NSLayoutConstraint!
    var tetrisCount: Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = navigationTitle(title: "Tetris")
        levelMng = LevelManager()
        setGesture()
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.text = "0"
    }

    func setGesture() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(pushRotation))
        view.addGestureRecognizer(tapGes)

        let swipeGes = UISwipeGestureRecognizer(target: self, action: #selector(downBar))
        swipeGes.direction = .down
        view.addGestureRecognizer(swipeGes)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        barInit()
        startBrew()
    }

    @IBAction func pushInBackButton(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func pushRotation(_: Any) {
        tapRotation()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        let touch = touches.first
        firstTap = touch!.location(in: view).x
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        let touch = touches.first
        let newDx = touch?.location(in: view).x
        let move = firstTap - newDx!
        if move < -11 {
            if move.truncatingRemainder(dividingBy: 2) == 0 {
                swipeRight()
            }
        } else if move > 11 {
            if move.truncatingRemainder(dividingBy: 2) == 0 {
                swipeLeft()
            }
        }
    }

    @IBAction func left(_: Any) {
        swipeLeft()
    }

    @IBAction func right(_: Any) {
        swipeRight()
    }

    func swipeLeft() {
        if bars.isSwipe(.left) {
            bars.cp.px -= 1
            bars.move()
            fieldView.barDisplay(bars: bars.values)
        }
    }

    func swipeRight() {
        if bars.isSwipe(.right) {
            bars.cp.px += 1
            bars.move()
            fieldView.barDisplay(bars: bars.values)
        }
    }

    @objc func downGes() {
        downBar()
    }

    @objc func downBar() {
        bars.down {
            moveBar.invalidate()
            gameOverAlert()
        }
        onTheBar()
    }

    @objc func tapRotation() {
        rotation()
    }

    /*
     [[0,0,0,0],   [[0,0,0,0],
     [0,1,1,0],    [0,0,0,0],
     [0,0,1,0], -> [1,1,1,0],
     [0,0,1,0]]    [1,0,0,0]]
     */
    func rotation() {
        bars.spin()

        if bars.fixPosition() {
            return
        }
        bars.RMS()
        bars.move()
        fieldView.barDisplay(bars: bars.values)
    }

    func startBrew() {
        levelLbl.text = levelMng.levelText
        scoreLabel.text = "0"
        score = 0
        nextTheBar = nil
        fieldView.initialze()
        nextBarField.initializeField()
        nextBarField.displayNextBar()
        bars = Bars()
        bars.getTheBar()
        bars.setBar()
        bars.cp.px = DPX
        bars.cp.py = DPY
        startGame()
    }

    func startGame() {
        if levelMng.currentLevel > 12 {
            levelMng.currentLevel = 12
        }
        startEngine()
    }

    func startEngine() {
        moveBar = Timer.scheduledTimer(timeInterval: TimeInterval(levelMng.levelCount / 10),
                                       target: self,
                                       selector: #selector(engine),
                                       userInfo: nil, repeats: true)
    }

    @objc func engine() {
        tetrisCount += 0.1
        if tetrisCount >= levelMng.levelCount {
            tetrisCount = 0
            move()
        }
    }

    func barInit() {
        brewViewHeightConstraint.constant = fieldView.height
        fieldView.configure()
    }

    func gameOverAlert() {
        let actions = [AlertAction(title: "Ok",
                                   style: .default,
                                   handler: { _, _ in
                                       self.startBrew()
                                   })]
        alert(title: "GAME OVER", message: "Out of move", actions: actions)
    }

    @objc func move() {
        if bars.isBottom {
            bars.move()
            fieldView.barDisplay(bars: bars.values)
            bars.cp.py += 1
        } else {
            bars.initalize()
            onTheBar()
        }
        BarLog(bar: bars.values)
    }

    func onTheBar() {
        if bars.isRemove() {
            fieldView.barDisplay(bars: bars.values)
            setScore(sc: bars.removeCount)
        }
        bars.store()
        setNextBar()
    }

    func setNextBar() {
        if bars.isGameOver {
            moveBar.invalidate()
            gameOverAlert()
            return
        }
        bars.theBar = nextBarField.nextBar
        bars.setBar()
        nextBarField.displayNextBar()
    }

    func setScore(sc: Int) {
        score = score + 10 * sc * (levelMng.currentLevel * 5)
        if levelMng.isLevelUp(score: score) {
            levelLbl.text = levelMng.levelText
            moveBar.invalidate()
            startGame()
        }
        scoreLabel.text = score.description
    }
}
