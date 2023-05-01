//
//  ScoresTableViewController.swift
//  ScoresApp
//
//  Created by Roger Espinoza on 14/3/23.
//

import UIKit

class ScoresTableViewController: UITableViewController, UISearchResultsUpdating {
    
    let modelLogic = ModelLogic.shared
    let viewLogic = ViewLogic.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        magnitude = view.window?.windowScene?.screen.nativeScale ?? 1.0
        
        let searchController = viewLogic.getSearchBar()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
//        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.contentOffset = CGPoint(x: 0, y: 4)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        modelLogic.getRows()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
        cell.contentConfiguration = viewLogic.cellForRowAt(indexPath: indexPath)
        return cell        
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            modelLogic.deleteScore(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        modelLogic.moveScore(indexPath: fromIndexPath, to: to)
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let score = modelLogic.getScoreRow(indexPath: indexPath)
        let isFavorite = {
            modelLogic.isFavorite(score:score)
        }()
        let action = UIContextualAction(style: isFavorite ? .destructive : .normal, title: "Favorited") { [self]_,_, handler in
            modelLogic.toogleFavorite(score:score)
            handler(true)
        }
        action.image = UIImage(systemName: isFavorite ? "star" : "star.fill")
        action.backgroundColor = isFavorite ? .red : .blue
        return UISwipeActionsConfiguration(actions: [action])
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "detalle",
              let detail = segue.destination as? DetailViewController else { return }

        detail.selectedScore = viewLogic.getScoreForSegue(tableView: tableView, sender: sender)
        
    }
    
    @IBAction func back(_ segue:UIStoryboardSegue) {
        guard let source = segue.source as? DetailViewController,
              let selected = source.selectedScore,
              let index = modelLogic.indexScore(score: selected) else { return }
        
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    //MARK: - Search
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.text else { return }
        modelLogic.search = search
        tableView.reloadData()
    }
}
