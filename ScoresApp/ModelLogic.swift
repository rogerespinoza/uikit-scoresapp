//
//  ModelLogic.swift
//  ScoresApp
//
//  Created by Roger Espinoza on 16/3/23.
//

import SwiftUI


final class ModelLogic {
    static let shared = ModelLogic()
    let persistence = ModelPersistence.shared
    
    private var scores: [Score] {
        didSet {
            try? persistence.saveScores(scores: scores)
        }
    }
    
    var search = ""
    
    var filteredScores:[Score] {
        scores
            .filter {
                if search.isEmpty {
                    return true
                } else {
                    return $0.title.lowercased().contains(search.lowercased())
                }
            }
    }
    
    private var favorites:[Favorite] {
        didSet {
            try? persistence.saveFavorites(favorites: favorites)
            NotificationCenter.default.post(name: .favoritesChange, object: nil)
        }
    }
    
    var composers:[String] {
        Array(Set(scores.map(\.composer))).sorted()
    }
    
    init() {
        do {
            self.scores = try persistence.getScores()
            self.favorites = try persistence.getFavorites()
        } catch {
            self.scores = []
            self.favorites = []
        }
    }
    
    func getRows() -> Int {
        filteredScores.count
    }
    
    func getFavoritesRows() -> Int {
        favorites.count
    }
    
    func getScoreRow(indexPath: IndexPath) -> Score {
        filteredScores[indexPath.row]
    }
    
    func deleteScore(indexPath: IndexPath) {
        scores.remove(at: indexPath.row)
    }
    
    func moveScore(indexPath:IndexPath, to:IndexPath) {
        let index = IndexSet(integer: indexPath.row)
        scores.move(fromOffsets: index, toOffset: to.row)
    }
    
    func updateScore(score:Score, newCover:UIImage?) {
        if let index = scores.firstIndex(where: { $0.id == score.id }) {
            scores[index] = score
        }
        if let newCover {
            try? persistence.saveImage(id: score.id, image: newCover)
        }
    }
    
    func indexScore(score:Score) -> Int? {
        scores.firstIndex(where: { $0.id == score.id })
    }
    
    func isFavorite(score:Score) -> Bool {
        favorites.contains { $0.id == score.id }
    }
    
    func toogleFavorite(score:Score) {
        if isFavorite(score:score) {
            favorites.removeAll { $0.id == score.id}
        } else {
            favorites.append(Favorite(id: score.id))
        }
    }
    
    func getScoreFromID(indexPath:IndexPath) -> Score? {
        let favorite = favorites[indexPath.row]
        return scores.first { score in
            score.id == favorite.id
        }
    }
}
