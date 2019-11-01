//
//  Extensions.swift
//  Cluster
//
//  Created by Ways on 26/10/19.
//  Copyright © 2019 Hema Dhawan. All rights reserved.
//

import GoogleMaps
import Foundation

extension GMSMapView {
    func createMarker(_ iconMarker: UIView) -> GMSMarker {
        
        let marker = GMSMarker()
        marker.iconView = iconMarker
        return marker
    }
}

extension UIViewController {
    func createTollMarker(_ place: String) -> UIView  {
        //
        let image = #imageLiteral(resourceName: "tollUnSelected")
        let markerView = UIView.init(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        markerView.backgroundColor = UIColor.init(patternImage: image)
        
        let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10.0), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)] as [NSAttributedString.Key : Any]
        
        let lblTollName = UILabel()
        lblTollName.textAlignment = .center
        lblTollName.attributedText = NSAttributedString(string: place, attributes: attributes)
        markerView.addSubview(lblTollName)
        let yPosition = image.size.height*0.18
        lblTollName.frame = CGRect(x: 6, y: yPosition, width: image.size.width-12, height: image.size.height*0.3)
        return markerView
    }
}

class MapClusterIconGenerator: GMUDefaultClusterIconGenerator {

    override func icon(forSize size: UInt) -> UIImage {
        let image = textToImage(drawText: String(size) as NSString,
                                inImage: UIImage(named: "cluster")!,
                                font: UIFont.systemFont(ofSize: 12))
        return image
    }

    private func textToImage(drawText text: NSString, inImage image: UIImage, font: UIFont) -> UIImage {

        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.center
        let textColor = UIColor.black
        let attributes=[
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: textStyle,
            NSAttributedString.Key.foregroundColor: textColor]

        // vertically center (depending on font)
        let textH = font.lineHeight
        let textY = (image.size.height-textH)/2
        let textRect = CGRect(x: 0, y: textY, width: image.size.width, height: textH)
        text.draw(in: textRect.integral, withAttributes: attributes)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }

}
