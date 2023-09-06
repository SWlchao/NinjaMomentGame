//
//  NinjaGameScoreCell.swift
//  NinjaMoment
//
//  Created by Mac on 2023/7/28.
//

import UIKit

class NinjaGameScoreCell: UITableViewCell {

    static let RegisterCellId = "NinjaGameScoreCellId"
    
    @IBOutlet weak var playTime: UILabel!
    @IBOutlet weak var gameMode: UILabel!
    @IBOutlet weak var gameScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func gameScore(_ model: GameScoreModel) {
        self.playTime.text = model.time.ext.string("yyyy/MM/dd HH:mm")
        self.gameMode.text = GameSpeed(rawValue: model.speed)?.mode
        self.gameScore.text = "\(model.score)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
