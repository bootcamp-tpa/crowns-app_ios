import UIKit

struct HighscoreCellModel {
    let rank: String
    let username: String
    let score: String
}

class HighscoreTableViewCell: UITableViewCell {
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    func bind(withModel model: HighscoreCellModel) {
        rankLabel.text = model.rank
        usernameLabel.text = model.username
        scoreLabel.text = model.score
    }
}
