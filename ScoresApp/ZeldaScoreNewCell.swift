//
//  ZeldaScoreNewCell.swift
//  ScoresApp
//
//  Created by Roger Espinoza on 30/4/23.
//

import UIKit

class ZeldaScoreNewCell: UITableViewCell {

    @IBOutlet weak var scoreTitle: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var composer: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
