//
//  DetailViewController.swift
//  ScoresApp
//
//  Created by Roger Espinoza on 16/3/23.
//

import UIKit
import PhotosUI

class DetailViewController: UITableViewController, PHPickerViewControllerDelegate {

    let modelLogic = ModelLogic.shared
    let viewLogic = ViewLogic.shared
    
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var composer: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var length: UITextField!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var changeComposer: UIButton!
    
    var selectedScore:Score?
    var newCover:UIImage? {
        didSet {
            if let newCover {
                cover.image = newCover
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedScore {
            titulo.text = selectedScore.title
            composer.text = selectedScore.composer
            year.text = selectedScore.yearString
            length.text = selectedScore.lengthString
            cover.image = viewLogic.getCover(score: selectedScore)
        }
        
        changeComposerButton()
    }
    
    func changeComposerButton() {
        let actions = viewLogic.getMenuComposerActions(composerText: composer)
        changeComposer.menu = UIMenu(title: "Choose a composer", children: actions)
    }
    
    @IBAction func changeCover(_ sender: UIButton) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let PHPPicker = PHPickerViewController(configuration: configuration)
        PHPPicker.delegate = self
        present(PHPPicker, animated: true)
        
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        viewLogic.getDataFromLibrary(results: results) { image in
            self.newCover = image
        }
    }
    
    @IBAction func saveScore(_ sender: UIBarButtonItem) {
        guard let selectedScore,
              let tituloLabel  = titulo.text,
              let composerLabel = composer.text,
              let yearText = year.text,
              let newYear = Int(yearText.clearNumber),
              let lengthText = length.text,
              let newLength = NumberFormatter.decimalFormater.number(from: lengthText) else { return }
        
        let newScore = Score(id: selectedScore.id,
                             title: tituloLabel,
                             composer: composerLabel,
                             year: newYear,
                             length: Double(truncating: newLength),
                             cover: selectedScore.cover,
                             tracks: selectedScore.tracks)
        modelLogic.updateScore(score: newScore, newCover: newCover)
//        mode.saveImage(<#T##self: ModelPersistence##ModelPersistence#>)
        performSegue(withIdentifier: "saveBack", sender: nil)
    }
    
}
