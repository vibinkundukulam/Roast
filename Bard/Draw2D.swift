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

        override func draw(_ rect: CGRect)
        {
            let context = UIGraphicsGetCurrentContext()
            context?.setLineWidth(1.0)
            context?.setStrokeColor(UIColor.darkGray.cgColor)
            context?.move(to: CGPoint(x: 18, y: 10))
            context?.addLine(to: CGPoint(x: 12, y: 15))
            context?.addLine(to: CGPoint(x: 18, y: 20))
            context?.strokePath()
        }
    
}
