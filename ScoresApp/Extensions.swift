//
//  Extensions.swift
//  ScoresApp
//
//  Created by Roger Espinoza on 18/3/23.
//

import UIKit

var magnitude:CGFloat = 1.0

extension NumberFormatter {
    static let decimalFormater: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()
    
}

extension String {
    var clearNumber:String {
        let numbers:Set<Character> = Set("0123456789")
        return filter { numbers.contains( $0 )}
    }
}


extension UIImage {
    func resizeImage(width: CGFloat ) -> UIImage? {
        let scale:CGFloat = width / size.width
        let height:CGFloat = size.height * scale
        return preparingThumbnail(of: CGSize(width: width, height: height))
    }
    
    func resizeImageOld(newWidth:CGFloat) -> UIImage? {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newWidth, height: newHeight)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
