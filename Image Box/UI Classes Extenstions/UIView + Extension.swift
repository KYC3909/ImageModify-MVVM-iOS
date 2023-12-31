//
//  UIView + Extension.swift
//  Image Box
//
//  Created by Krunal on 23/11/2022.
//

import Foundation
import UIKit

extension UIView {
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.shadowRadius = newValue
            layer.masksToBounds = false
        }
    }
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            layer.shadowColor = UIColor.gray.cgColor
        }
    }
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            layer.shadowColor = UIColor.gray.cgColor
            layer.masksToBounds = false
        }
    }
}

enum CardViewType {
    case appstore
    case playstore
}

extension UIView {
    // Load CardView / DropShadow based on the type selected.
    /// Type: `.appstore`, `.playstore`
    func cardView(_ type: CardViewType) {
        switch type {
            case .appstore: dropShadowForAppStore()
            case .playstore: dropShadowForPlayStore()
        }
    }
    
    // Drop Shadow like `AppStore`
    private func dropShadowForAppStore(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.cornerRadius = 20
        layer.shadowRadius = 12
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // Drop Shadow like `PlayStore`
    private func dropShadowForPlayStore(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.cornerRadius = 8
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // Apply Corner Radius
    func applyCornerRadius() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 8
    }

}
