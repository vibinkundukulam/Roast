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
    var activeButton: UIButton!
    var timer: NSTimer!
    var timecount: Int = 0
    let navColor = UIColor(red: 136/255, green: 5/255, blue: 5/255, alpha: 1.0)
    let activeColor = UIColor(red: 223/255, green: 122/255, blue: 128/255, alpha: 0.5)
    
    // Creating buttons for text keyboard
    
    let buttonTitlesRowOne = ["q","w","e","r","t","y","u","i","o","p"]
    let buttonTitlesRowTwo = ["a","s","d","f","g","h","j","k","l"]
    let buttonTitlesRowThree = ["z","x","c","v","b","n","m"]
    let shiftedButtonTitlesRowOne = ["Q","W","E","R","T","Y","U","I","O","P"]
    let shiftedButtonTitlesRowTwo = ["A","S","D","F","G","H","J","K","L"]
    let shiftedButtonTitlesRowThree = ["Z","X","C","V","B","N","M"]
    var buttonsRowOne = [UIButton]()
    var buttonsRowTwo = [UIButton]()
    var buttonsRowThree = [UIButton]()
    var buttonsRowFour = [UIButton]()
    var shiftButton = UIButton()
    var deleteButton = UIButton()
    
    // Creating image icons
    
    let changeKeyboardImageView = UIImageView(image: UIImage(named: "globe-white-vectorized"))
    let shiftImageView = UIImageView(image: UIImage(named: "shiftarrow-black")?.imageWithRenderingMode(.AlwaysTemplate))
    let deleteImageView = UIImageView(image: UIImage(named: "delete-white-vectorized"))
    
    
    func addRowOfButtons(inout keyboardRowView: UIView!, buttonTitles: [String]) {
            for buttonTitle in buttonTitles {
                let button = createButtonWithTitle()
                button.setTitle(buttonTitle, forState: .Normal)
                button.titleLabel!.font = UIFont.systemFontOfSize(16)
                button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                button.layer.cornerRadius = 5
                button.translatesAutoresizingMaskIntoConstraints = false
                if buttonTitles == buttonTitlesRowOne {
                    buttonsRowOne.append(button)
                } else if buttonTitles == buttonTitlesRowTwo {
                    buttonsRowTwo.append(button)
                } else if buttonTitles == buttonTitlesRowThree {
                    buttonsRowThree.append(button)
                } else if buttonTitles == shiftedButtonTitlesRowOne {
                    buttonsRowOne.append(button)
                } else if buttonTitles == shiftedButtonTitlesRowTwo {
                    buttonsRowTwo.append(button)
                } else if buttonTitles == shiftedButtonTitlesRowThree {
                    buttonsRowThree.append(button)
                }
                keyboardRowView.addSubview(button)
            }
 
    }
    
    func addFinalRowOfButtons(inout keyboardRowView: UIView!) {
        var button: UIButton
        for index in 0...2 {
            if index == 0 {
                button = createChangeKeyboardButton()
                button.addSubview(changeKeyboardImageView)
            } else if index == 1 {
                button = createSpaceButton()
            } else {
                button = createTrumpButton()
            }
            button.layer.cornerRadius = 5
            button.translatesAutoresizingMaskIntoConstraints = false
            buttonsRowFour.append(button)
            keyboardRowView.addSubview(button)
        }
        
        
    }
    
    func addShiftButton(inout keyboardRowView: UIView!) {
        shiftButton = createShiftButton()
        shiftButton.addSubview(shiftImageView)
        shiftImageView.tintColor = UIColor.whiteColor()
        shiftButton.layer.cornerRadius = 5
        shiftButton.translatesAutoresizingMaskIntoConstraints = false
        keyboardRowView.addSubview(shiftButton)
    }
    
    func addDeleteButton(inout keyboardRowView: UIView!) {
        deleteButton = createDeleteButton()
        deleteButton.addSubview(deleteImageView)
        deleteImageView.tintColor = UIColor.whiteColor()
        deleteButton.layer.cornerRadius = 5
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        keyboardRowView.addSubview(deleteButton)
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
    
    func addShiftButtonConstraints(mainView: UIView) {
        
        // Calculate side margin based off 10 buttons in the top row
        
        let sideMargin = (mainView.frame.width - 10 * mainView.frame.width / 12 - mainView.frame.width / 60 * 9)/2
        
        // Calculate the button width
        
        let thirdRowSideMargin = (mainView.frame.width - 7 * mainView.frame.width / 12 - mainView.frame.width / 60 * 6)/2
        let spaceBetweenButtons = mainView.frame.width / 60
        let actualButtonWidth = thirdRowSideMargin - spaceBetweenButtons - sideMargin
        
        let topConstraint = NSLayoutConstraint(item: shiftButton, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1.0, constant: 3)
        
        let bottomConstraint = NSLayoutConstraint(item: shiftButton, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1.0, constant: -3)
        
        let leftConstraint = NSLayoutConstraint(item: shiftButton, attribute: .Left, relatedBy: .Equal, toItem: mainView, attribute: .Left, multiplier: 1.0, constant: sideMargin)

        let widthConstraint = NSLayoutConstraint(item: shiftButton, attribute: .Width, relatedBy: . Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: actualButtonWidth)
            
        mainView.addConstraints([topConstraint, bottomConstraint, leftConstraint, widthConstraint])
        
        // Add image constraints
        
        let heightShiftConstraint = NSLayoutConstraint(item: shiftImageView, attribute: .Height, relatedBy: .Equal, toItem: shiftButton, attribute: .Height, multiplier: 0.60, constant: 0)
        
        let xShiftConstraint = NSLayoutConstraint(item: shiftImageView, attribute: .CenterX, relatedBy: .Equal, toItem: shiftButton, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        
        let yShiftConstraint = NSLayoutConstraint(item: shiftImageView, attribute: .CenterY, relatedBy: .Equal, toItem: shiftButton, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        mainView.addConstraints([heightShiftConstraint, xShiftConstraint, yShiftConstraint])
    }
    
    func addDeleteButtonConstraints(mainView: UIView) {
        
        // Calculate side margin based off 10 buttons in the top row
        
        let sideMargin = (mainView.frame.width - 10 * mainView.frame.width / 12 - mainView.frame.width / 60 * 9)/2
        
        // Calculate the button width
        
        let thirdRowSideMargin = (mainView.frame.width - 7 * mainView.frame.width / 12 - mainView.frame.width / 60 * 6)/2
        let spaceBetweenButtons = mainView.frame.width / 60
        let actualButtonWidth = thirdRowSideMargin - spaceBetweenButtons - sideMargin
        
        let topConstraint = NSLayoutConstraint(item: deleteButton, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1.0, constant: 3)
        
        let bottomConstraint = NSLayoutConstraint(item: deleteButton, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1.0, constant: -3)
        
        let rightConstraint = NSLayoutConstraint(item: deleteButton, attribute: .Right, relatedBy: .Equal, toItem: mainView, attribute: .Right, multiplier: 1.0, constant: -sideMargin)
        
        let widthConstraint = NSLayoutConstraint(item: deleteButton, attribute: .Width, relatedBy: . Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: actualButtonWidth)
        
        mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, widthConstraint])
        
        // Add image constraints
        
        let heightDeleteConstraint = NSLayoutConstraint(item: deleteImageView, attribute: .Height, relatedBy: .Equal, toItem: deleteButton, attribute: .Height, multiplier: 0.80, constant: 0)
        
        let xDeleteConstraint = NSLayoutConstraint(item: deleteImageView, attribute: .CenterX, relatedBy: .Equal, toItem: deleteButton, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        
        let yDeleteConstraint = NSLayoutConstraint(item: deleteImageView, attribute: .CenterY, relatedBy: .Equal, toItem: deleteButton, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        mainView.addConstraints([heightDeleteConstraint, xDeleteConstraint, yDeleteConstraint])
    }
    
    func addFinalRowButtonConstraints(mainView: UIView) {
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
        
        for (index, button) in buttonsRowFour.enumerate() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1.0, constant: 3)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1.0, constant: -3)
            
            var rightConstraint : NSLayoutConstraint!
            if index == buttonsRowFour.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: mainView, attribute: .Right, multiplier: 1.0, constant: -sideMargin)
            } else {
                let nextButton = buttonsRowFour[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: nextButton, attribute: .Left, multiplier: 1.0, constant: -spaceBetweenButtons)
                
            }
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: mainView, attribute: .Left, multiplier: 1.0, constant: sideMargin)
                
                // Globe constraints
                
                let heightGlobeConstraint = NSLayoutConstraint(item: changeKeyboardImageView, attribute: .Height, relatedBy: .Equal, toItem: button, attribute: .Height, multiplier: 0.70, constant: 0)
                
                let xGlobeConstraint = NSLayoutConstraint(item: changeKeyboardImageView, attribute: .CenterX, relatedBy: .Equal, toItem: button, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
                
                 let yGlobeConstraint = NSLayoutConstraint(item: changeKeyboardImageView, attribute: .CenterY, relatedBy: .Equal, toItem: button, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
                
                mainView.addConstraints([heightGlobeConstraint, xGlobeConstraint, yGlobeConstraint])
                
                
            } else {
                
                let prevtButton = buttonsRowFour[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: prevtButton, attribute: .Right, multiplier: 1.0, constant: spaceBetweenButtons)
                
                if index == 1 {
                    let spaceWidthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: . Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: spaceButtonWidth)
                    
                    mainView.addConstraint(spaceWidthConstraint)
                    spaceWidthConstraint.identifier = "Width Constraint for \(button.titleLabel!.text)"
                    
                } else if index == 2 {
                    let changeKeyboardButton = buttonsRowFour[0]
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
        button.addTarget(self, action: "textButtonActive:", forControlEvents: .TouchDown)
        button.addTarget(self, action: "didTapTextButton:", forControlEvents: [.TouchUpInside, .TouchUpOutside])
        
        return button
    }
    
    func createShiftButton() -> UIButton {
        let button = UIButton(type: .System) as UIButton
        shiftImageView.translatesAutoresizingMaskIntoConstraints = false
        shiftImageView.contentMode = .ScaleAspectFit
        button.backgroundColor = navColor
        return button
    }
    
    func createDeleteButton() -> UIButton {
        let button = UIButton(type: .System) as UIButton
        deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        deleteImageView.contentMode = .ScaleAspectFit
        button.backgroundColor = navColor
        button.addTarget(self, action: "didPressDelete:", forControlEvents: .TouchDown)
        button.addTarget(self, action: "navButtonInactive:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragExit, .TouchDragOutside])
        
        return button
    }
    
    func createChangeKeyboardButton() -> UIButton {
        let button = UIButton(type: .System) as UIButton
        changeKeyboardImageView.translatesAutoresizingMaskIntoConstraints = false
        changeKeyboardImageView.contentMode = .ScaleAspectFit
        button.tintColor = UIColor.whiteColor()
        button.backgroundColor = navColor
        
        return button
    }
    
    func createSpaceButton() -> UIButton {
        let button = UIButton(type: .System) as UIButton
        button.setTitle("Space", forState: .Normal)
        button.titleLabel!.font = UIFont.systemFontOfSize(16)
        button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.addTarget(self, action: "didPressSpace:", forControlEvents: [.TouchUpInside, .TouchUpOutside])
        button.addTarget(self, action: "textButtonActive:", forControlEvents: .TouchDown)
        return button
    }
    
    func createTrumpButton() -> UIButton {
        let button = UIButton(type: .System) as UIButton
        button.setTitle("Trump 'Em", forState: .Normal)
        button.titleLabel!.font = UIFont.systemFontOfSize(16)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor = navColor
        
        return button
    }
    
    func didTapTextButton(button: UIButton) {
        let letter = button.titleForState(.Normal)
        let oldLabel = activeButton!.titleForState(.Normal)
        activeButton!.setTitle("\(oldLabel!)\(letter!)", forState: .Normal)
        button.backgroundColor = UIColor.whiteColor()
        
    }
    
    func didPressSpace(button: UIButton) {
        let oldLabel = activeButton!.titleForState(.Normal)
        activeButton!.setTitle("\(oldLabel!) ", forState: .Normal)
        button.backgroundColor = UIColor.whiteColor()
    }
    
    func didPressDelete(sender: AnyObject?) {
        let oldLabel = activeButton!.titleForState(.Normal)
        if oldLabel!.characters.count > 0 {
            let oldLabelDeleted = (oldLabel! as NSString).substringToIndex(oldLabel!.characters.count - 1)
            activeButton!.setTitle("\(oldLabelDeleted)", forState: .Normal)
        }
        deleteButton.backgroundColor = activeColor
        deleteButton.imageView!.tintColor = UIColor.blackColor()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "beginRapidDelete:", userInfo: nil, repeats: false)
    }
    
    func beginRapidDelete(sender: AnyObject?) {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "rapidDelete:", userInfo: nil, repeats: true)
    }
    
    func rapidDelete(sender: AnyObject?) {
        
        let oldLabel = activeButton!.titleForState(.Normal)
        if oldLabel!.characters.count > 0 {
            let oldLabelDeleted = (oldLabel! as NSString).substringToIndex(oldLabel!.characters.count - 1)
            activeButton!.setTitle("\(oldLabelDeleted)", forState: .Normal)
        }
        deleteButton.backgroundColor = activeColor
        deleteButton.imageView!.tintColor = UIColor.blackColor()
    }
    
    func navButtonInactive(button: UIButton) {
        button.backgroundColor = navColor
        timer.invalidate()
    }
    
    func textButtonActive(button: UIButton) {
        button.backgroundColor = activeColor
    }
    

}