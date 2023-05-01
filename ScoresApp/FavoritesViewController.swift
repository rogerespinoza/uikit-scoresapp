//
//  FavoritesViewController.swift
//  ScoresApp
//
//  Created by Roger Espinoza on 16/3/23.
//

import UIKit

private let reuseIdentifier = "zelda"

class FavoritesViewController: UICollectionViewController {
    
    let modelLogic = ModelLogic.shared
    let viewLogic = ViewLogic.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        NotificationCenter.default.addObserver(forName: .favoritesChange, object: nil, queue: .main) { _ in
            
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        }
    }



    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        modelLogic.getFavoritesRows()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ZeldaViewCell,
            let score = modelLogic.getScoreFromID(indexPath: indexPath)
        else {
            return UICollectionViewCell()
        }
        cell.cover.image = viewLogic.getCover(score: score)
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .favoritesChange, object: nil)
    }

}
