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
    
    var composers:[String] {
        Array(Set(scores.map(\.composer))).sorted()
    }
    
    init() {
        do {
            self.scores = try persistence.getScores()
        } catch {
            self.scores = []
        }
    }
    
    func getRows() -> Int {
        scores.count
    }
    
    func getScoreRow(indexPath: IndexPath) -> Score {
        scores[indexPath.row]
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
}
