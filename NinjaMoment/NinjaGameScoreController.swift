
import UIKit

class NinjaGameScoreController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nscoreView: UIImageView!
    
    var gameScore: [GameScoreModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.registerNinjaGameScoreCell()
    }
    
    func registerNinjaGameScoreCell() {
        self.tableView.register(UINib(nibName: "NinjaGameScoreCell", bundle: nil), forCellReuseIdentifier: NinjaGameScoreCell.RegisterCellId)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.loadDataSource()
    }
    
    func loadDataSource() {
        self.gameScore = NinjaMomentNM.queryGameModel(object: GameScoreModel())
        self.tableView.reloadData()
        self.nscoreView.isHidden = !self.gameScore.isEmpty
    }
    
    @IBAction func extNinjaGameScore(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension NinjaGameScoreController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameScore.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 205
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NinjaGameScoreCell.RegisterCellId, for: indexPath) as? NinjaGameScoreCell else {
            return NinjaGameScoreCell(style: .default, reuseIdentifier: NinjaGameScoreCell.RegisterCellId)
        }
        let score = self.gameScore[indexPath.row]
        cell.gameScore(score)
        return cell
    }
}
