//
//  ModelPersistence.swift
//  ScoresApp
//
//  Created by Roger Espinoza on 16/3/23.
//

import UIKit

final class ModelPersistence {
    static let shared = ModelPersistence()
    let scoresBundleURL = Bundle.main.url(forResource: "scoresdata", withExtension: "json")!
    let scoresDocuments = URL.documentsDirectory.appending(path: "scoresdata.json")
    let favDocuments = URL.documentsDirectory.appending(path: "favorites.json")
    
    func getScores() throws -> [Score] {
        if FileManager.default.fileExists(atPath: scoresDocuments.path()) {
            let data = try Data(contentsOf: scoresDocuments)
            return try JSONDecoder().decode([Score].self, from: data)
        } else {
            let data = try Data(contentsOf: scoresBundleURL)
            return try JSONDecoder().decode([Score].self, from: data)
        }
    }
    
    func saveScores(scores: [Score]) throws {
        let data = try JSONEncoder().encode(scores)
        try data.write(to: scoresDocuments, options: .atomic)
    }
    
    func getFavorites() throws -> [Favorite] {
        if FileManager.default.fileExists(atPath: favDocuments.path()) {
            let data = try Data(contentsOf: favDocuments)
            return try JSONDecoder().decode([Favorite].self, from: data)
        } else {
            return []
        }
    }
    
    func saveFavorites(favorites:[Favorite]) throws {
        let data = try JSONEncoder().encode(favorites)
        try data.write(to: favDocuments, options: .atomic)
    }
    
    func saveImage(id:Int, image:UIImage) throws {
        let urlImage = URL.documentsDirectory.appending(path: "\(id)_cover.jpg")
        if let data = image.jpegData(compressionQuality: 0.7) {
            try data.write(to: urlImage, options: .atomic)
        }
    }
    
    func loadImage(id:Int) throws -> UIImage? {
        let urlImage = URL.documentsDirectory.appending(path: "\(id)_cover.jpg")
        if FileManager.default.fileExists(atPath: urlImage.path()) {
            let data = try Data(contentsOf: urlImage)
            return UIImage(data: data)
        } else {
            return nil
        }
    }
}
