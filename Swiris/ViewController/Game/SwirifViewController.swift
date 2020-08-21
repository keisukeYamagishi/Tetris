import UIKit

public struct Cp {
    var px = 0
    var py = 0
}

public enum Which: Int {
    case left = 0
    case right = 1
}

@available(iOS 10.0, *)
class Swiris: UIViewController {
    public var DPX = 4
    public var DPY = 0
    var barSize: CGFloat = 20
    var score: Int = 0
    var isMove: Bool = false
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var nextBarField: UIView!
    @IBOutlet var rotstionButton: UIButton!
    var nextB: Bar!
    var cp: Cp = Cp(px: 0, py: 0)
    var firstTap: CGFloat = 0
    @IBOutlet var brewView: UIView!
    var bar: UIView!
    var isGameOver: Bool!
    @IBOutlet var levelLbl: UILabel!
    var barsHairetu: [[Bs]]!
    var noNeed: [Cp]!
    var theBar: [[Int]]!
    var nextTheBar: [[Int]]!
    var moveBar: Timer!
    var isBar: Bool = false
    var CBColor: Int!
    var NBColor: Int!
    var isDownBar: Bool!
    var isPopup: Bool!
    var userName: String!
    var levelMng: LevelManager!
    var debug: Int = 0
    var isAd: Bool = false
    var bars: Bars! = Bars()

    @IBOutlet var brewViewHeightConstraint: NSLayoutConstraint!
    var brewCount: Float = 0.0

    var isDown: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = navigationTitle(title: "Swiris")
        levelMng = LevelManager()
        setGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.text = "0"
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
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
        nextBarInit()
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
        if noNeed != nil {
            if isBarMove(which: .left,
                         noNd: noNeed) != true
            {
                if isMoveJusgemnet(which: .left,
                                   noNd: noNeed) != true
                {
                    if isBar == false {
                        let cCp: [Cp] = noNeed
                        removeCurrent(cCp: cCp)
                        cp.px -= 1
                        moveBar.invalidate()
                        moveBrewControl(bar: theBar)
                        barDisplay()
                        startEngine()
                    }
                }
            }
        }
    }

    func swipeRight() {
        if noNeed != nil {
            if isBarMove(which: .right,
                         noNd: noNeed) != true
            {
                if isMoveJusgemnet(which: .right,
                                   noNd: noNeed) != true
                {
                    if isBar == false {
                        let cCp: [Cp] = noNeed
                        removeCurrent(cCp: cCp)
                        cp.px += 1
                        moveBrewControl(bar: theBar)
                        barDisplay()
                    }
                }
            }
        }
    }

    func isBarMove(which: Which, noNd: [Cp]) -> Bool {
        for cpVal in noNd {
            if which == .left {
                if cpVal.px <= 0 {
                    return true
                }
            } else if which == .right {
                if cpVal.px >= (Yoko - 1) {
                    return true
                }
            }
        }
        return false
    }

    func isMoveJusgemnet(which: Which, noNd: [Cp]) -> Bool {
        for current in 0 ..< noNeed.count {
            let cPosition: Cp = noNd[current]

            let bar: [Bs] = barsHairetu[cPosition.py]

            if which == .left {
                if bar[cPosition.px - 1].bp == 2 {
                    return true
                }
            } else if which == .right {
                if bar[cPosition.px + 1].bp == 2 {
                    return true
                }
            }
        }
        return false
    }

    @objc func downGes() {
        downBar()
    }

    @objc func downBar() {
        if isDownBar == false,
            isPopup == false,
            noNeed != nil
        {
            isDownBar = true
            var isBottom = false
            var count = 1
            let cCp: [Cp] = noNeed

            removeCurrent(cCp: cCp)

            while count < (barsHairetu.count - 1) {
                for current in (0 ..< noNeed.count).reversed() {
                    let cPosition: Cp = noNeed[current]

                    let judge = cPosition.py + count

                    if judge >= Tate {
                        break
                    }

                    let bar: [Bs] = barsHairetu[cPosition.py + count]

                    if bar[cPosition.px].bp == 2 {
                        isBottom = true

                        cp.py = (count - 1) + cPosition.py

                        for nd in 0 ..< noNeed.count {
                            var n = noNeed[nd]
                            cp.py = (count - 1) + n.py

                            if cp.py == 1 {
                                if isPopup == false {
                                    isPopup = true
                                    moveBar.invalidate()
                                    gameOverAlert()
                                    return
                                }
                            }

                            n.py = cp.py
                            var tate: [Bs] = barsHairetu[n.py]
                            tate[n.px].bp = 1
                            barsHairetu[n.py] = tate
                        }
                        break
                    }
                }
                if isBottom == true {
                    break
                }
                count += 1
            }

            if isBottom == false {
                cp.py = count - 3
                for tate in 0 ..< theBar.count {
                    let baryoko: [Int] = theBar[tate]

                    for yoko in 0 ..< baryoko.count {
                        if baryoko[yoko] == 1 {
                            var brew: [Bs] = barsHairetu[cp.py + tate]
                            brew[yoko + cp.px].bp = 1
                            barsHairetu[cp.py + tate] = brew
                        }
                    }
                }
            }
            theBar = []

            barsHairetu = storeBar(store: barsHairetu)

            var tag: Int

            tag = 1

            for tate in 0 ..< Tate {
                let isBar: [Bs] = barsHairetu[tate]

                for yoko in 0 ..< Yoko {
                    if isBar[yoko].bp == 2 {
                        let bar = brewView.viewWithTag(tag) as! Bar
                        bar.brew(isBar[yoko].bc)
                    } else {
                        let bar = brewView.viewWithTag(tag) as! Bar
                        bar.noBrew()
                    }
                    tag += 1
                }
            }
            isBar = false
            cp.px = DPX
            cp.py = DPY
            setNextBar()
            if isGameOver == true {
                isPopup = true
                moveBar.invalidate()
                gameOverAlert()
                return
            }
            barsHairetu = storeBar(store: barsHairetu)
            isInAgreement()
            isDownBar = false
        }
    }

    func removeCurrent(cCp: [Cp]) {
        for ccp in cCp {
            var br = barsHairetu[ccp.py]

            br[ccp.px].bp = 0
            br[ccp.px].bc = 0
            barsHairetu[ccp.py] = br
        }
    }

    @objc func tapRotation() {
        if noNeed != nil {
            rotation(bars: theBar)
        }
    }

    /*
     [[0,0,0,0],   [[0,0,0,0],
     [0,1,1,0],    [0,0,0,0],
     [0,0,1,0], -> [1,1,1,0],
     [0,0,1,0]]    [1,0,0,0]]
     */
    func rotation(bars: [[Int]]) {
        let rotations = BarController.rotation(bars: bars)

        if fixPosition(bar: rotations) == true {
            return
        }
        let cCp: [Cp] = noNeed
        removeCurrent(cCp: cCp)
        theBar = rotations
        moveBrewControl(bar: theBar)
        barDisplay()
    }

    func fixPosition(bar: [[Int]]) -> Bool {
        if cp.px <= 0 {
            cp.px = 0
            // return true
        }

        if cp.px >= (Yoko - 3) {
            cp.px = (Yoko - 3) - 1
            // return true
        }

        for tate in 0 ..< bar.count {
            let baryoko: [Int] = bar[tate]

            for yoko in 0 ..< baryoko.count {
                if baryoko[yoko] == 1 {
                    let brew: [Bs] = barsHairetu[cp.py + tate]
                    let isRot = brew[cp.px + yoko]

                    if isRot.bp == 2 {
                        return true
                    }
                }
            }
        }
        return false
    }

    func startBrew() {
        levelLbl.text = levelMng.levelText
        scoreLabel.text = "0"
        score = 0
        isPopup = false
        nextTheBar = nil
        theBar = nil
        isDownBar = false
        isBar = false
        isMove = false
        isGameOver = false
        brewrisInit()
        BarInitialze()
        nextBarInitialize()
        displayNextBar()
        cp.px = DPX
        cp.py = DPY
        CBColor = Color.ColorNum()
        theBar = getTheBar()
        startGame()
    }

    func getTheBar() -> [[Int]] {
        let random: Int = Int(arc4random_uniform(UInt32(BarLists.count)))

        return BarLists[random]
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

    func nextBarInit() {
        var tag = 1

        for tate in 0 ..< 4 {
            for yoko in 0 ..< 4 {
                nextB = Bar(frame: CGRect(origin: CGPoint(x: CGFloat(yoko) * (74 / 4),
                                                          y: CGFloat(tate) * (74 / 4)),
                                          size: CGSize(width: CGFloat(18.5),
                                                       height: CGFloat(18.5))), tag: tag)
                nextBarField.addSubview(nextB)
                tag += 1
            }
        }
    }

    func nextBarInitialize() {
        var tag = 1
        for _ in 0 ..< 4 {
            for _ in 0 ..< 4 {
                let bar = nextBarField.viewWithTag(tag) as! Bar
                bar.noBrew()
                tag += 1
            }
        }
    }

    func displayNextBar() {
        var tag: Int = 1
        nextTheBar = getTheBar()
        NBColor = Color.ColorNum() // BarColor()
        for tate in 0 ..< 4 {
            let nb = nextTheBar[tate]

            for yoko in 0 ..< 4 {
                if nb[yoko] == 1 {
                    let bar = nextBarField.viewWithTag(tag) as! Bar
                    bar.brew(NBColor)
                } else {
                    let bar = nextBarField.viewWithTag(tag) as! Bar
                    bar.noBrew()
                }
                tag += 1
            }
        }
    }

    func setNextBar() {
        theBar = nextTheBar
        isGameOver = GameOver(bar: theBar)
        CBColor = NBColor
        displayNextBar()
    }

    func brewrisInit() {
        barsHairetu = Array()
        for _ in 0 ..< Tate {
            let brewYoko = brewYokoInit()
            barsHairetu.append(brewYoko)
        }
    }

    func brewYokoInit() -> [Bs] {
        var yoko: [Bs] = Array()

        for _ in 0 ..< Yoko {
            var bs = Bs()
            bs.bp = 0
            bs.bc = 0
            yoko.append(bs)
        }
        return yoko
    }

    func GameOver(bar: [[Int]]) -> Bool {
        for tate in (0 ..< bar.count).reversed() {
            let baryoko: [Int] = bar[tate]

            for yoko in 0 ..< baryoko.count {
                if baryoko[yoko] == 1 {
                    let brew: [Bs] = barsHairetu[cp.py + tate]
                    if brew[yoko + cp.px].bp != 0 {
                        print("GAME OVER")
                        return true
                    }
                }
            }
        }
        return false
    }

    func gameOverAlert() {
        let alert: UIAlertController = UIAlertController(title: "GAME OVER", message: "", preferredStyle: .alert)

        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self]
            (_: UIAlertAction!) -> Void in
            self?.startBrew()
        })

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self]
            (_: UIAlertAction!) -> Void in
            print("Cancel")
            self?.startBrew()
        })

        alert.addAction(defaultAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    @objc func moveBarBrew() {
//        BarLog(bar: theBar)
        if isBar == false {
            if isMove == false {
                isMove = true
                moveBrewControl(bar: theBar)
                BarLog(bar: barsHairetu)
                barDisplay()
                if isGameOver == true {
                    moveBar.invalidate()
                    gameOverAlert()
                }
            }
        }

        if isBottom(needs: noNeed) == true
            || isBar == true
        {
            noNeed = Array()
            isBar = false
            cp.px = DPX
            cp.py = DPY
            setNextBar()
            barsHairetu = storeBar(store: barsHairetu)
            isGameOver = GameOver(bar: theBar)
            isInAgreement()
            isDownBar = false

        } else {
            isBar = judgementBrew()
            if isBar == false {
                noNeedEmurate()
                isMove = false
                isDown = true
                cp.py += 1
            }
        }
    }

    func BarInitialze() {
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
            let isBar: [Bs] = barsHairetu[tate]

            for yoko in 0 ..< Yoko {
                if isBar[yoko].bp == 1 {
                    let bar = brewView.viewWithTag(tag) as! Bar
                    bar.brew(isBar[yoko].bc)

                } else if isBar[yoko].bp != 2 {
                    let bar: Bar = brewView.viewWithTag(tag) as! Bar
                    bar.noBrew()
                }
                tag += 1
            }
        }
    }

    func storeBar(store: [[Bs]]) -> [[Bs]] {
        var stores = store

        for tate in 0 ..< stores.count {
            var yokos: [Bs] = stores[tate]

            for yoko in 0 ..< yokos.count {
                if yokos[yoko].bp == 1 {
                    yokos[yoko].bp = 2
                    yokos[yoko].bc = CBColor
                    stores[tate] = yokos
                }
            }
        }
        return stores
    }

    func noNeedEmurate() {
        for yoko in 0 ..< barsHairetu.count {
            var tate: [Bs] = barsHairetu[yoko]

            for brew in 0 ..< tate.count {
                if tate[brew].bp == 1 {
                    tate[brew].bp = 0
                }
            }
            barsHairetu[yoko] = tate
        }
    }

    func judgementBrew() -> Bool {
        for current in (0 ..< noNeed.count).reversed() {
            let cPosition: Cp = noNeed[current]

            let bar: [Bs] = barsHairetu[cPosition.py + 1]

            if bar[cPosition.px].bp == 2 {
                return true
            }
        }
        return false // isBar
    }

    func isBottom(needs: [Cp]) -> Bool {
        let bottom = Tate - 1

        for current in needs {
            if bottom <= current.py {
                return true
            }
        }
        return false
    }

    func moveBrewControl(bar: [[Any]]) {
        var noNeedCo: Int = 0
        var storeNoNeed: [Cp] = []

        for tate in 0 ..< bar.count {
            let baryoko: [Int] = bar[tate] as! [Int]

            for yoko in 0 ..< baryoko.count {
                if baryoko[yoko] == 1 {
                    var brew: [Bs] = barsHairetu[cp.py + tate]
                    brew[yoko + cp.px].bp = 1
                    brew[yoko + cp.px].bc = CBColor
                    barsHairetu[cp.py + tate] = brew

                    storeNoNeed.append(Cp(px: cp.px + yoko, py: cp.py + tate))
                    noNeedCo += 1
                }
            }
        }
        noNeed = storeNoNeed
    }

    func isInAgreement() {
        var removeLists: [Int] = []

        for be in 0 ..< barsHairetu.count {
            let agreemnent: [Bs] = barsHairetu[be]
            var isRemove: Bool = false

            for agr in agreemnent {
                if agr.bp == 0 {
                    isRemove = true
                }
            }
            if isRemove != true {
                removeLists.append(be)
            }
        }

        var isRm = false

        for rm in removeLists {
            barsHairetu.remove(at: rm)

            barsHairetu.insert(brewYokoInit(), at: rm)

            isRm = true
        }

        if isRm == true {
            isRm = false

            for rm in removeLists {
                barsHairetu.remove(at: rm)
                barsHairetu.insert(brewYokoInit(), at: 0)
            }

            var tag: Int = 1

            for tate in 0 ..< Tate {
                let Bar: [Bs] = barsHairetu[tate]

                for yoko in 0 ..< Yoko {
                    if Bar[yoko].bp == 2 {
                        let bar = brewView.viewWithTag(tag) as! Bar
                        bar.brew(Bar[yoko].bc)
                    }
                    tag += 1
                }
            }
            setScore(sc: removeLists.count)
        }
        barsHairetu = storeBar(store: barsHairetu)
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
