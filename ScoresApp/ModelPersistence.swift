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
