import UIKit
import RedPackRainView
import SnapKit

class NinjaMomentController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var setBtn: UIButton!
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var ninjaGameView: UIView!
    
    var gameProp: GameProp = .GamePropL
    var gameSpeed: GameSpeed = .Medium
    var redPackRain: RedpackRainView?
    var second = 30
    var score = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initGameViewLayer()
    }
    
    func initGameViewLayer() {
        let gameRainView = RedpackRainView()
        self.gameView.addSubview(gameRainView)
        gameRainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        gameRainView.clickPenetrateEnable = true
        self.redPackRain = gameRainView
        
        self.initGameViewConfig()
    }
    
    func initGameViewConfig() {
        if let info = GameScoreModel.gameConfig() {
            let prop = info["gameprop"]  ?? 0
            let speed = info["gamespeed"]  ?? 0
            self.gameProp = GameProp(rawValue: prop) ?? .GamePropL
            self.gameSpeed = GameSpeed(rawValue: speed) ?? .Medium
        }
        let arrs = [self.gameProp.icon]
        self.redPackRain?.setRedPack(images: arrs, dropDownTime: self.gameSpeed.speed, totalTime: 30) { redPackView, clickview in
            guard let _ = clickview.layer.presentation() else { return }
            clickview.removeFromSuperview()
            self.score = redPackView.redPackClickedCount * 10
            self.scoreBtn.setTitle("Score: \(self.score)", for: .normal)
        }
        
        // 设置游戏结束回调
        self.redPackRain?.setCompleteHandle { (redPackView) in
            self.showGameEndpopView()
            self.startBtn.isHidden = false
            self.setBtn.isHidden = false
        }
    }
    
    func showGameEndpopView() {
        let NinjaTimerend = UIStoryboard(name: "NinjaTimerend", bundle: nil)
        guard let vc = NinjaTimerend.instantiateInitialViewController() as? NinjaEndpopController else {
            return
        }
        vc.gameProp = self.gameProp
        vc.gameSpeed = self.gameSpeed
        vc.score = self.score
        vc.dismissAction = {
            self.score = 0
            self.second = 30
            self.scoreBtn.setTitle("Score: \(self.score)", for: .normal)
            self.timerLabel.text = "\(self.second)"
        }
        self.navigationController?.definesPresentationContext = true
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    func scheduledTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timing), userInfo: nil, repeats: true)
    }
    
    @objc func timing() {
        self.second -= 1
        self.timerLabel.text = "\(self.second)"
        
        if (self.second == 0) {
            self.second = 30
            self.clearTimer()
        }
    }
    
    func clearTimer() {
        if (self.timer != nil) {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    @IBAction func startNinjaGame(_ sender: UIButton) {
        self.redPackRain?.startGame()
        self.scheduledTimer()
        sender.isHidden = true
        self.setBtn.isHidden = true
    }

    @IBAction func setGameDifficulty(_ sender: UIButton) {
        let NinjaGameSet = UIStoryboard(name: "NinjaGameSet", bundle: nil)
        guard let NinjaGameSetNav = NinjaGameSet.instantiateInitialViewController() as? UINavigationController, let vc = NinjaGameSetNav.topViewController as? NinjaGameSetController else {
            return
        }
        vc.configDoneAction = {
            self.initGameViewConfig()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func checkGameScore(_ sender: UIButton) {
        let NinjaGameScore = UIStoryboard(name: "NinjaGameScore", bundle: nil)
        guard let NinjaGameScoreNav = NinjaGameScore.instantiateInitialViewController() as? UINavigationController, let vc = NinjaGameScoreNav.topViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        self.clearTimer()
    }
}
