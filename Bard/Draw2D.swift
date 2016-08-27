//
//  Draw2D.swift
//  ContainingAppForBard-3
//
//  Created by Vibin on 7/27/16.
//  Copyright © 2016 Vibin Kundukulam. All rights reserved.
//

import Foundation
import UIKit

class Draw2D: UIControl {
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.

        override func drawRect(rect: CGRect)
        {
            let context = UIGraphicsGetCurrentContext()
            CGContextSetLineWidth(context, 1.0)
            CGContextSetStrokeColorWithColor(context,
                UIColor.darkGrayColor().CGColor)
            CGContextMoveToPoint(context, 18, 10)
            CGContextAddLineToPoint(context, 12, 15)
            CGContextAddLineToPoint(context, 18, 20)
            CGContextStrokePath(context)
        }
    
}
