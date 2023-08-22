//
//  TouchSensitiveButton.swift
//  Image Box
//
//  Created by Krunal on 23/11/2022.
//

import UIKit

final private class TouchSensitiveButton: UIButton {
    //MARK: - Properties
    @IBInspectable public var duration: Double = 0.5 {
        didSet {
            if duration <= 0 {
                duration = 0.5
            }
        }
    }
    @IBInspectable public var initialAlpha: Double = 0.5 {
        didSet {
            if initialAlpha > 1.0 || initialAlpha < 0 {
                initialAlpha = 0.5
            }
        }
    }
    @IBInspectable public var opacityColor: UIColor = UIColor.white

    private var shapeLayer = CAShapeLayer()
    
    //MARK: - Initializers
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        self.addTarget(self, action: #selector(animateEffect), for: UIControl.Event.touchDown)
    }
    
    //MARK: - Animation
    @objc public func animateEffect() {
        if shapeLayer.superlayer != nil {
            shapeLayer.removeFromSuperlayer()
        }
        shapeLayer = CAShapeLayer()

        shapeLayer.opacity = Float(initialAlpha)
        shapeLayer.fillColor = opacityColor.cgColor
        shapeLayer.strokeColor = opacityColor.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.frame = bounds
        layer.addSublayer(shapeLayer)
        
        let fadingOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadingOutAnimation.fromValue = initialAlpha
        fadingOutAnimation.toValue = 0.0
        fadingOutAnimation.duration = duration * 0.8
        fadingOutAnimation.beginTime = duration * 0.2
        fadingOutAnimation.fillMode = .forwards
        fadingOutAnimation.isRemovedOnCompletion = false
        fadingOutAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        let group = CAAnimationGroup()
        group.animations = [fadingOutAnimation]
        group.duration = duration
        
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false
        CATransaction.begin()
        shapeLayer.add(group, forKey: nil)
        CATransaction.commit()
    }
}
