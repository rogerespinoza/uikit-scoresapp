//
//  ScoresDiffableDataSource.swift
//  ScoresApp
//
//  Created by Roger Espinoza on 1/5/23.
//

import UIKit

final class ScoresDiffableDataSource:UITableViewDiffableDataSource<String, Score> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let snapshot = snapshot()
        return snapshot.sectionIdentifiers[section]
    }
}
