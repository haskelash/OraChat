//
//  FormLabel.swift
//  OraChat
//
//  Created by Haskel Ash on 8/25/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import UIKit

class FormField: UITextField {
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        //gray line along the bottom
        let context = UIGraphicsGetCurrentContext()
        CGContextMoveToPoint(context, 0, self.bounds.height-1)
        CGContextAddLineToPoint(context, self.bounds.width, self.bounds.height-1)
        CGContextSetLineWidth(context, 1)
        CGContextSetStrokeColorWithColor(
            context, UIColor(red:0.784, green:0.780, blue:0.800, alpha:1.00).CGColor)
        CGContextStrokePath(context)
    }
}
