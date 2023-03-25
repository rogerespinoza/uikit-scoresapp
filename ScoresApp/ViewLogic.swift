//
//  ViewLogic.swift
//  ScoresApp
//
//  Created by Roger Espinoza on 17/3/23.
//

import UIKit
import PhotosUI

final class ViewLogic {
    static let shared = ViewLogic()
    
    let modelLogic = ModelLogic.shared
    let persistenceLogic = ModelPersistence.shared
    
    func cellForRowAt(indexPath:IndexPath) -> UIListContentConfiguration {
        let score = modelLogic.getScoreRow(indexPath: indexPath)
        var content = UIListContentConfiguration.subtitleCell()
        content.text = score.title
        content.secondaryText = score.composer
        content.image = getCover(score: score)
        content.imageProperties.maximumSize = CGSize(width: 100, height: 100)
        content.imageProperties.reservedLayoutSize = CGSize(width: 100, height: 100)
        content.imageProperties.cornerRadius = 10
        
        return content
    }
    
    func getScoreForSegue(tableView:UITableView, sender:Any?) -> Score? {
        guard let cell = sender as? UITableViewCell,
              let cellIndexPath = tableView.indexPath(for: cell) else { return nil }
        
        return modelLogic.getScoreRow(indexPath: cellIndexPath) 
    }
    
    func getMenuComposerActions(composerText:UITextField) -> [UIAction] {
        var actions:[UIAction] = []
        for name in modelLogic.composers {
            let action = UIAction(title: name) {_ in
                composerText.text = name
            }
            actions.append(action)
        }
        return actions
    }
    
    func getImageFromLibrary(results:[PHPickerResult], callback: @escaping (UIImage) -> Void) {
        guard let provider = results.map(\.itemProvider).first else { return }
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { item, error in
                guard error == nil,
                        let image = item as? UIImage,
                      let resized = image.resizeImage(width: 100 * magnitude) else { return }
//                let with:CGFloat = 300
//                let scale:CGFloat = with / image.size.width
//                let height:CGFloat = image.size.height * scale
//                if let resized = image.preparingThumbnail(of: CGSize(width: with, height: height)) {
                    RunLoop.main.perform {
                        callback(resized)
                    }
//                }
            }
        }
    }
    
    func getDataFromLibrary(results:[PHPickerResult], callback: @escaping (UIImage) -> Void) {
        guard let provider = results.map(\.itemProvider).first else { return }
        if provider.hasItemConformingToTypeIdentifier("public.heic") || provider.hasItemConformingToTypeIdentifier("public.heif") {
            let _ = provider.loadFileRepresentation(forTypeIdentifier: "public.heic") { url, error in
                if let url, error == nil {
                    do {
                        let data = try Data(contentsOf: url)
                        if let image = UIImage(data: data),
                           let resized = image.resizeImage(width: 100 * magnitude) {
                            RunLoop.main.perform {
                                callback(resized)
                            }
                        }
                    }catch {
                        print("Error \(error)")
                    }
                }
            }
        } else {
            getImageFromLibrary(results: results, callback: callback)
        }
    }
    
    func getCover(score:Score) -> UIImage? {
        if let cover = try? persistenceLogic.loadImage(id: score.id) {
            return cover
        } else {
            return UIImage(named: score.cover)
        }
    }
}
