import UIKit

@available(iOS 10.0, *)
final class Swiris: UIViewController {
    var barSize: CGFloat = 20
    var score: Int = 0
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var nextBarField: NextBarField!
    @IBOutlet var rotstionButton: UIButton!
    var firstTap: CGFloat = 0
    @IBOutlet var brewView: UIView!
    @IBOutlet var levelLbl: UILabel!
    var theBar: [[Int]]!
    var nextTheBar: [[Int]]!
    var moveBar: Timer!
    var CBColor: Int!
    var levelMng: LevelManager!
    var bars: Bars! = Bars()

    @IBOutlet var brewViewHeightConstraint: NSLayoutConstraint!
    var brewCount: Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = navigationTitle(title: "Swiris")
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
        if bars.isSwipe(which: .left) {
            if !bars.judgementBrew() {
                let cCp: [Cp] = bars.noneed
                bars.removeCurrent(cCp: cCp)
                bars.cp.px -= 1
                moveBar.invalidate()
                bars.move(bar: theBar, cColor: CBColor)
                barDisplay()
                startEngine()
            }
        }
    }

    func swipeRight() {
        if bars.isSwipe(which: .right) {
            if !bars.judgementBrew() {
                let cCp: [Cp] = bars.noneed
                bars.removeCurrent(cCp: cCp)
                bars.cp.px += 1
                bars.move(bar: theBar, cColor: CBColor)
                barDisplay()
            }
        }
    }

    @objc func downGes() {
        downBar()
    }

    @objc func downBar() {
        bars.down(bar: theBar) {
            moveBar.invalidate()
            gameOverAlert()
        }
        theBar = []
        bars.store(cbColor: CBColor)
        storedDisplay()
        bars.cp.px = DPX
        bars.cp.py = DPY
        setNextBar()
        bars.store(cbColor: CBColor)
        if bars.isInAgreement() {
            barDisplay()
            setScore(sc: bars.removeLists.count)
        }
    }

    @objc func tapRotation() {
        rotation(bar: theBar)
    }

    /*
     [[0,0,0,0],   [[0,0,0,0],
     [0,1,1,0],    [0,0,0,0],
     [0,0,1,0], -> [1,1,1,0],
     [0,0,1,0]]    [1,0,0,0]]
     */
    func rotation(bar: [[Int]]) {
        let rotations = bars.spin(bars: bar)

        if bars.fixPosition(bar: rotations) == true {
            return
        }
        let cCp: [Cp] = bars.noneed
        bars.removeCurrent(cCp: cCp)
        theBar = rotations
        bars.move(bar: theBar, cColor: CBColor)
        barDisplay()
    }

    func startBrew() {
        levelLbl.text = levelMng.levelText
        scoreLabel.text = "0"
        score = 0
        nextTheBar = nil
        theBar = nil
        barInitialze()
        nextBarField.initializeField()
        theBar = Bars.getTheBar
        nextBarField.displayNextBar()
        bars = Bars()
        bars.cp.px = DPX
        bars.cp.py = DPY
        CBColor = Color.radomNum()
        theBar = Bars.getTheBar
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
                                       selector: #selector(Swiris.brewrisEngine),
                                       userInfo: nil, repeats: true)
    }

    @objc func brewrisEngine() {
        brewCount += 0.1

        if brewCount >= levelMng.levelCount {
            brewCount = 0
            moveBarBrew()
        }
    }

    func barSizeCalculation() -> CGFloat {
        return brewView.frame.size.width / CGFloat(Yoko)
    }

    func swirisFieldHeight(barSize: CGFloat) -> CGFloat {
        return barSize * CGFloat(Tate)
    }

    func barInit() {
        var tag = 1
        barSize = barSizeCalculation()
        brewViewHeightConstraint.constant = swirisFieldHeight(barSize: barSize)
        for tate in 0 ..< Tate {
            for yoko in 0 ..< Yoko {
                let bar: Bar = Bar(frame: CGRect(x: CGFloat(yoko) * barSize,
                                                 y: CGFloat(tate) * barSize,
                                                 width: CGFloat(barSize),
                                                 height: CGFloat(barSize)), tag: tag)
                brewView.addSubview(bar)
                tag += 1
            }
        }
    }

    func setNextBar() {
        theBar = nextBarField.nextBar
        if bars.isGameOver(bar: theBar) {
            moveBar.invalidate()
            gameOverAlert()
        }
        CBColor = nextBarField.NBColor
        nextBarField.displayNextBar()
    }

    func gameOverAlert() {
        let actions = [AlertAction(title: "Ok", style: .default, handler: { [weak self] _, _ in
            self?.startBrew()
        }), AlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _, _ in
            self?.startBrew()
        })]
        alert(title: "GAME OVER", message: "Out of move", actions: actions)
    }

    @objc func moveBarBrew() {
        if !bars.judgementBrew() {
            bars.move(bar: theBar, cColor: CBColor)
            BarLog(bar: bars.values)
            barDisplay()
        }

        if bars.isBottom
            || bars.judgementBrew()
        {
            bars.initalize()
            setNextBar()
            bars.store(cbColor: CBColor)
            if bars.isInAgreement() {
                barDisplay()
                setScore(sc: bars.removeLists.count)
            }
            bars.store(cbColor: CBColor)

        } else {
            if !bars.judgementBrew() {
                bars.noNeedEmurate()
                bars.cp.py += 1
            }
        }
    }

    func barInitialze() {
        var tag: Int = 1
        for _ in 0 ..< Tate {
            for _ in 0 ..< Yoko {
                let bar: Bar = brewView.viewWithTag(tag) as! Bar
                bar.noBrew()
                tag += 1
            }
        }
    }

    func barDisplay() {
        var tag: Int = 1

        for tate in 0 ..< Tate {
            let isBar: [Bs] = bars.values[tate]

            for yoko in 0 ..< Yoko {
                if isBar[yoko].bp == Bars.Move {
                    let bar = brewView.viewWithTag(tag) as! Bar
                    bar.brew(isBar[yoko].bc)

                } else if isBar[yoko].bp != Bars.Store {
                    let bar: Bar = brewView.viewWithTag(tag) as! Bar
                    bar.noBrew()
                }
                tag += 1
            }
        }
    }

    func storedDisplay() {
        var tag: Int = 1
        for tate in 0 ..< Tate {
            let isBar: [Bs] = bars.values[tate]

            for yoko in 0 ..< Yoko {
                if isBar[yoko].bp == Bars.Store {
                    let bar = brewView.viewWithTag(tag) as! Bar
                    bar.brew(isBar[yoko].bc)
                } else {
                    let bar = brewView.viewWithTag(tag) as! Bar
                    bar.noBrew()
                }
                tag += 1
            }
        }
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
