//
//  DiffableScoreTableVC.swift
//  ScoresApp
//
//  Created by Roger Espinoza on 30/4/23.
//

import UIKit

class DiffableScoreTableVC: UITableViewController, UISearchResultsUpdating {
    let modelLogic = ModelLogic.shared
    let viewLogic = ViewLogic.shared
    
    lazy var dataSource:ScoresDiffableDataSource = {
        ScoresDiffableDataSource(tableView:tableView) { [self] table, indexPath, score in
            let cell = table.dequeueReusableCell(withIdentifier: "zelda", for: indexPath) as? ZeldaScoreNewCell
            cell?.scoreTitle.text = score.title
            cell?.composer.text = score.composer
            cell?.cover.image = viewLogic.getCover(score: score)
            return cell
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        dataSource.apply(modelLogic.snapshot)
        
//        searchBar
        let searchController = viewLogic.getSearchBar()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
//        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.contentOffset = CGPoint(x: 0, y: 4)
    }
    
    @IBSegueAction func showDetail(_ coder: NSCoder) -> DetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        let detail = DetailViewController(coder: coder)
        detail?.selectedScore = dataSource.itemIdentifier(for: indexPath)
        return detail
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.text else { return }
        modelLogic.search = search
        dataSource.apply(modelLogic.snapshot, animatingDifferences: true)
    }
    
    
    @IBAction func back(_ segue:UIStoryboardSegue) {
        dataSource.apply(modelLogic.snapshot, animatingDifferences: false)
    }
    
}
