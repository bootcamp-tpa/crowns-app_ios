import UIKit

class LeaderboardsViewController: UITableViewController {
    private var viewModel: LeaderboardsViewModel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerReusables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighscoreTableViewCell", for: indexPath) as! HighscoreTableViewCell
        let model = viewModel.cellModel(atIndexPath: indexPath)
        cell.bind(withModel: model)
        return cell
    }
    
    private func registerReusables() {
        let nib = UINib(nibName: "HighscoreTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "HighscoreTableViewCell")
    }
    
    @IBAction private func didPullToRefresh(_ sender: Any) {
        viewModel.didPullToRefresh()
    }
}

extension LeaderboardsViewController: LeaderboardsViewModelDelegate {
    func endRefreshing() {
        refreshControl!.endRefreshing()
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}

extension LeaderboardsViewController {
    static func instantiate(withHighscores highscores: [Highscore]) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "LeaderboardsViewController") as! LeaderboardsViewController
        let viewModel = LeaderboardsViewModel(
            highscores: highscores,
            webService: WebServiceImp(),
            scoreFormatter: GameScoreFormatterImp()
        )
        controller.viewModel = viewModel
        viewModel.delegate = controller
        return controller
    }
}
