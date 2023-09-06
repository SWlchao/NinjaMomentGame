import UIKit
import Realm
import RealmSwift

class GameScoreModel: Object {
    
    static let GameScoreID = "GameScoreID"
    static let GameConfigID = "GameConfigID"
    
    @objc dynamic var id: Int = 0
    @objc dynamic var prop: Int = GameProp.GamePropL.rawValue
    @objc dynamic var speed: Int = GameSpeed.Medium.rawValue
    @objc dynamic var score: Int = 0
    @objc dynamic var time: Date!
    
    convenience init(id: Int,
                     speed: GameSpeed,
                     score: Int,
                     prop: GameProp = .GamePropL,
                     time: Date = Date()) {
        self.init()
        self.id = id
        self.prop = prop.rawValue
        self.speed = speed.rawValue
        self.score = score
        self.time = time
    }
    
    //设置模型的主键
    override class func primaryKey() -> String? {
        return "id"
    }
    
    class func saveScoreId(_ id: Int) {
        UserDefaults.standard.setValue(id, forKey: GameScoreID)
        UserDefaults.standard.synchronize()
    }
    
    class func scoreId() -> Int {
        return UserDefaults.standard.object(forKey: GameScoreID) as? Int ?? 0
    }
    
    class func saveConfig(_ info: [String:Int]) {
        UserDefaults.standard.setValue(info, forKey: GameConfigID)
        UserDefaults.standard.synchronize()
    }
    
    class func gameConfig() -> [String:Int]? {
        return UserDefaults.standard.object(forKey: GameConfigID) as? [String:Int]
    }
}


enum GameProp: Int {
    case GamePropL = 0
    case GamePropC = 1
    case GamePropR = 2
    
    var title: String {
        switch self {
        case .GamePropL: return "Prop.1"
        case .GamePropC: return "Prop.2"
        case .GamePropR: return "Prop.3"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .GamePropL: return UIImage(named: "ninja.game.prop.1") ?? UIImage()
        case .GamePropC: return UIImage(named: "ninja.game.prop.2") ?? UIImage()
        case .GamePropR: return UIImage(named: "ninja.game.prop.3") ?? UIImage()
        }
    }
}

enum GameSpeed: Int {
    case Fast = 0
    case Medium = 1
    case Slow = 2
    
    var mode: String {
        switch self {
        case .Fast: return "Fast"
        case .Medium: return "Medium"
        case .Slow: return "Slow"
        }
    }
    
    var speed: Double {
        switch self {
        case .Fast: return 3
        case .Medium: return 5
        case .Slow: return 7
        }
    }
}
