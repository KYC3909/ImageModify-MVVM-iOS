//
//  ImageBoxDrawableService.swift
//  Image Box
//
//  Created by Krunal on 22/11/2022.
//

import Foundation
import UIKit

extension UIImage {
    func drawRectangleOnImageWith(_ photoConfiguration: PhotoConfiguration) -> UIImage? {
        return addImage(self, photoConfiguration)
    }
}

func addImage(_ img: UIImage, _ photoConfiguration: PhotoConfiguration) -> UIImage {
    // create a CGRect representing the full size of our input iamge
    let imgRect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)

    // set up the colors – these are based on my trial and error
    let red = UIColor.red.withAlphaComponent(0.7)

    let renderer = UIGraphicsImageRenderer(size: img.size)
    let result = renderer.image { ctx in

        let color = red

        // figure out the rect for this section
        let rect = CGRect(origin: photoConfiguration.point,
                          size: photoConfiguration.size)

        // draw it onto the context at the right place
//        color.set()
//        ctx.fill(rect)
//        ctx.stroke(rect)

        
        ctx.cgContext.setFillColor(UIColor.clear.cgColor)
        ctx.cgContext.setStrokeColor(color.cgColor)
        ctx.cgContext.setLineWidth(60)

        ctx.cgContext.addRect(rect)
        ctx.cgContext.drawPath(using: .fillStroke)

        
        // now draw our input image over using Luminosity mode, with a little bit of alpha to make it fainter
        img.draw(in: imgRect, blendMode: .overlay, alpha: 1)
    }

    return result
}
