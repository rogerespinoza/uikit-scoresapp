//
//  ScoresModel.swift
//  ScoresApp
//
//  Created by Roger Espinoza on 14/3/23.
//

import Foundation


struct Score: Codable, Hashable {
    let id: Int
    let title: String
    let composer: String
    let year: Int
    let length: Double
    let cover: String
    let tracks: [String]
}

struct Favorite:Codable {
    let id:Int
}

extension Score {
    var yearString:String {
        "\(year.formatted(.number.precision(.integerLength(4))))"
    }
    var lengthString:String {
        "\(length.formatted(.number.precision(.integerAndFractionLength(integer: 2, fraction: 1))))"
    }
}
