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
    let navColor = UIColor(red: 136/255, green: 5/255, blue: 5/255, alpha: 1.0)
    
    func addRowOfButtons(inout keyboardRowView: UIView!, buttonTitles: [String], inout buttons: [UIButton]) {
        for buttonTitle in buttonTitles {
            let button = createButtonWithTitle()
            button.setTitle(buttonTitle, forState: .Normal)
            button.titleLabel!.font = UIFont.systemFontOfSize(16)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.layer.cornerRadius = 5
            button.translatesAutoresizingMaskIntoConstraints = false
            buttons.append(button)
            keyboardRowView.addSubview(button)
        }
    }
    
    func addFinalRowOfButtons(inout keyboardRowView: UIView!, buttonTitles: [String], inout buttons: [UIButton]) {
        var button: UIButton
        for index in 0...2 {
            if index == 0 {
                button = createChangeKeyboardButton()
            } else if index == 1 {
                button = createSpaceButton()
            } else {
                button = createTrumpButton()
            }
            button.setTitle(buttonTitles[index], forState: .Normal)
            button.titleLabel!.font = UIFont.systemFontOfSize(16)
            button.layer.cornerRadius = 5
            button.translatesAutoresizingMaskIntoConstraints = false
            buttons.append(button)
            keyboardRowView.addSubview(button)
        }
    }

    func addIndividualButtonConstraints(inout buttons: [UIButton], mainView: UIView) {
     
        // Calculate spaces
        
        let numButtons = buttons.count
        let buttonWidth = mainView.frame.width / 12
        let buttonSpace = CGFloat(numButtons) * buttonWidth
        let spaceBetweenButtons = buttonWidth / 5
        let spaceSpace = spaceBetweenButtons * (CGFloat(numButtons) - 1)
        let leftOverSpace = mainView.frame.width - buttonSpace - spaceSpace
        let sideMargin = leftOverSpace/2
        print("\nTotal width: \(mainView.frame.width)")
        print("Button Width: \(buttonWidth)")
        print("Space between buttons: \(spaceBetweenButtons)")
        print("Side Margin: \(sideMargin)")
        
        // Set constraints
        
        for (index, button) in buttons.enumerate() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1.0, constant: 3)
            topConstraint.identifier = "Top Constraint for \(button.titleLabel!.text)"
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1.0, constant: -3)
            bottomConstraint.identifier = "Bottom Constraint for \(button.titleLabel!.text)"
            
            var rightConstraint : NSLayoutConstraint!
            if index == buttons.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: mainView, attribute: .Right, multiplier: 1.0, constant: -sideMargin)
            } else {
                let nextButton = buttons[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: nextButton, attribute: .Left, multiplier: 1.0, constant: -spaceBetweenButtons)
                
            }
            rightConstraint.identifier = "Right Constraint for \(button.titleLabel!.text)"
            
            var leftConstraint : NSLayoutConstraint!
            var widthConstraint: NSLayoutConstraint!
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: mainView, attribute: .Left, multiplier: 1.0, constant: sideMargin)
                
                
            } else {
                
                let prevtButton = buttons[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: prevtButton, attribute: .Right, multiplier: 1.0, constant: spaceBetweenButtons)
                
                let firstButton = buttons[0]
                widthConstraint = NSLayoutConstraint(item: firstButton, attribute: .Width, relatedBy: .Equal, toItem: button, attribute: .Width, multiplier: 1.0, constant: 0)
                
                mainView.addConstraint(widthConstraint)
                
                widthConstraint.identifier = "Width Constraint for \(button.titleLabel!.text)"
                
            }
            leftConstraint.identifier = "Left Constraint for \(button.titleLabel!.text)"
            
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
            
        }
        buttons.removeAll()
    }
    
    func addFinalRowButtonConstraints(inout buttons: [UIButton], mainView: UIView) {
        // Calculate spaces
        
        let numButtons = 10
        let textButtonWidth = mainView.frame.width / 12
        let buttonSpace = CGFloat(numButtons) * textButtonWidth
        let spaceBetweenButtons = textButtonWidth / 5
        let spaceSpace = spaceBetweenButtons * (CGFloat(numButtons) - 1)
        let leftOverSpace = mainView.frame.width - buttonSpace - spaceSpace
        let sideMargin = leftOverSpace/2
        let spaceButtonWidth = 5 * textButtonWidth + 4 * spaceBetweenButtons
        
        
        // Set constraints
        
        for (index, button) in buttons.enumerate() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1.0, constant: 3)
            topConstraint.identifier = "Top Constraint for \(button.titleLabel!.text)"
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1.0, constant: -3)
            bottomConstraint.identifier = "Bottom Constraint for \(button.titleLabel!.text)"
            
            var rightConstraint : NSLayoutConstraint!
            if index == buttons.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: mainView, attribute: .Right, multiplier: 1.0, constant: -sideMargin)
            } else {
                let nextButton = buttons[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: nextButton, attribute: .Left, multiplier: 1.0, constant: -spaceBetweenButtons)
                
            }
            rightConstraint.identifier = "Right Constraint for \(button.titleLabel!.text)"
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: mainView, attribute: .Left, multiplier: 1.0, constant: sideMargin)
                
                
            } else {
                
                let prevtButton = buttons[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: prevtButton, attribute: .Right, multiplier: 1.0, constant: spaceBetweenButtons)
                
                if index == 1 {
                    let spaceWidthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: . Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: spaceButtonWidth)
                    
                    mainView.addConstraint(spaceWidthConstraint)
                    spaceWidthConstraint.identifier = "Width Constraint for \(button.titleLabel!.text)"
                    
                } else if index == 2 {
                    let changeKeyboardButton = buttons[0]
                    let trumpWidthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: . Equal, toItem: changeKeyboardButton, attribute: .Width, multiplier: 1.0, constant: 0.0)
                    
                    mainView.addConstraint(trumpWidthConstraint)
                    trumpWidthConstraint.identifier = "Width Constraint for \(button.titleLabel!.text)"
                }
                
            }
            leftConstraint.identifier = "Left Constraint for \(button.titleLabel!.text)"
            
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
            
        }

    }
    
    func createButtonWithTitle() -> UIButton {
        let button = UIButton(type: .System) as UIButton         // exact size doesn't matter
        button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        button.addTarget(self, action: "didTapTextButton:", forControlEvents: .TouchUpInside)
        
        return button
    }
    
    func createChangeKeyboardButton() -> UIButton {
        let button = UIButton(type: .System) as UIButton
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor = navColor
        
        return button
    }
    
    func createSpaceButton() -> UIButton {
        let button = UIButton(type: .System) as UIButton
        button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.addTarget(self, action: "didPressSpace:", forControlEvents: .TouchUpInside)
        
        return button
    }
    
    func createTrumpButton() -> UIButton {
        let button = UIButton(type: .System) as UIButton
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor = navColor
        
        return button
    }
    
    func didTapTextButton(sender: AnyObject?) {
        
        let button = sender as! UIButton
        let title = button.titleForState(.Normal)
        activeTextField!.insertText(title!)
        
    }
    
    func didPressSpace(sender: AnyObject?) {
        activeTextField!.insertText(" ")
    }
    

}