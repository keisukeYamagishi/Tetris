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
    var barSize: Int     = 20
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
    
    var brewCount: Float = 0.0
    var levelCount: Float = 0.0
    
    var isDown: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.titleView = self.navigationTitle(title: "Swiris")
        self.setGesture()
        barSize = Int(self.view.frame.size.width * 0.0533333333334) + 3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scoreLabel.adjustsFontSizeToFitWidth = true
        self.scoreLabel.text = "0"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
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
        self.barLists = BarLists
        self.barInit()
        self.nextBarInit()
        self.startBrew()
        
    }
    
    @IBAction func pushInBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pushRotation(_ sender: Any) {
        self.tapRotation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        self.firstTap = touch!.location(in: self.view).x
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let newDx = touch?.location(in: self.view).x
        let move = self.firstTap - newDx!
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    @IBAction func left(_ sender: Any) {
        swipeLeft()
    }
    
    @IBAction func right(_ sender: Any) {
        swipeRight()
    }
    
    
    func swipeLeft() {
        if self.noNeed != nil {
            if self.isBarMove(which: .left,
                              noNd: self.noNeed) != true {
                if self.isMoveJusgemnet(which: .left,
                                        noNd: self.noNeed) != true {
                    if self.isBar == false {
                        let cCp: [Cp] = self.noNeed
                        removeCurrent(cCp: cCp)
                        self.cp.px -= 1
                        self.moveBar.invalidate()
                        self.moveBrewControl(bar: self.theBar);
                        self.barDisplay()
                        self.startEngine()
                    }
                }
            }
        }
    }
    
    func swipeRight () {
        if self.noNeed != nil {
            if self.isBarMove(which: .right,
                              noNd: self.noNeed) != true {
                if self.isMoveJusgemnet(which: .right,
                                        noNd: self.noNeed) != true {
                    if self.isBar == false {
                        let cCp: [Cp] = self.noNeed
                        removeCurrent(cCp: cCp)
                        self.cp.px += 1
                        self.moveBrewControl(bar: self.theBar);
                        self.barDisplay()
                    }
                }
            }
        }
    }
    
    func isBarMove (which: Which, noNd: [Cp]) -> Bool {
        
        for cpVal in noNd {
            
            if which.rawValue == Which.left.rawValue {
                if (cpVal.px) <= 0 {
                    return true
                }
            }else if which.rawValue == Which.right.rawValue{
                if (cpVal.px) >= (self.brewrisYoko - 1) {
                    return true
                }
            }
        }
        return false
    }
    
    func isMoveJusgemnet ( which: Which, noNd: [Cp] ) -> Bool {
        
        for current in 0..<noNeed.count {
            
            let cPosition: Cp = noNd[current]
            
            let bar: [Bs] = self.brewTate[cPosition.py]
            
            if which.rawValue == Which.left.rawValue {
                if bar[cPosition.px-1].bp == 2 {
                    return true
                }
            }else if which.rawValue == Which.right.rawValue {
                if bar[cPosition.px+1].bp == 2 {
                    return true
                }
            }
        }
        return false
    }
    
    @objc func downGes(){
        self.downBar()
    }
    
    @objc func downBar(){
        
        if self.isDownBar == false
        && self.isPopup == false
        && self.noNeed != nil {
            self.isDownBar = true
            var isBottom = false
            var count = 1
            let cCp: [Cp] = self.noNeed
            
            removeCurrent(cCp: cCp)
            
            while count < (self.brewTate.count - 1) {
                
                for current in (0..<self.noNeed.count).reversed() {
                    
                    let cPosition: Cp = self.noNeed[current]
                    
                    let judge = cPosition.py + count
                    
                    if judge >= self.brewrisTate {
                        break
                    }
                    
                    let bar: [Bs] = self.brewTate[cPosition.py + count]
                    
                    if bar[cPosition.px].bp == 2 {
                        
                        isBottom = true
                        
                        cp.py = (count - 1) + cPosition.py
                        
                        for nd in 0..<self.noNeed.count {
                            
                            var n = self.noNeed[nd]
                            print (n)
                            cp.py = (count - 1) + n.py
                            
                            if cp.py == 1 {
                                if self.isPopup == false {
                                    print ("\n\nOVER \n\n")
                                    self.isPopup = true
                                    self.moveBar.invalidate()
                                    gameOverAlert()
                                    return
                                }
                            }
                            
                            n.py = cp.py
                            var tate:[Bs] = self.brewTate[n.py]
                            tate[n.px].bp = 1
                            self.brewTate[n.py] = tate
                            
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
                for tate in 0..<self.theBar.count {
                    
                    let baryoko: [Int] = self.theBar[tate]
                    
                    for yoko in 0..<baryoko.count {
                        
                        if baryoko[yoko] == 1 {
                            
                            var brew: [Bs] = self.brewTate[cp.py+(tate)]
                            brew[(yoko)+cp.px].bp = 1
                            self.brewTate[cp.py+(tate)] = brew
                        }
                    }
                }
            }
            theBar = []
            
            self.brewTate = self.storeBar(store: self.brewTate)
            
            var tag: Int
            
            tag = 1
            
            for tate in 0..<self.brewrisTate {
                
                let isBar: [Bs] = self.brewTate[tate]
                
                for yoko in 0..<self.brewrisYoko {
                    
                    if isBar[yoko].bp == 2 {
                        self.Brew(tag: tag, bColor: isBar[yoko].bc)
                        
                    }else {
                        self.noBrew(tag: tag)
                    }
                    tag += 1
                }
            }
            self.isBar = false
            self.cp.px = DPX
            self.cp.py = DPY
            self.setNextBar()
            if self.isGameOver == true {
                self.isPopup = true
                self.moveBar.invalidate()
                gameOverAlert()
                return
            }
            self.brewTate = self.storeBar(store: self.brewTate)
            self.isInAgreement()
            self.isDownBar = false
        }
    }
    
    func removeCurrent (cCp: [Cp]) {
        
        for ccp in cCp {
            
            var br = self.brewTate[ccp.py]
            
            br[ccp.px].bp = 0
            br[ccp.px].bc = 0
            self.brewTate[ccp.py] = br
            
        }
    }
    
    @objc func tapRotation(){
        if self.noNeed != nil {
            self.rotation(bars: self.theBar)
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
        
        if self.fixPosition(bar: rotations) == true {
            return
        }
        let cCp: [Cp] = self.noNeed
        removeCurrent(cCp: cCp)
        self.theBar = rotations
        self.moveBrewControl(bar: self.theBar);
        self.barDisplay()
    }
    
    func fixPosition(bar: [Array<Int>]) -> Bool {
        
        if cp.px <= 0 {
            cp.px = 0
            //return true
        }
        
        if cp.px >= (self.brewrisYoko - 3){
            cp.px = (self.brewrisYoko - 3) - 1
            //return true
        }
        
        for tate in 0..<bar.count {
            
            let baryoko: [Int] = bar[tate]
            
            for yoko in 0..<baryoko.count {
                
                if baryoko[yoko] == 1 {
                    
                    let brew: [Bs] = self.brewTate[cp.py+(tate)]
                    let isRot = brew[cp.px+yoko]
                    
                    if isRot.bp == 2 {
                        
                        print( "HIT")
                        
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func startBrew (){
        self.level = 1
        self.levelLbl.text = levelManager().levelLabel(lv: self.level)
        self.scoreLabel.text = "0"
        self.score = 0
        self.isPopup = false
        self.nextTheBar = nil
        self.theBar = nil
        self.isDownBar = false
        self.isBar = false
        self.isMove = false
        self.isGameOver = false
        self.brewrisInit()
        self.BarInitialze()
        self.nextBarInitialize()
        self.displayNextBar()
        self.cp.px = DPX
        self.cp.py = DPY
        self.CBColor = Color.ColorNum()
        self.theBar = self.getTheBar()
        self.startGame()
    }
    
    func getTheBar() -> [Array<Int>] {
        
        let random:Int = Int(arc4random_uniform(UInt32(self.barLists.count)))
        
        return self.barLists[random]
    }
    
    func startGame(){
        if self.level > 12 {
            self.level = 12
        }
        self.levelCount = Float(levelManager.levels[self.level-1])!
        self.startEngine()
    }
    
    func startEngine(){
        self.moveBar = Timer.scheduledTimer(timeInterval: TimeInterval(self.levelCount/10),
                                            target: self,
                                            selector: #selector(Swiris.brewrisEngine),
                                            userInfo: nil, repeats: true)
    }
    
    @objc func brewrisEngine() {
        
        self.brewCount += 0.1
        
        if self.brewCount >= self.levelCount {
            self.brewCount = 0
            self.moveBarBrew()
        }
    }
    
    /*
     * Nothing Bar Brew (*_*;) 🍺
     *
     */
    func brewBar (x: CGFloat, y: CGFloat) -> UIView {
        
        let brew: UIView = UIView(frame: CGRect(x: x,
                                                y: y,
                                                width: CGFloat(self.barSize),//Brewris.barSize),
                                                height: CGFloat(self.barSize)))//Brewris.barSize)))
        brew.backgroundColor = UIColor.white
        brew.clipsToBounds = true
        brew.layer.borderColor = BorderColor.cgColor
        brew.layer.borderWidth = 1.0
        return brew
    }
    
    func noBrew(tag: Int) {
        self.bar = self.brewView.viewWithTag(tag)
        self.bar.backgroundColor = UIColor.white
        self.bar.layer.borderColor = BorderColor.cgColor
        self.bar.layer.borderWidth = 1.0
    }
    
    func Brew(tag: Int, bColor: Int){
        self.bar = self.brewView.viewWithTag(tag)
        self.bar.backgroundColor = Color.colorList(cNum: bColor)
        self.bar.layer.borderColor = UIColor.white.cgColor
        self.bar.layer.borderWidth = 1.0
    }
    
    func nextBrewBar(tag: Int, bColor: Int) {
        self.nextB = self.nextBarField.viewWithTag(tag)
        self.nextB.backgroundColor = Color.colorList(cNum: bColor)
        self.nextB.layer.borderColor = BorderColor.cgColor
        self.nextB.layer.borderWidth = 1.0
    }
    
    func nextBrewNoBar (tag: Int) {
        self.nextB = self.nextBarField.viewWithTag(tag)
        self.nextB.backgroundColor = UIColor.white
        self.nextB.layer.borderColor = BorderColor.cgColor
        self.nextB.layer.borderWidth = 1.0
    }
    
    func barInit(){
        
        var viewTag = 1;
        for tate in 0..<self.brewrisTate {
            
            for yoko in 0..<self.brewrisYoko {
                
                self.bar = self.brewBar(x: (CGFloat(yoko * self.barSize)),
                                        y: (CGFloat(tate * self.barSize)))
                self.bar.tag = viewTag
                self.brewView.addSubview(self.bar)
                viewTag += 1
            }
        }
    }
    
    func nextBarInit(){
        var viewTag = 1;
        for tate in 0..<4 {
            
            for yoko in 0..<4 {
                
                self.nextB = self.nextBrew(x: (CGFloat(yoko * self.barSize/*Brewris.barSize*/)),
                                           y: (CGFloat(tate * self.barSize/*Brewris.barSize*/)))
                self.nextB.tag = viewTag
                self.nextBarField.addSubview(self.nextB)
                viewTag += 1
            }
        }
    }
    
    func nextBarInitialize(){
        
        var viewTag = 1;
        
        for _ in 0..<4 {
            
            for _ in 0..<4 {
                self.nextBrewNoBar(tag: viewTag)
                viewTag += 1
            }
        }
    }
    
    func displayNextBar(){
        
        var ViewTag: Int
        
        ViewTag = 1
        
        self.nextTheBar = self.getTheBar()
        self.NBColor    = Color.ColorNum()//BarColor()
        for tate in 0..<4 {
            
            let nb = self.nextTheBar[tate]
            
            for yoko in 0..<4{
        
                if nb[yoko] == 1 {
                    
                    self.nextBrewBar(tag: ViewTag, bColor: self.NBColor)
                    
                }else{
                    self.nextBrewNoBar(tag: ViewTag)
                }
                ViewTag += 1
            }
        }
        
    }
    
    func nextBrew (x: CGFloat, y: CGFloat) -> UIView {
        let brew: UIView = UIView(frame: CGRect(x: x,
                                                y: y,
                                                width: CGFloat(self.barSize/*Brewris.barSize*/),
                                                height: CGFloat(self.barSize/*Brewris.barSize*/)))
        brew.backgroundColor = UIColor.white
        brew.clipsToBounds = true
        brew.layer.borderColor = BorderColor.cgColor
        brew.layer.borderWidth = 1.0
        return brew
    }
    
    func setNextBar(){
        self.theBar = self.nextTheBar
        self.isGameOver = self.GameOver(bar: self.theBar)
        self.CBColor = self.NBColor
        self.displayNextBar()
    }
    
    func brewrisInit(){
        
        self.brewTate = Array()
        for _ in 0..<self.brewrisTate {
            
            let brewYoko = self.brewYokoInit()
            
            self.brewTate.append(brewYoko)
        }
    }
    
    func brewYokoInit() -> [Bs] {
        
        var yoko: [Bs] = Array()
        
        for _ in 0..<self.brewrisYoko {
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

                    let brew: [Bs] = self.brewTate[cp.py+(tate)]
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

        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            self.startBrew()
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
            self.startBrew()
        })
        
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    @objc func moveBarBrew(){
//        BarLog(bar: self.theBar)
        if self.isBar == false {
            if self.isMove == false {
                self.isMove = true
                self.moveBrewControl(bar: self.theBar);
                self.barDisplay()
                if self.isGameOver == true {
                    self.moveBar.invalidate()
                    self.gameOverAlert()
                }
            }
        }
        
        if self.isBottom(needs: self.noNeed) == true
            ||  self.isBar == true {
            
            self.noNeed = Array()
            self.isBar = false
            self.cp.px = DPX
            self.cp.py = DPY
            self.setNextBar()
            self.brewTate = self.storeBar(store: self.brewTate)
            self.isGameOver = self.GameOver(bar: self.theBar)
            self.isInAgreement()
            self.isDownBar = false
            
        }else{
            
            self.isBar = self.judgementBrew()
            if self.isBar == false {
                self.noNeedEmurate()
                self.isMove = false
                self.isDown = true
                self.cp.py += 1
            }
        }
    }
    
    func BarInitialze(){
        var ViewTag: Int
        
        ViewTag = 1
        
        for _ in 0..<self.brewrisTate {
            
            for _ in 0..<self.brewrisYoko {
                self.noBrew(tag: ViewTag)
                ViewTag += 1
            }
        }
    }
    
    func barDisplay(){
        
        var tag: Int = 1
        
        for tate in 0..<self.brewrisTate {
            
            let isBar: [Bs] = self.brewTate[tate]
            
            for yoko in 0..<self.brewrisYoko {
                
                if isBar[yoko].bp == 1 {
                    self.Brew(tag: tag, bColor: isBar[yoko].bc)

                }else if isBar[yoko].bp != 2{
                    self.noBrew(tag: tag)
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
                    yokos[yoko].bc = self.CBColor
                    stores[tate] = yokos
                    
                }
            }
        }
        return stores
    }
    
    func noNeedEmurate(){
        
        for yoko in 0..<self.brewTate.count {
            
            var tate: [Bs] = self.brewTate[yoko]
            
            for brew in 0..<tate.count {
                if tate[brew].bp == 1 {
                    tate[brew].bp = 0
                }
            }
            self.brewTate[yoko] = tate
        }
    }
    
    func judgementBrew() -> Bool {
        
        for current in (0..<self.noNeed.count).reversed() {
            
            let cPosition: Cp = self.noNeed[current]
            
            let bar: [Bs] = self.brewTate[cPosition.py+1]
            
            if bar[cPosition.px].bp == 2 {
                return true
            }
        }
        return false // isBar
    }
    
    func isBottom(needs: [Cp]) -> Bool {
        
        let bottom = self.brewrisTate - 1
        
        for current in needs {
            
            if bottom <= current.py {
                return true
            }
        }
        return false
    }
    
    func moveBrewControl(bar: [Array<Any>]){
        
        var noNeedCo: Int = 0
        var storeNoNeed: [Cp] = Array()//self.setNoNeed()
        
        for tate in 0..<bar.count {
            
            let baryoko: [Int] = bar[tate] as! [Int]
            
            for yoko in 0..<baryoko.count {
                
                if baryoko[yoko] == 1 {
                    
                    var brew: [Bs] = self.brewTate[cp.py+(tate)]
                    brew[(yoko)+cp.px].bp = 1
                    brew[(yoko)+cp.px].bc = self.CBColor
                    self.brewTate[cp.py+(tate)] = brew
                    
                    storeNoNeed.append( Cp(px:(cp.px+yoko) , py:(cp.py+tate)))
                    noNeedCo += 1
                }
            }
        }
        self.noNeed = storeNoNeed
    }
    
    func isInAgreement() {
        
        var removeLists: [Int] = []
        
        for be in 0..<self.brewTate.count {
            
            let agreemnent: [Bs] = self.brewTate[be]
            var isRemove: Bool = false
            
            for agr in agreemnent {
                
                if(agr.bp == 0){
                    isRemove = true
                }
                
            }
            if isRemove != true {
                removeLists.append(be)
                print ("HIT bar \(be)")
            }
        }
        
        var isRm = false
        
        for rm in removeLists {
            
            self.brewTate.remove(at: rm)
            
            self.brewTate.insert(self.brewYokoInit(), at: rm)
            
            isRm = true
            
        }
        
        if isRm == true {
            isRm = false
            
            for rm in removeLists {
                self.brewTate.remove(at: rm)
                self.brewTate.insert(self.brewYokoInit(), at: 0)
                for bar in self.brewTate {
                    print (bar)
                }
            }
            
            var ViewTag: Int
            ViewTag = 1
            
            for tate in 0..<self.brewrisTate {
                
                let Bar: [Bs] = self.brewTate[tate]
                
                for yoko in 0..<self.brewrisYoko {
                    
                    if Bar[yoko].bp == 2 {
                        self.Brew(tag: ViewTag, bColor: Bar[yoko].bc)
                    }
                    ViewTag += 1
                }
            }
            self.setScore(sc: removeLists.count)
        }
        self.brewTate = self.storeBar(store: self.brewTate)
    }
    
    func setScore(sc: Int){
        
        self.score = self.score + 10 * sc * ((self.level) * 5)
        
        let lv = levelManager()
        
        self.level = lv.islevelUp(score: self.score)
        
        if lv.isLvUp == true {
            lv.isLvUp = false
            self.levelLbl.text = lv.levelLabel(lv: self.level)
            moveBar.invalidate()
            startGame()
        }
        self.scoreLabel.text = self.score.description
    }
}
