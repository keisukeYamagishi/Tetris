import UIKit

public struct Cp {
    var px = 0
    var py = 0
}

public struct Bs {
    var bp = 0
    var bc = 0
}

public enum Which: Int {
    case left = 0
    case right = 1
}

@available(iOS 10.0, *)
class Swiris: UIViewController {
    
    public var DPX = 4
    public var DPY = 0
    var brewrisYoko: Int = 10//7
    var brewrisTate: Int = 20//11
    var barSize: CGFloat     = 20
    var score: Int = 0
    var isMove:Bool = false
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nextBarField: UIView!
    @IBOutlet weak var rotstionButton: UIButton!
    var nextB: UIView!
    var cp: Cp = Cp(px: 0, py: 0)
    var firstTap: CGFloat = 0
    @IBOutlet weak var brewView: UIView!
    var bar: UIView!
    var isGameOver: Bool!
    @IBOutlet weak var levelLbl: UILabel!
    var barLists: [[Array<Int>]]!
    var brewTate: [Array<Bs>]!
    var noNeed: [Cp]!
    var theBar: [Array<Int>]!
    var nextTheBar: [Array<Int>]!
    var moveBar: Timer!
    var isBar: Bool = false
    var CBColor: Int!
    var NBColor: Int!
    var isDownBar: Bool!
    var isPopup: Bool!
    var userName: String!
    var level: Int!
    var debug: Int = 0
    var isAd: Bool = false
    
    @IBOutlet weak var brewViewHeightConstraint: NSLayoutConstraint!
    var brewCount: Float = 0.0
    var levelCount: Float = 0.0
    
    var isDown: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = navigationTitle(title: "Swiris")
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
    
    func setGesture(){
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(pushRotation))
        view.addGestureRecognizer(tapGes)
        
        let swipeGes = UISwipeGestureRecognizer(target: self, action: #selector(downBar))
        swipeGes.direction = .down
        view.addGestureRecognizer(swipeGes)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        barLists = BarLists
        barInit()
        nextBarInit()
        startBrew()
    }
    
    @IBAction func pushInBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pushRotation(_ sender: Any) {
        tapRotation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        firstTap = touch!.location(in: view).x
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let newDx = touch?.location(in: view).x
        let move = firstTap - newDx!
        if -11 > move {
            if move.truncatingRemainder(dividingBy: 2) == 0 {
                swipeRight()
            }
        }else if 11 < move {
            if move.truncatingRemainder(dividingBy: 2) == 0 {
                swipeLeft()
            }
        }
    }

    @IBAction func left(_ sender: Any) {
        swipeLeft()
    }
    
    @IBAction func right(_ sender: Any) {
        swipeRight()
    }

    func swipeLeft() {
        if noNeed != nil {
            if isBarMove(which: .left,
                              noNd: noNeed) != true {
                if isMoveJusgemnet(which: .left,
                                        noNd: noNeed) != true {
                    if isBar == false {
                        let cCp: [Cp] = noNeed
                        removeCurrent(cCp: cCp)
                        cp.px -= 1
                        moveBar.invalidate()
                        moveBrewControl(bar: theBar);
                        barDisplay()
                        startEngine()
                    }
                }
            }
        }
    }
    
    func swipeRight () {
        if noNeed != nil {
            if isBarMove(which: .right,
                              noNd: noNeed) != true {
                if isMoveJusgemnet(which: .right,
                                        noNd: noNeed) != true {
                    if isBar == false {
                        let cCp: [Cp] = noNeed
                        removeCurrent(cCp: cCp)
                        cp.px += 1
                        moveBrewControl(bar: theBar);
                        barDisplay()
                    }
                }
            }
        }
    }
    
    func isBarMove (which: Which, noNd: [Cp]) -> Bool {
        
        for cpVal in noNd {
            
            if which == .left {
                if (cpVal.px) <= 0 {
                    return true
                }
            }else if which == .right {
                if (cpVal.px) >= (brewrisYoko - 1) {
                    return true
                }
            }
        }
        return false
    }
    
    func isMoveJusgemnet ( which: Which, noNd: [Cp] ) -> Bool {
        
        for current in 0..<noNeed.count {
            
            let cPosition: Cp = noNd[current]
            
            let bar: [Bs] = brewTate[cPosition.py]
            
            if which == .left {
                if bar[cPosition.px-1].bp == 2 {
                    return true
                }
            }else if which == .right {
                if bar[cPosition.px+1].bp == 2 {
                    return true
                }
            }
        }
        return false
    }
    
    @objc func downGes(){
        downBar()
    }
    
    @objc func downBar(){
        
        if isDownBar == false
        && isPopup == false
        && noNeed != nil {
            isDownBar = true
            var isBottom = false
            var count = 1
            let cCp: [Cp] = noNeed
            
            removeCurrent(cCp: cCp)
            
            while count < (brewTate.count - 1) {
                
                for current in (0..<noNeed.count).reversed() {
                    
                    let cPosition: Cp = noNeed[current]
                    
                    let judge = cPosition.py + count
                    
                    if judge >= brewrisTate {
                        break
                    }
                    
                    let bar: [Bs] = brewTate[cPosition.py + count]
                    
                    if bar[cPosition.px].bp == 2 {
                        
                        isBottom = true
                        
                        cp.py = (count - 1) + cPosition.py
                        
                        for nd in 0..<noNeed.count {
                            
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
                            var tate:[Bs] = brewTate[n.py]
                            tate[n.px].bp = 1
                            brewTate[n.py] = tate
                            
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
                for tate in 0..<theBar.count {
                    
                    let baryoko: [Int] = theBar[tate]
                    
                    for yoko in 0..<baryoko.count {
                        
                        if baryoko[yoko] == 1 {
                            
                            var brew: [Bs] = brewTate[cp.py+(tate)]
                            brew[(yoko)+cp.px].bp = 1
                            brewTate[cp.py+(tate)] = brew
                        }
                    }
                }
            }
            theBar = []
            
            brewTate = storeBar(store: brewTate)
            
            var tag: Int
            
            tag = 1
            
            for tate in 0..<brewrisTate {
                
                let isBar: [Bs] = brewTate[tate]
                
                for yoko in 0..<brewrisYoko {
                    
                    if isBar[yoko].bp == 2 {
                        Brew(tag: tag, bColor: isBar[yoko].bc)
                        
                    }else {
                        noBrew(tag: tag)
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
            brewTate = storeBar(store: brewTate)
            isInAgreement()
            isDownBar = false
        }
    }
    
    func removeCurrent (cCp: [Cp]) {
        
        for ccp in cCp {
            
            var br = brewTate[ccp.py]
            
            br[ccp.px].bp = 0
            br[ccp.px].bc = 0
            brewTate[ccp.py] = br
            
        }
    }
    
    @objc func tapRotation(){
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
    func rotation (bars: [Array<Int>]) {
        
        let rotations = BarController.rotation(bars: bars)
        
        if fixPosition(bar: rotations) == true {
            return
        }
        let cCp: [Cp] = noNeed
        removeCurrent(cCp: cCp)
        theBar = rotations
        moveBrewControl(bar: theBar);
        barDisplay()
    }
    
    func fixPosition(bar: [Array<Int>]) -> Bool {
        
        if cp.px <= 0 {
            cp.px = 0
            //return true
        }
        
        if cp.px >= (brewrisYoko - 3){
            cp.px = (brewrisYoko - 3) - 1
            //return true
        }
        
        for tate in 0..<bar.count {
            
            let baryoko: [Int] = bar[tate]
            
            for yoko in 0..<baryoko.count {
                
                if baryoko[yoko] == 1 {
                    
                    let brew: [Bs] = brewTate[cp.py+(tate)]
                    let isRot = brew[cp.px+yoko]
                    
                    if isRot.bp == 2 {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func startBrew (){
        level = 1
        levelLbl.text = levelManager().levelLabel(lv: level)
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
    
    func getTheBar() -> [Array<Int>] {
        
        let random:Int = Int(arc4random_uniform(UInt32(barLists.count)))
        
        return barLists[random]
    }
    
    func startGame(){
        if level > 12 {
            level = 12
        }
        levelCount = Float(levelManager.levels[level-1])!
        startEngine()
    }
    
    func startEngine(){
        moveBar = Timer.scheduledTimer(timeInterval: TimeInterval(levelCount/10),
                                            target: self,
                                            selector: #selector(Swiris.brewrisEngine),
                                            userInfo: nil, repeats: true)
    }
    
    @objc func brewrisEngine() {
        
        brewCount += 0.1
        
        if brewCount >= levelCount {
            brewCount = 0
            moveBarBrew()
        }
    }
    
    /*
     * Nothing Bar Brew (*_*;) 🍺
     *
     */
    func brewBar (x: CGFloat, y: CGFloat) -> UIView {
        
        let brew: UIView = UIView(frame: CGRect(x: x,
                                                y: y,
                                                width: CGFloat(barSize),//Brewris.barSize),
                                                height: CGFloat(barSize)))//Brewris.barSize)))
        brew.backgroundColor = UIColor.white
        brew.clipsToBounds = true
        brew.layer.borderColor = BorderColor.cgColor
        brew.layer.borderWidth = 1.0
        return brew
    }
    
    func noBrew(tag: Int) {
        bar = brewView.viewWithTag(tag)
        bar.backgroundColor = UIColor.white
        bar.layer.borderColor = BorderColor.cgColor
        bar.layer.borderWidth = 1.0
    }
    
    func Brew(tag: Int, bColor: Int){
        bar = brewView.viewWithTag(tag)
        bar.backgroundColor = Color.colorList(cNum: bColor)
        bar.layer.borderColor = UIColor.white.cgColor
        bar.layer.borderWidth = 1.0
    }
    
    func nextBrewBar(tag: Int, bColor: Int) {
        nextB = nextBarField.viewWithTag(tag)
        nextB.backgroundColor = Color.colorList(cNum: bColor)
        nextB.layer.borderColor = BorderColor.cgColor
        nextB.layer.borderWidth = 1.0
    }
    
    func nextBrewNoBar (tag: Int) {
        nextB = nextBarField.viewWithTag(tag)
        nextB.backgroundColor = UIColor.white
        nextB.layer.borderColor = BorderColor.cgColor
        nextB.layer.borderWidth = 1.0
    }
    
    func barSizeCalculation() -> CGFloat {
        return brewView.frame.size.width / CGFloat(brewrisYoko)
    }

    func swirisFieldHeight(barSize: CGFloat) -> CGFloat {
        return barSize * CGFloat(brewrisTate)
    }

    func barInit(){
        
        var tag = 1
        barSize = barSizeCalculation()
        brewViewHeightConstraint.constant = swirisFieldHeight(barSize: barSize)
        for tate in 0..<brewrisTate {
            
            for yoko in 0..<brewrisYoko {
                
                bar = brewBar(x: CGFloat(yoko) * barSize,
                                        y: CGFloat(tate) * barSize)
                bar.tag = tag
                brewView.addSubview(bar)
                tag += 1
            }
        }
    }
    
    func nextBarInit(){
        var tag = 1
        
        for tate in 0..<4 {
            
            for yoko in 0..<4 {
                
                nextB = nextBrew(x: CGFloat(yoko) * (74 / 4),
                                           y: CGFloat(tate) * (74 / 4))
                nextB.tag = tag
                nextBarField.addSubview(nextB)
                tag += 1
            }
        }
    }
    
    func nextBarInitialize(){
        
        var viewTag = 1;
        
        for _ in 0..<4 {
            
            for _ in 0..<4 {
                nextBrewNoBar(tag: viewTag)
                viewTag += 1
            }
        }
    }
    
    func displayNextBar(){
        
        var ViewTag: Int
        
        ViewTag = 1
        
        nextTheBar = getTheBar()
        NBColor    = Color.ColorNum()//BarColor()
        for tate in 0..<4 {
            
            let nb = nextTheBar[tate]
            
            for yoko in 0..<4{
        
                if nb[yoko] == 1 {
                    
                    nextBrewBar(tag: ViewTag, bColor: NBColor)
                    
                }else{
                    nextBrewNoBar(tag: ViewTag)
                }
                ViewTag += 1
            }
        }
        
    }
    
    func nextBrew (x: CGFloat, y: CGFloat) -> UIView {
        let brew: UIView = UIView(frame: CGRect(x: x,
                                                y: y,
                                                width: CGFloat(18.5),
                                                height: CGFloat(18.5)))
        brew.backgroundColor = UIColor.white
        brew.clipsToBounds = true
        brew.layer.borderColor = BorderColor.cgColor
        brew.layer.borderWidth = 1.0
        return brew
    }
    
    func setNextBar(){
        theBar = nextTheBar
        isGameOver = GameOver(bar: theBar)
        CBColor = NBColor
        displayNextBar()
    }
    
    func brewrisInit(){
        
        brewTate = Array()
        for _ in 0..<brewrisTate {
            
            let brewYoko = brewYokoInit()
            
            brewTate.append(brewYoko)
        }
    }
    
    func brewYokoInit() -> [Bs] {
        
        var yoko: [Bs] = Array()
        
        for _ in 0..<brewrisYoko {
            var bs = Bs()
            bs.bp = 0
            bs.bc = 0
            yoko.append(bs)
        }
        return yoko
    }
    
    func GameOver(bar: [Array<Int>] ) -> Bool{
        
        for tate in (0..<bar.count).reversed() {

            let baryoko: [Int] = bar[tate]

            for yoko in 0..<baryoko.count {

                if baryoko[yoko] == 1 {

                    let brew: [Bs] = brewTate[cp.py+(tate)]
                    if brew[(yoko)+cp.px].bp != 0 {
                        print ("GAME OVER")
                        return true
                    }
                }
            }
        }
        return false
    }
    
    
    func gameOverAlert() {
        let alert: UIAlertController = UIAlertController(title: "GAME OVER", message: "", preferredStyle:  .alert)

        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{[weak self]
            (action: UIAlertAction!) -> Void in
            self?.startBrew()
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{[weak self]
            (action: UIAlertAction!) -> Void in
            print("Cancel")
            self?.startBrew()
        })
        
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    @objc func moveBarBrew(){
//        BarLog(bar: theBar)
        if isBar == false {
            if isMove == false {
                isMove = true
                moveBrewControl(bar: theBar)
                BarLog(bar: brewTate)
                barDisplay()
                if isGameOver == true {
                    moveBar.invalidate()
                    gameOverAlert()
                }
            }
        }
        
        if isBottom(needs: noNeed) == true
            ||  isBar == true {
            
            noNeed = Array()
            isBar = false
            cp.px = DPX
            cp.py = DPY
            setNextBar()
            brewTate = storeBar(store: brewTate)
            isGameOver = GameOver(bar: theBar)
            isInAgreement()
            isDownBar = false
            
        }else{
            
            isBar = judgementBrew()
            if isBar == false {
                noNeedEmurate()
                isMove = false
                isDown = true
                cp.py += 1
            }
        }
    }
    
    func BarInitialze(){
        var ViewTag: Int
        
        ViewTag = 1
        
        for _ in 0..<brewrisTate {
            
            for _ in 0..<brewrisYoko {
                noBrew(tag: ViewTag)
                ViewTag += 1
            }
        }
    }
    
    func barDisplay(){
        
        var tag: Int = 1
        
        for tate in 0..<brewrisTate {
            
            let isBar: [Bs] = brewTate[tate]
            
            for yoko in 0..<brewrisYoko {
                
                if isBar[yoko].bp == 1 {
                    Brew(tag: tag, bColor: isBar[yoko].bc)

                }else if isBar[yoko].bp != 2{
                    noBrew(tag: tag)
                }
                tag += 1
            }
        }
    }
    
    func storeBar (store: [Array<Bs>]) -> [Array<Bs>] {
        
        var stores = store
        
        for tate in 0..<stores.count {
            
            var yokos: [Bs] = stores[tate]
            
            for yoko in 0..<yokos.count {
                
                if yokos[yoko].bp == 1 {
                    
                    yokos[yoko].bp = 2
                    yokos[yoko].bc = CBColor
                    stores[tate] = yokos
                    
                }
            }
        }
        return stores
    }
    
    func noNeedEmurate(){
        
        for yoko in 0..<brewTate.count {
            
            var tate: [Bs] = brewTate[yoko]
            
            for brew in 0..<tate.count {
                if tate[brew].bp == 1 {
                    tate[brew].bp = 0
                }
            }
            brewTate[yoko] = tate
        }
    }
    
    func judgementBrew() -> Bool {
        
        for current in (0..<noNeed.count).reversed() {
            
            let cPosition: Cp = noNeed[current]
            
            let bar: [Bs] = brewTate[cPosition.py+1]
            
            if bar[cPosition.px].bp == 2 {
                return true
            }
        }
        return false // isBar
    }
    
    func isBottom(needs: [Cp]) -> Bool {
        
        let bottom = brewrisTate - 1
        
        for current in needs {
            
            if bottom <= current.py {
                return true
            }
        }
        return false
    }
    
    func moveBrewControl(bar: [Array<Any>]){
        
        var noNeedCo: Int = 0
        var storeNoNeed: [Cp] = Array()//setNoNeed()
        
        for tate in 0..<bar.count {
            
            let baryoko: [Int] = bar[tate] as! [Int]
            
            for yoko in 0..<baryoko.count {
                
                if baryoko[yoko] == 1 {
                    
                    var brew: [Bs] = brewTate[cp.py+(tate)]
                    brew[(yoko)+cp.px].bp = 1
                    brew[(yoko)+cp.px].bc = CBColor
                    brewTate[cp.py+(tate)] = brew
                    
                    storeNoNeed.append( Cp(px:(cp.px+yoko) , py:(cp.py+tate)))
                    noNeedCo += 1
                }
            }
        }
        noNeed = storeNoNeed
    }
    
    func isInAgreement() {
        
        var removeLists: [Int] = []
        
        for be in 0..<brewTate.count {
            
            let agreemnent: [Bs] = brewTate[be]
            var isRemove: Bool = false
            
            for agr in agreemnent {
                
                if(agr.bp == 0){
                    isRemove = true
                }
                
            }
            if isRemove != true {
                removeLists.append(be)
            }
        }
        
        var isRm = false
        
        for rm in removeLists {
            
            brewTate.remove(at: rm)
            
            brewTate.insert(brewYokoInit(), at: rm)
            
            isRm = true
            
        }
        
        if isRm == true {
            isRm = false
            
            for rm in removeLists {
                brewTate.remove(at: rm)
                brewTate.insert(brewYokoInit(), at: 0)
            }
            
            var ViewTag: Int
            ViewTag = 1
            
            for tate in 0..<brewrisTate {
                
                let Bar: [Bs] = brewTate[tate]
                
                for yoko in 0..<brewrisYoko {
                    
                    if Bar[yoko].bp == 2 {
                        Brew(tag: ViewTag, bColor: Bar[yoko].bc)
                    }
                    ViewTag += 1
                }
            }
            setScore(sc: removeLists.count)
        }
        brewTate = storeBar(store: brewTate)
    }
    
    func setScore(sc: Int){
        
        score = score + 10 * sc * ((level) * 5)
        
        let lv = levelManager()
        
        level = lv.islevelUp(score: score)
        
        if lv.isLvUp == true {
            lv.isLvUp = false
            levelLbl.text = lv.levelLabel(lv: level)
            moveBar.invalidate()
            startGame()
        }
        scoreLabel.text = score.description
    }
}
