//
//  ZeldaViewCell.swift
//  ScoresApp
//
//  Created by Roger Espinoza on 29/4/23.
//

import UIKit

final class ZeldaViewCell: UICollectionViewCell {
    @IBOutlet weak var cover: UIImageView!
    
//    similar to didLoad
    override func awakeFromNib() {
        cover.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        cover.image = nil
    }
}


