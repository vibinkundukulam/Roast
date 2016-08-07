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
    
    var name = "" {
        didSet {
            checkWhetherNameEmpty()
            if cancelButton.hidden {
                trumpButtonDisabled(UIButton())
            } else {
                cancelImageView.tintColor = UIColor.grayColor()
                trumpButtonEnabled(UIButton())
            }
        }
    }
    var timer: NSTimer!
    var timecount: Int = 0
    let navColor = UIColor(red: 136/255, green: 5/255, blue: 5/255, alpha: 1.0)
    let activeColor = UIColor(red: 223/255, green: 122/255, blue: 128/255, alpha: 0.5)
    let trumpDisabledColor = UIColor(red: (170+136)/2/255, green: (5+170/2)/255, blue: (5+170)/2/255, alpha: 1.0)
    
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
    var cancelButton = UIButton()
    var trumpButton = UIButton()
    var activeButton = UIButton()
    
    // Creating image icons
    
    let changeKeyboardImageView = UIImageView(image: UIImage(named: "globe-white-vectorized"))
    let shiftImageView = UIImageView(image: UIImage(named: "shiftarrow-black")?.imageWithRenderingMode(.AlwaysTemplate))
    let deleteImageView = UIImageView(image: UIImage(named: "delete-white-vectorized"))
    let cancelImageView = UIImageView(image: UIImage(named: "cancel-black")?.imageWithRenderingMode(.AlwaysTemplate))
    
    func makeLowerCase(){
        for button in buttonsRowOne {
            button.setTitle(button.titleForState(.Normal)!.lowercaseString, forState: .Normal)
        }
        for button in buttonsRowTwo {
            button.setTitle(button.titleForState(.Normal)!.lowercaseString, forState: .Normal)
        }
        for button in buttonsRowThree {
            button.setTitle(button.titleForState(.Normal)!.lowercaseString, forState: .Normal)
        }
    }
    
    func makeCaps() {
        for button in buttonsRowOne {
            button.setTitle(button.titleForState(.Normal)!.uppercaseString, forState: .Normal)
        }
        for button in buttonsRowTwo {
            button.setTitle(button.titleForState(.Normal)!.uppercaseString, forState: .Normal)
        }
        for button in buttonsRowThree {
            button.setTitle(button.titleForState(.Normal)!.uppercaseString, forState: .Normal)
        }
    }
    
    func clearButtons() {
        buttonsRowOne.removeAll()
        buttonsRowTwo.removeAll()
        buttonsRowThree.removeAll()
    }
    
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
                button.layer.cornerRadius = 5
                button.translatesAutoresizingMaskIntoConstraints = false
                buttonsRowFour.append(button)
                keyboardRowView.addSubview(button)
            } else if index == 1 {
                button = createSpaceButton()
                button.layer.cornerRadius = 5
                button.translatesAutoresizingMaskIntoConstraints = false
                buttonsRowFour.append(button)
                keyboardRowView.addSubview(button)
            } else {
                trumpButton = createTrumpButton()
                trumpButton.layer.cornerRadius = 5
                trumpButton.translatesAutoresizingMaskIntoConstraints = false
                trumpButtonDisabled(UIButton())
                buttonsRowFour.append(trumpButton)
                keyboardRowView.addSubview(trumpButton)
            }
           
        }
    }
    
    func addCancelButton(inout nameEntryButton: UIButton!){
        cancelButton = UIButton(type: .System) as UIButton
        cancelImageView.translatesAutoresizingMaskIntoConstraints = false
        cancelImageView.contentMode = .ScaleAspectFit
        cancelButton.addSubview(cancelImageView)
        cancelImageView.tintColor = UIColor.grayColor()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        nameEntryButton.addSubview(cancelButton)
        
        cancelButton.addTarget(self, action: "clearName:", forControlEvents: .TouchUpInside)
        cancelButton.addTarget(self, action: "cancelButtonActive:", forControlEvents: .TouchDown)
        cancelButton.addTarget(self, action: "cancelButtonInactive:", forControlEvents: [.TouchDragExit, .TouchDragOutside])
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

    func addIndividualButtonConstraints(inout rowOneView: UIView!, inout rowTwoView: UIView!, inout rowThreeView: UIView!) {
        
        let sideMarginFirstRow = CGFloat(3)
        let spaceBetweenButtons = CGFloat(5)
        
        // Add constraints for first row
        
        for (index, button) in buttonsRowOne.enumerate() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: rowOneView, attribute: .Top, multiplier: 1.0, constant: sideMarginFirstRow)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: rowOneView, attribute: .Bottom, multiplier: 1.0, constant: -sideMarginFirstRow)
            
            var rightConstraint : NSLayoutConstraint!
            if index == buttonsRowOne.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: rowOneView, attribute: .Right, multiplier: 1.0, constant: -sideMarginFirstRow)
            } else {
                let nextButton = buttonsRowOne[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: nextButton, attribute: .Left, multiplier: 1.0, constant: -spaceBetweenButtons)
                
            }
            
            var leftConstraint : NSLayoutConstraint!
            var widthConstraint: NSLayoutConstraint!
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: rowOneView, attribute: .Left, multiplier: 1.0, constant: sideMarginFirstRow)
                
                
            } else {
                
                let prevtButton = buttonsRowOne[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: prevtButton, attribute: .Right, multiplier: 1.0, constant: spaceBetweenButtons)
                
                let firstButton = buttonsRowOne[0]
                widthConstraint = NSLayoutConstraint(item: firstButton, attribute: .Width, relatedBy: .Equal, toItem: button, attribute: .Width, multiplier: 1.0, constant: 0)
                
                rowOneView.addConstraint(widthConstraint)
                
            }
            
            
            rowOneView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
            
        }
        
        // Add constraints for second row
        
        for (index, button) in buttonsRowTwo.enumerate() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: rowTwoView, attribute: .Top, multiplier: 1.0, constant: sideMarginFirstRow)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: rowTwoView, attribute: .Bottom, multiplier: 1.0, constant: -sideMarginFirstRow)
            
            var rightConstraint : NSLayoutConstraint!
            if index == buttonsRowTwo.count - 1 {
                
            } else {
                let nextButton = buttonsRowTwo[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: nextButton, attribute: .Left, multiplier: 1.0, constant: -spaceBetweenButtons)
                
                self.addConstraint(rightConstraint)
                
            }
            
            var leftConstraint : NSLayoutConstraint!
            let widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: buttonsRowOne[0], attribute: .Width, multiplier: 1.0, constant: 0.0)
            
            if index == 0 {
                
            } else {
                
                let prevtButton = buttonsRowTwo[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: prevtButton, attribute: .Right, multiplier: 1.0, constant: spaceBetweenButtons)
                
                self.addConstraint(leftConstraint)
            }
            
            if index == 4 {
                
                let centerX = NSLayoutConstraint(item: button, attribute: .CenterX, relatedBy: .Equal, toItem: rowTwoView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
                
                rowTwoView.addConstraint(centerX)
                
            }
            
            self.addConstraints([topConstraint, bottomConstraint, widthConstraint])
            
        }
        
        // Add constraints for third row
        
        for (index, button) in buttonsRowThree.enumerate() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: rowThreeView, attribute: .Top, multiplier: 1.0, constant: sideMarginFirstRow)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: rowThreeView, attribute: .Bottom, multiplier: 1.0, constant: -sideMarginFirstRow)
            
            var rightConstraint : NSLayoutConstraint!
            if index == buttonsRowThree.count - 1 {
                
            } else {
                let nextButton = buttonsRowThree[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: nextButton, attribute: .Left, multiplier: 1.0, constant: -spaceBetweenButtons)
                
                self.addConstraint(rightConstraint)
                
            }
            
            var leftConstraint : NSLayoutConstraint!
            let widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: buttonsRowOne[0], attribute: .Width, multiplier: 1.0, constant: 0.0)
            
            if index == 0 {
                
            } else {
                
                let prevtButton = buttonsRowThree[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: prevtButton, attribute: .Right, multiplier: 1.0, constant: spaceBetweenButtons)
                
                self.addConstraint(leftConstraint)
            }
            
            if index == 3 {
                
                let centerX = NSLayoutConstraint(item: button, attribute: .CenterX, relatedBy: .Equal, toItem: rowThreeView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
                
                rowThreeView.addConstraint(centerX)
                
            }
            
            self.addConstraints([topConstraint, bottomConstraint, widthConstraint])
            
        }
        
        
     
      /*  
        func addIndividualButtonConstraints(inout buttons: [UIButton], mainView: UIView) {
        
        // Calculate spaces
        
        let numButtons = buttons.count
        let buttonWidth = mainView.bounds.width / 12
        let buttonSpace = CGFloat(numButtons) * buttonWidth
        let spaceBetweenButtons = buttonWidth / 5
        let spaceSpace = spaceBetweenButtons * (CGFloat(numButtons) - 1)
        let leftOverSpace = mainView.bounds.width - buttonSpace - spaceSpace
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
                
            }
            
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
            
        }
        buttons.removeAll()

    */
        
    }
    
    func addCancelButtonConstraints(nameEntryButton: UIButton) {
        
        // Add button constraints
        
        let rightConstraint = NSLayoutConstraint(item: cancelButton, attribute: .Right, relatedBy: .Equal, toItem: nameEntryButton, attribute: .Right, multiplier: 1.0, constant: -5.0)
        
        let centerY = NSLayoutConstraint(item: cancelButton, attribute: .CenterY, relatedBy: .Equal, toItem: nameEntryButton, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        let heightConstraint = NSLayoutConstraint(item: cancelButton, attribute: .Height, relatedBy: .Equal, toItem: nameEntryButton, attribute: .Height, multiplier: 1.0, constant: 0.0)
        
        let widthConstraint = NSLayoutConstraint(item: cancelButton, attribute: .Width, relatedBy: .Equal, toItem: nameEntryButton, attribute: .Height, multiplier: 1.0, constant: 0.0)
        
        nameEntryButton.addConstraints([rightConstraint, centerY, heightConstraint, widthConstraint])
        
        // Add image constraints
        
        let cancelImageHeight = NSLayoutConstraint(item: cancelImageView, attribute: .Height, relatedBy: .Equal, toItem: cancelButton, attribute: .Height, multiplier: 0.70, constant: 0)
        
        let cancelImageX = NSLayoutConstraint(item: cancelImageView, attribute: .CenterX, relatedBy: .Equal, toItem: cancelButton, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        
        let cancelImageY = NSLayoutConstraint(item: cancelImageView, attribute: .CenterY, relatedBy: .Equal, toItem: cancelButton, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        nameEntryButton.addConstraints([cancelImageHeight, cancelImageX, cancelImageY])
    }
    
    func addShiftButtonConstraints(mainView: UIView) {
        
        let sideMargin = CGFloat(3)
        let distanceToText = CGFloat(10)
        
        let topConstraint = NSLayoutConstraint(item: shiftButton, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1.0, constant: sideMargin)
        
        let bottomConstraint = NSLayoutConstraint(item: shiftButton, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1.0, constant: -sideMargin)
        
        let leftConstraint = NSLayoutConstraint(item: shiftButton, attribute: .Left, relatedBy: .Equal, toItem: mainView, attribute: .Left, multiplier: 1.0, constant: sideMargin)
        
        let rightConstraint = NSLayoutConstraint(item: shiftButton, attribute: .Right, relatedBy: . Equal, toItem: buttonsRowThree[0], attribute: .Left, multiplier: 1.0, constant: -distanceToText)
        
        self.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        
        // Add image constraints
        
        let heightShiftConstraint = NSLayoutConstraint(item: shiftImageView, attribute: .Height, relatedBy: .Equal, toItem: shiftButton, attribute: .Height, multiplier: 0.60, constant: 0)
        
        let xShiftConstraint = NSLayoutConstraint(item: shiftImageView, attribute: .CenterX, relatedBy: .Equal, toItem: shiftButton, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        
        let yShiftConstraint = NSLayoutConstraint(item: shiftImageView, attribute: .CenterY, relatedBy: .Equal, toItem: shiftButton, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        mainView.addConstraints([heightShiftConstraint, xShiftConstraint, yShiftConstraint])
        
       /* // Calculate side margin based off 10 buttons in the top row
        
        let sideMargin = (mainView.bounds.width - 10 * mainView.bounds.width / 12 - mainView.bounds.width / 60 * 9)/2
        
        // Calculate the button width
        
        let thirdRowSideMargin = (mainView.bounds.width - 7 * mainView.bounds.width / 12 - mainView.bounds.width / 60 * 6)/2
        let spaceBetweenButtons = mainView.bounds.width / 60
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

*/
    }
    
    func addDeleteButtonConstraints(mainView: UIView) {
        
        let sideMargin = CGFloat(3)
        let distanceToText = CGFloat(10)
        
        let topConstraint = NSLayoutConstraint(item: deleteButton, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1.0, constant: sideMargin)
        
        let bottomConstraint = NSLayoutConstraint(item: deleteButton, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1.0, constant: -sideMargin)
        
        let rightConstraint = NSLayoutConstraint(item: deleteButton, attribute: .Right, relatedBy: .Equal, toItem: mainView, attribute: .Right, multiplier: 1.0, constant: -sideMargin)
        
        let leftConstraint = NSLayoutConstraint(item: deleteButton, attribute: .Left, relatedBy: . Equal, toItem: buttonsRowThree[6], attribute: .Right, multiplier: 1.0, constant: distanceToText)
        
        self.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        
        // Add image constraints
        
        let heightDeleteConstraint = NSLayoutConstraint(item: deleteImageView, attribute: .Height, relatedBy: .Equal, toItem: deleteButton, attribute: .Height, multiplier: 0.80, constant: 0)
        
        let xDeleteConstraint = NSLayoutConstraint(item: deleteImageView, attribute: .CenterX, relatedBy: .Equal, toItem: deleteButton, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        
        let yDeleteConstraint = NSLayoutConstraint(item: deleteImageView, attribute: .CenterY, relatedBy: .Equal, toItem: deleteButton, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        mainView.addConstraints([heightDeleteConstraint, xDeleteConstraint, yDeleteConstraint])
    }
    
    func addFinalRowButtonConstraints(mainView: UIView) {
        
        let sideMargin = CGFloat(3)
        let distanceToText = CGFloat(10)
        
        for (index, button) in buttonsRowFour.enumerate() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1.0, constant: sideMargin)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1.0, constant: -sideMargin)
            
            var rightConstraint : NSLayoutConstraint!
            if index == 2 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: mainView, attribute: .Right, multiplier: 1.0, constant: -sideMargin)
            } else {
                let nextButton = buttonsRowFour[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: nextButton, attribute: .Left, multiplier: 1.0, constant: -distanceToText)
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
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: prevtButton, attribute: .Right, multiplier: 1.0, constant: distanceToText)
                
                if index == 1 {
                    let spaceWidthConstraint = NSLayoutConstraint(item: buttonsRowOne[0], attribute: .Width, relatedBy: . Equal, toItem: button, attribute: .Width, multiplier: 0.2, constant: 0)
                    
                    self.addConstraint(spaceWidthConstraint)
                    
                } else if index == 2 {
                    let changeKeyboardButton = buttonsRowFour[0]
                    let trumpWidthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: . Equal, toItem: changeKeyboardButton, attribute: .Width, multiplier: 1.0, constant: 0.0)
                    
                    mainView.addConstraint(trumpWidthConstraint)
                }
                
            }
            
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
            
        }

        
     /*   // Calculate spaces
        
        let numButtons = 10
        let textButtonWidth = mainView.bounds.width / 12
        let buttonSpace = CGFloat(numButtons) * textButtonWidth
        let spaceBetweenButtons = textButtonWidth / 5
        let spaceSpace = spaceBetweenButtons * (CGFloat(numButtons) - 1)
        let leftOverSpace = mainView.bounds.width - buttonSpace - spaceSpace
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
                    
                } else if index == 2 {
                    let changeKeyboardButton = buttonsRowFour[0]
                    let trumpWidthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: . Equal, toItem: changeKeyboardButton, attribute: .Width, multiplier: 1.0, constant: 0.0)
                    
                    mainView.addConstraint(trumpWidthConstraint)
                }
                
            }
            
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
            
        }
    */
    }
    
    func addButtonShadow(button: UIButton) {
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
        button.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
    }
    
    
    func createButtonWithTitle() -> UIButton {
        let button = UIButton(type: .Custom) as UIButton         // exact size doesn't matter
        button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        button.addTarget(self, action: "textButtonActive:", forControlEvents: .TouchDown)
        button.addTarget(self, action: "didTapTextButton:", forControlEvents: [.TouchUpInside, .TouchUpOutside])
        addButtonShadow(button)
        return button
    }
    
    func createShiftButton() -> UIButton {
        let button = UIButton(type: .Custom) as UIButton
        shiftImageView.translatesAutoresizingMaskIntoConstraints = false
        shiftImageView.contentMode = .ScaleAspectFit
        button.backgroundColor = navColor
        addButtonShadow(button)
        return button
    }
    
    func createDeleteButton() -> UIButton {
        let button = UIButton(type: .Custom) as UIButton
        deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        deleteImageView.contentMode = .ScaleAspectFit
        button.backgroundColor = navColor
        button.addTarget(self, action: "didPressDelete:", forControlEvents: .TouchDown)
        button.addTarget(self, action: "navButtonInactive:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragExit, .TouchDragOutside])
        addButtonShadow(button)
        return button
    }
    
    func createChangeKeyboardButton() -> UIButton {
        let button = UIButton(type: .Custom) as UIButton
        changeKeyboardImageView.translatesAutoresizingMaskIntoConstraints = false
        changeKeyboardImageView.contentMode = .ScaleAspectFit
        button.tintColor = UIColor.whiteColor()
        button.backgroundColor = navColor
        addButtonShadow(button)
        return button
    }
    
    func createSpaceButton() -> UIButton {
        let button = UIButton(type: .Custom) as UIButton
        button.setTitle("Space", forState: .Normal)
        button.titleLabel!.font = UIFont.systemFontOfSize(16)
        button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.addTarget(self, action: "didPressSpace:", forControlEvents: [.TouchUpInside, .TouchUpOutside])
        button.addTarget(self, action: "textButtonActive:", forControlEvents: .TouchDown)
        addButtonShadow(button)
        return button
    }
    
    func createTrumpButton() -> UIButton {
        let button = UIButton(type: .Custom) as UIButton
        button.setTitle("Change", forState: .Normal)
        button.titleLabel!.font = UIFont.systemFontOfSize(16)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor = trumpDisabledColor
        addButtonShadow(button)
        return button
    }
    
    func didTapTextButton(button: UIButton) {
        let letter = button.titleForState(.Normal)
        let oldLabel = activeButton.titleForState(.Normal)
        name = "\(oldLabel!)\(letter!)"
        activeButton.setTitle(name, forState: .Normal)
        button.backgroundColor = UIColor.whiteColor()
        
    }
    
    func didPressSpace(button: UIButton) {
        let oldLabel = activeButton.titleForState(.Normal)
        name = "\(oldLabel!) "
        activeButton.setTitle(name, forState: .Normal)
        button.backgroundColor = UIColor.whiteColor()
    }
    
    func didPressDelete(sender: AnyObject?) {
        let oldLabel = activeButton.titleForState(.Normal)
        if oldLabel!.characters.count > 0 {
            name = (oldLabel! as NSString).substringToIndex(oldLabel!.characters.count - 1)
            activeButton.setTitle(name, forState: .Normal)
        }
        deleteButton.backgroundColor = activeColor
        deleteButton.imageView!.tintColor = UIColor.blackColor()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "beginRapidDelete:", userInfo: nil, repeats: false)
    }
    
    func beginRapidDelete(sender: AnyObject?) {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "rapidDelete:", userInfo: nil, repeats: true)
    }
    
    func rapidDelete(sender: AnyObject?) {
        
        let oldLabel = activeButton.titleForState(.Normal)
        if oldLabel!.characters.count > 0 {
            name = (oldLabel! as NSString).substringToIndex(oldLabel!.characters.count - 1)
            activeButton.setTitle(name, forState: .Normal)
        }
        deleteButton.backgroundColor = activeColor
        deleteButton.imageView!.tintColor = UIColor.blackColor()
    }
    
    func checkWhetherNameEmpty() {
        if name == "" {
            cancelButton.hidden = true
        } else {
            cancelButton.hidden = false
        }
    }
    
    func clearName(sender: UIButton) {
        name = ""
        activeButton.setTitle(name, forState: .Normal)
    }
    
    func cancelButtonActive(sender: UIButton) {
        cancelImageView.tintColor = activeColor
    }
    
    func cancelButtonInactive(sender: UIButton) {
        cancelImageView.tintColor = UIColor.grayColor()
    }
    
    func navButtonInactive(button: UIButton) {
        button.backgroundColor = navColor
        timer.invalidate()
    }
    
    func textButtonActive(button: UIButton) {
        button.backgroundColor = activeColor
    }
    
    func trumpButtonEnabled(sender: UIButton) {
        trumpButton.enabled = true
        trumpButton.backgroundColor = navColor
    }
    
    func trumpButtonDisabled(sender: UIButton) {
        trumpButton.enabled = false
        trumpButton.backgroundColor = trumpDisabledColor
    }
    

}