import UIKit

class NinjaGameSetController: UIViewController {
    
    @IBOutlet weak var gameProp1: UIButton!
    @IBOutlet weak var gameProp2: UIButton!
    @IBOutlet weak var gameProp3: UIButton!
    
    @IBOutlet weak var gameSpeed1: UIButton!
    @IBOutlet weak var gameSpeed2: UIButton!
    @IBOutlet weak var gameSpeed3: UIButton!
    
    var gameProp: GameProp = .GamePropL
    var gameSpeed: GameSpeed = .Medium
    
    var configDoneAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let info = GameScoreModel.gameConfig() {
            
            let prop = info["gameprop"]  ?? 0
            let speed = info["gamespeed"]  ?? 0
            
            self.gameProp = GameProp(rawValue: prop) ?? .GamePropL
            self.gameSpeed = GameSpeed(rawValue: speed) ?? .Medium
            
            self.gameProp1.isSelected = self.gameProp == .GamePropL
            self.gameProp2.isSelected = self.gameProp == .GamePropC
            self.gameProp3.isSelected = self.gameProp == .GamePropR
            
            self.gameSpeed1.isSelected = self.gameSpeed == .Fast
            self.gameSpeed2.isSelected = self.gameSpeed == .Medium
            self.gameSpeed3.isSelected = self.gameSpeed == .Slow
        }
    }

    @IBAction func extNinjaGameSet(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectGameProp(_ sender: UIButton) {
        self.gameProp = GameProp(rawValue: sender.tag) ?? .GamePropL
        self.gameProp1.isSelected = self.gameProp == .GamePropL
        self.gameProp2.isSelected = self.gameProp == .GamePropC
        self.gameProp3.isSelected = self.gameProp == .GamePropR
        
    }
    
    @IBAction func selectGameSpeed(_ sender: UIButton) {
        self.gameSpeed = GameSpeed(rawValue: sender.tag) ?? .Medium
        self.gameSpeed1.isSelected = self.gameSpeed == .Fast
        self.gameSpeed2.isSelected = self.gameSpeed == .Medium
        self.gameSpeed3.isSelected = self.gameSpeed == .Slow
    }
    
    @IBAction func savGameConfig(_ sender: UIButton) {
        let info: [String:Int] = [
            "gameprop":self.gameProp.rawValue,
            "gamespeed":self.gameSpeed.rawValue
        ]
        GameScoreModel.saveConfig(info)
        self.ext.alert("Save succeed") {
            self.configDoneAction?()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
