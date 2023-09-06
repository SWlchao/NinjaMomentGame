import UIKit

class NinjaEndpopController: UIViewController {

    @IBOutlet weak var gameMode: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score = 0
    var gameProp: GameProp = .GamePropL
    var gameSpeed: GameSpeed = .Medium
    var dismissAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.gameMode.text = "\(self.gameSpeed.mode) mode"
        let attrString = NSMutableAttributedString(string: "\(score)")
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.ext.rgb(255, 241, 175)
        shadow.shadowBlurRadius = 0
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        
        let attr: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 20, weight: .semibold),.foregroundColor: UIColor(red: 1, green: 0.95, blue: 0.69,alpha:1), .shadow: shadow, .strokeColor: UIColor.ext.rgb(162, 99, 48), .strokeWidth: -6]
        attrString.addAttributes(attr, range: NSRange(location: 0, length: attrString.length))
        self.scoreLabel.attributedText = attrString
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        self.dismissAction?()
        self.dismiss(animated: false)
    }
    
    @IBAction func clickDone(_ sender: Any) {
        
        let scoreid = GameScoreModel.scoreId()
        let scoreModel = GameScoreModel(id: scoreid, speed: gameSpeed, score: score, prop: gameProp)
        NinjaMomentNM.addGameModel(scoreModel)
        GameScoreModel.saveScoreId(scoreid+1)
        self.ext.alert("Save succeed") {
            self.dismissAction?()
            self.dismiss(animated: false)
        }  
    }
}
