//
//  BubbleLabel.swift
//  OraChat
//
//  Created by Haskel Ash on 8/23/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import UIKit

class BubbleLabel: UILabel {

    enum Side {
        case Left, Right
    }

    //this determines if the bubble point to the lower left or lower right (lower left by default)
    var side = Side.Left {
        didSet {
            if side != oldValue {
                setNeedsDisplay()
            }
        }
    }

    static var insets = UIEdgeInsets(top: 17, left: 19, bottom: 19, right: 15)

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        let x = self.bounds.origin.x, y = self.bounds.origin.y
        let width = self.bounds.width, height = self.bounds.height

        //change these radii to change the effect of the 3 very round courners and the 1 slightly less round courners
        let smallRadius: CGFloat = min(4, min(height/2, width/2))
        let bigRadius: CGFloat = min(25, min(height/2, width/2))
        let bottomLeftRadius = side == .Left ? smallRadius : bigRadius
        let bottomRightRadius = side == .Right ? smallRadius : bigRadius

        let pi = CGFloat(M_PI)
        let rightAngle: CGFloat = 0
        let downAngle: CGFloat = pi/2
        let leftAngle: CGFloat = pi
        let upAngle: CGFloat = pi*3/2

        //these four points each represent the orgin of a circle, indented from a corner of the bounds by the radius amount, which will be used to draw an arc
        let topLeftOrigin = CGPointMake(x+bigRadius, y+bigRadius)
        let topRightOrigin = CGPointMake(x+width-bigRadius, y+bigRadius)
        let bottomRightOrigin = CGPointMake(x+width-bottomRightRadius, y+height-bottomRightRadius)
        let bottomLeftOrigin = CGPointMake(x+bottomLeftRadius, y+height-bottomLeftRadius)

        //start drawing from the top left of the bounds, just to the right of where the top left arc will end
        let startPoint = CGPointMake(x+bigRadius, y)

        //draw each arc, starting from top left and going clockwise
        let path = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addArcWithCenter(topRightOrigin, radius: bigRadius, startAngle: upAngle, endAngle: rightAngle, clockwise: true)
        path.addArcWithCenter(bottomRightOrigin, radius: bottomRightRadius, startAngle: rightAngle, endAngle: downAngle, clockwise: true)
        path.addArcWithCenter(bottomLeftOrigin, radius: bottomLeftRadius, startAngle: downAngle, endAngle: leftAngle, clockwise: true)
        path.addArcWithCenter(topLeftOrigin, radius: bigRadius, startAngle: leftAngle, endAngle: upAngle, clockwise: true)
        path.closePath()

        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.CGPath
        self.layer.mask = maskLayer
    }

    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, BubbleLabel.insets))
    }
}