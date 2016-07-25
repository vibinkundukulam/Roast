//
//  TextKeyboardView.swift
//  ContainingAppForBard-3
//
//  Created by Vibin on 7/24/16.
//  Copyright © 2016 Vibin Kundukulam. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class TextKeyboardView: UIView {
    var activeTextField: UITextField? = nil
    
    func addRowOfButtons(keyboardRowView: UIView, buttonTitles: [String], inout buttons: [UIButton]) {
        for buttonTitle in buttonTitles {
            let button = createButtonWithTitle(buttonTitle)
            buttons.append(button)
            keyboardRowView.addSubview(button)
        }
    }
    
    func addIndividualButtonConstraints(buttons: [UIButton], mainView: UIView) {
        
        // Calculate spaces
        
        let numButtons = buttons.count
        let buttonWidth = mainView.frame.width / 12
        let buttonSpace = CGFloat(numButtons) * buttonWidth
        let spaceBetweenButtons = buttonWidth / 5
        let spaceSpace = spaceBetweenButtons * (CGFloat(numButtons) - 1)
        let leftOverSpace = mainView.frame.width - buttonSpace - spaceSpace
        let sideMargin = leftOverSpace/2

     /*   let spaceBetweenButtons = CGFloat(4)
        let sideMargin = CGFloat(4) */
        
        
        // Set constraints
        
        for (index, button) in buttons.enumerate() {
            let topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1.0, constant: 3)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1.0, constant: -3)
            
            var rightConstraint : NSLayoutConstraint!
            if index == buttons.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: mainView, attribute: .Right, multiplier: 1.0, constant: -sideMargin)
            } else {
                let nextButton = buttons[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: nextButton, attribute: .Left, multiplier: 1.0, constant: -spaceBetweenButtons)
            }
            
            var leftConstraint : NSLayoutConstraint!
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: mainView, attribute: .Left, multiplier: 1.0, constant: sideMargin)
            } else {
                
                let prevtButton = buttons[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: prevtButton, attribute: .Right, multiplier: 1.0, constant: spaceBetweenButtons)
                
                let firstButton = buttons[0]
                let widthConstraint = NSLayoutConstraint(item: firstButton, attribute: .Width, relatedBy: .Equal, toItem: button, attribute: .Width, multiplier: 1.0, constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
         //   let widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonWidth)
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
            
        }
    }
    
    func createButtonWithTitle(title: String) -> UIButton {
        let button = UIButton(type: .System) as UIButton         // exact size doesn't matter
        button.setTitle(title, forState: .Normal)
        button.sizeToFit()
        button.titleLabel!.font = UIFont.systemFontOfSize(16)
        button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
        
        return button
    }
    
    func didTapButton(sender: AnyObject?) {
        
        let button = sender as! UIButton
        let title = button.titleForState(.Normal)
        activeTextField!.insertText(title!)
        
    }
}