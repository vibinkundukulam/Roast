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
    
    var didNameChange = false
    var oldName = ""
    var name = "" {
        didSet {
            checkWhetherNameEmpty()
            checkWhetherNameChanged()
            if !didNameChange && name == "" {
                trumpButtonDisabled(UIButton())
            } else {
                cancelImageView.tintColor = UIColor.gray
                trumpButtonEnabled(UIButton())
            }
            let nameAttributed = name as NSString
            let size: CGSize = nameAttributed.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)])
            cursorOffsetAmount = size.width
            offsetCursor(cursorOffsetAmount)
        }
    }
    
    // Cursor
    
    var cursor: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 10))
    var cursorOffsetAmount: CGFloat = CGFloat(0.0)
    var cursorLeft: NSLayoutConstraint!
    var timer: Timer!
    var cursorTimer: Timer!
    var timecount: Int = 0
    
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
    let shiftImageView = UIImageView(image: UIImage(named: "shiftarrow-black")?.withRenderingMode(.alwaysTemplate))
    let deleteImageView = UIImageView(image: UIImage(named: "delete-white-vectorized"))
    let cancelImageView = UIImageView(image: UIImage(named: "cancel-black")?.withRenderingMode(.alwaysTemplate))
    
    // Button constraint constants
    
    let sideMarginFirstRow = CGFloat(3)
    let sideMargin = CGFloat(3)
    let spaceBetweenButtons = CGFloat(6)
    let verticalMarginTop = CGFloat(4)
    let verticalMarginMiddleOne = CGFloat(6)
    let verticalMarginMiddleTwo = CGFloat (5)
    let verticalMarginBottom = CGFloat(3)
    let distanceToText = CGFloat(10)
    
    
    func offsetCursor(_ offset: CGFloat) {
        cursorLeft.constant = 10 + cursorOffsetAmount
    }
    
    func makeLowerCase(){
        for button in buttonsRowOne {
            button.setTitle(button.title(for: .normal)!.lowercased(), for: UIControlState())
        }
        for button in buttonsRowTwo {
            button.setTitle(button.title(for: .normal)!.lowercased(), for: UIControlState())
        }
        for button in buttonsRowThree {
            button.setTitle(button.title(for: .normal)!.lowercased(), for: UIControlState())
        }
    }
    
    func makeCaps() {
        for button in buttonsRowOne {
            button.setTitle(button.title(for: .normal)!.uppercased(), for: UIControlState())
        }
        for button in buttonsRowTwo {
            button.setTitle(button.title(for: .normal)!.uppercased(), for: UIControlState())
        }
        for button in buttonsRowThree {
            button.setTitle(button.title(for: .normal)!.uppercased(), for: UIControlState())
        }
    }
    
    func clearButtons() {
        buttonsRowOne.removeAll()
        buttonsRowTwo.removeAll()
        buttonsRowThree.removeAll()
    }
    
    func addCursorWithConstraints(_ nameView: inout UIView!, nameEntryButton: inout UIButton!) {
        cursor.translatesAutoresizingMaskIntoConstraints = false
        cursor.backgroundColor = UIColor.black
        nameView.addSubview(cursor)
        
        let centerY = NSLayoutConstraint(item: cursor, attribute: .centerY, relatedBy: .equal, toItem: nameEntryButton, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let height = NSLayoutConstraint(item: cursor, attribute: .height, relatedBy: .equal, toItem: nameEntryButton, attribute: .height, multiplier: 0.8, constant: 0.0)
        let width = NSLayoutConstraint(item: cursor, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0)
        cursorLeft = NSLayoutConstraint(item: cursor, attribute: .left, relatedBy: .equal, toItem: nameEntryButton, attribute: .left, multiplier: 1.0, constant: 10.0)
        
        nameView.addConstraints([centerY, height, width, cursorLeft])
    }
    
    func blinkCursor() {
        cursor.isHidden = !cursor.isHidden
    }
    
    func startCursorBlinking() {
        cursorTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(TextKeyboardView.blinkCursor), userInfo: nil, repeats: true)
    }
    
    func stopCursorBlinking() {
        cursorTimer.invalidate()
    }
    
    func addRowOfButtons(_ keyboardRowView: inout UIView!, buttonTitles: [String]) {
        
            for buttonTitle in buttonTitles {
                let button = createButtonWithTitle()
                button.setTitle(buttonTitle, for: UIControlState())
                button.titleLabel!.font = UIFont.systemFont(ofSize: 20)
                button.contentVerticalAlignment = .bottom
                button.setTitleColor(UIColor.black, for: UIControlState())
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
    
    func addFinalRowOfButtons(_ keyboardRowView: inout UIView!) {
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
    
    func addCancelButton(_ nameEntryButton: inout UIButton!){
        cancelButton = UIButton(type: .system) as UIButton
        cancelImageView.translatesAutoresizingMaskIntoConstraints = false
        cancelImageView.contentMode = .scaleAspectFit
        cancelButton.addSubview(cancelImageView)
        cancelImageView.tintColor = UIColor.gray
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        nameEntryButton.addSubview(cancelButton)
        
        cancelButton.addTarget(self, action: #selector(TextKeyboardView.clearName(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(TextKeyboardView.cancelButtonActive(_:)), for: .touchDown)
        cancelButton.addTarget(self, action: #selector(TextKeyboardView.cancelButtonInactive(_:)), for: [.touchDragExit, .touchDragOutside])
    }
    
    func addShiftButton(_ keyboardRowView: inout UIView!) {
        shiftButton = createShiftButton()
        shiftButton.addSubview(shiftImageView)
        shiftImageView.tintColor = UIColor.white
        shiftButton.layer.cornerRadius = 5
        shiftButton.translatesAutoresizingMaskIntoConstraints = false
        keyboardRowView.addSubview(shiftButton)
    }
    
    func addDeleteButton(_ keyboardRowView: inout UIView!) {
        deleteButton = createDeleteButton()
        deleteButton.addSubview(deleteImageView)
        deleteImageView.tintColor = UIColor.white
        deleteButton.layer.cornerRadius = 5
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        keyboardRowView.addSubview(deleteButton)
    }

    func addIndividualButtonConstraints(_ rowOneView: inout UIView!, rowTwoView: inout UIView!, rowThreeView: inout UIView!) {
        
        // Add constraints for first row
        
        for (index, button) in buttonsRowOne.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: rowOneView, attribute: .top, multiplier: 1.0, constant: verticalMarginTop)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: rowOneView, attribute: .bottom, multiplier: 1.0, constant: -verticalMarginMiddleOne)
            
            var rightConstraint : NSLayoutConstraint!
            if index == buttonsRowOne.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: rowOneView, attribute: .right, multiplier: 1.0, constant: -sideMarginFirstRow)
            } else {
                let nextButton = buttonsRowOne[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: nextButton, attribute: .left, multiplier: 1.0, constant: -spaceBetweenButtons)
                
            }
            
            var leftConstraint : NSLayoutConstraint!
            var widthConstraint: NSLayoutConstraint!
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: rowOneView, attribute: .left, multiplier: 1.0, constant: sideMarginFirstRow)
                
                
            } else {
                
                let prevtButton = buttonsRowOne[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: prevtButton, attribute: .right, multiplier: 1.0, constant: spaceBetweenButtons)
                
                let firstButton = buttonsRowOne[0]
                widthConstraint = NSLayoutConstraint(item: firstButton, attribute: .width, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1.0, constant: 0)
                
                rowOneView.addConstraint(widthConstraint)
                
            }
            
            
            rowOneView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
            
        }
        
        // Add constraints for second row
        
        for (index, button) in buttonsRowTwo.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: rowTwoView, attribute: .top, multiplier: 1.0, constant: verticalMarginMiddleOne)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: rowTwoView, attribute: .bottom, multiplier: 1.0, constant: -verticalMarginMiddleOne)
            
            var rightConstraint : NSLayoutConstraint!
            if index == buttonsRowTwo.count - 1 {
                
            } else {
                let nextButton = buttonsRowTwo[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: nextButton, attribute: .left, multiplier: 1.0, constant: -spaceBetweenButtons)
                
                self.addConstraint(rightConstraint)
                
            }
            
            var leftConstraint : NSLayoutConstraint!
            let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: buttonsRowOne[0], attribute: .width, multiplier: 1.0, constant: 0.0)
            
            if index == 0 {
                
            } else {
                
                let prevtButton = buttonsRowTwo[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: prevtButton, attribute: .right, multiplier: 1.0, constant: spaceBetweenButtons)
                
                self.addConstraint(leftConstraint)
            }
            
            if index == 4 {
                
                let centerX = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: rowTwoView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
                
                rowTwoView.addConstraint(centerX)
                
            }
            
            self.addConstraints([topConstraint, bottomConstraint, widthConstraint])
            
        }
        
        // Add constraints for third row
        
        for (index, button) in buttonsRowThree.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: rowThreeView, attribute: .top, multiplier: 1.0, constant: verticalMarginMiddleOne)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: rowThreeView, attribute: .bottom, multiplier: 1.0, constant: -verticalMarginMiddleTwo)
            
            var rightConstraint : NSLayoutConstraint!
            if index == buttonsRowThree.count - 1 {
                
            } else {
                let nextButton = buttonsRowThree[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: nextButton, attribute: .left, multiplier: 1.0, constant: -spaceBetweenButtons)
                
                self.addConstraint(rightConstraint)
                
            }
            
            var leftConstraint : NSLayoutConstraint!
            let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: buttonsRowOne[0], attribute: .width, multiplier: 1.0, constant: 0.0)
            
            if index == 0 {
                
            } else {
                
                let prevtButton = buttonsRowThree[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: prevtButton, attribute: .right, multiplier: 1.0, constant: spaceBetweenButtons)
                
                self.addConstraint(leftConstraint)
            }
            
            if index == 3 {
                
                let centerX = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: rowThreeView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
                
                rowThreeView.addConstraint(centerX)
                
            }
            
            self.addConstraints([topConstraint, bottomConstraint, widthConstraint])
            
        }
        
        
        
    }
    
    func addCancelButtonConstraints(_ nameEntryButton: UIButton) {
        
        // Add button constraints
        
        let rightConstraint = NSLayoutConstraint(item: cancelButton, attribute: .right, relatedBy: .equal, toItem: nameEntryButton, attribute: .right, multiplier: 1.0, constant: -5.0)
        
        let centerY = NSLayoutConstraint(item: cancelButton, attribute: .centerY, relatedBy: .equal, toItem: nameEntryButton, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        let heightConstraint = NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: nameEntryButton, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        let widthConstraint = NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: nameEntryButton, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        nameEntryButton.addConstraints([rightConstraint, centerY, heightConstraint, widthConstraint])
        
        // Add image constraints
        
        let cancelImageHeight = NSLayoutConstraint(item: cancelImageView, attribute: .height, relatedBy: .equal, toItem: cancelButton, attribute: .height, multiplier: 0.70, constant: 0)
        
        let cancelImageX = NSLayoutConstraint(item: cancelImageView, attribute: .centerX, relatedBy: .equal, toItem: cancelButton, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let cancelImageY = NSLayoutConstraint(item: cancelImageView, attribute: .centerY, relatedBy: .equal, toItem: cancelButton, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        nameEntryButton.addConstraints([cancelImageHeight, cancelImageX, cancelImageY])
    }
    
    func addShiftButtonConstraints(_ mainView: UIView) {
        
        let topConstraint = NSLayoutConstraint(item: shiftButton, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: verticalMarginMiddleOne)
        
        let bottomConstraint = NSLayoutConstraint(item: shiftButton, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: -verticalMarginMiddleTwo)
        
        let leftConstraint = NSLayoutConstraint(item: shiftButton, attribute: .left, relatedBy: .equal, toItem: mainView, attribute: .left, multiplier: 1.0, constant: sideMargin)
        
        let rightConstraint = NSLayoutConstraint(item: shiftButton, attribute: .right, relatedBy: . equal, toItem: buttonsRowThree[0], attribute: .left, multiplier: 1.0, constant: -distanceToText)
        
        self.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        
        // Add image constraints
        
        let heightShiftConstraint = NSLayoutConstraint(item: shiftImageView, attribute: .height, relatedBy: .equal, toItem: shiftButton, attribute: .height, multiplier: 0.60, constant: 0)
        
        let xShiftConstraint = NSLayoutConstraint(item: shiftImageView, attribute: .centerX, relatedBy: .equal, toItem: shiftButton, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let yShiftConstraint = NSLayoutConstraint(item: shiftImageView, attribute: .centerY, relatedBy: .equal, toItem: shiftButton, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        mainView.addConstraints([heightShiftConstraint, xShiftConstraint, yShiftConstraint])
        
        }
    
    func addDeleteButtonConstraints(_ mainView: UIView) {
        
        let topConstraint = NSLayoutConstraint(item: deleteButton, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: verticalMarginMiddleOne)
        
        let bottomConstraint = NSLayoutConstraint(item: deleteButton, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: -verticalMarginMiddleTwo)
        
        let rightConstraint = NSLayoutConstraint(item: deleteButton, attribute: .right, relatedBy: .equal, toItem: mainView, attribute: .right, multiplier: 1.0, constant: -sideMargin)
        
        let leftConstraint = NSLayoutConstraint(item: deleteButton, attribute: .left, relatedBy: . equal, toItem: buttonsRowThree[6], attribute: .right, multiplier: 1.0, constant: distanceToText)
        
        self.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        
        // Add image constraints
        
        let heightDeleteConstraint = NSLayoutConstraint(item: deleteImageView, attribute: .height, relatedBy: .equal, toItem: deleteButton, attribute: .height, multiplier: 0.80, constant: 0)
        
        let xDeleteConstraint = NSLayoutConstraint(item: deleteImageView, attribute: .centerX, relatedBy: .equal, toItem: deleteButton, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let yDeleteConstraint = NSLayoutConstraint(item: deleteImageView, attribute: .centerY, relatedBy: .equal, toItem: deleteButton, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        mainView.addConstraints([heightDeleteConstraint, xDeleteConstraint, yDeleteConstraint])
    }
    
    func addFinalRowButtonConstraints(_ mainView: UIView) {
        
        for (index, button) in buttonsRowFour.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: verticalMarginMiddleTwo)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: -verticalMarginBottom)
            
            var rightConstraint : NSLayoutConstraint!
            if index == 2 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: mainView, attribute: .right, multiplier: 1.0, constant: -sideMargin)
            } else {
                let nextButton = buttonsRowFour[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: nextButton, attribute: .left, multiplier: 1.0, constant: -distanceToText)
            }
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: mainView, attribute: .left, multiplier: 1.0, constant: sideMargin)
                
                // Globe constraints
                
                let heightGlobeConstraint = NSLayoutConstraint(item: changeKeyboardImageView, attribute: .height, relatedBy: .equal, toItem: button, attribute: .height, multiplier: 0.70, constant: 0)
                
                let xGlobeConstraint = NSLayoutConstraint(item: changeKeyboardImageView, attribute: .centerX, relatedBy: .equal, toItem: button, attribute: .centerX, multiplier: 1.0, constant: 0.0)
                
                let yGlobeConstraint = NSLayoutConstraint(item: changeKeyboardImageView, attribute: .centerY, relatedBy: .equal, toItem: button, attribute: .centerY, multiplier: 1.0, constant: 0.0)
                
                mainView.addConstraints([heightGlobeConstraint, xGlobeConstraint, yGlobeConstraint])
                
                
            } else {
                
                let prevtButton = buttonsRowFour[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: prevtButton, attribute: .right, multiplier: 1.0, constant: distanceToText)
                
                if index == 1 {
                    let spaceWidthConstraint = NSLayoutConstraint(item: buttonsRowOne[0], attribute: .width, relatedBy: . equal, toItem: button, attribute: .width, multiplier: 0.2, constant: 0)
                    
                    self.addConstraint(spaceWidthConstraint)
                    
                } else if index == 2 {
                    let changeKeyboardButton = buttonsRowFour[0]
                    let trumpWidthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: . equal, toItem: changeKeyboardButton, attribute: .width, multiplier: 1.0, constant: 0.0)
                    
                    mainView.addConstraint(trumpWidthConstraint)
                }
                
            }
            
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
            
        }

        
        }
    
    func addButtonShadow(_ button: UIButton) {
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
    }
    
    
    func createButtonWithTitle() -> UIButton {
        let button = UIButton(type: .custom) as UIButton         // exact size doesn't matter
        button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        button.addTarget(self, action: #selector(TextKeyboardView.textButtonActive(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(TextKeyboardView.didTapTextButton(_:)), for: [.touchUpInside, .touchUpOutside])
        addButtonShadow(button)
        return button
    }
    
    func createShiftButton() -> UIButton {
        let button = UIButton(type: .custom) as UIButton
        shiftImageView.translatesAutoresizingMaskIntoConstraints = false
        shiftImageView.contentMode = .scaleAspectFit
        button.backgroundColor = navColor
        addButtonShadow(button)
        return button
    }
    
    func createDeleteButton() -> UIButton {
        let button = UIButton(type: .custom) as UIButton
        deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        deleteImageView.contentMode = .scaleAspectFit
        button.backgroundColor = navColor
        button.addTarget(self, action: #selector(TextKeyboardView.didPressDelete(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(TextKeyboardView.navButtonInactive(_:)), for: [.touchUpInside, .touchUpOutside, .touchDragExit, .touchDragOutside])
        addButtonShadow(button)
        return button
    }
    
    func createChangeKeyboardButton() -> UIButton {
        let button = UIButton(type: .custom) as UIButton
        changeKeyboardImageView.translatesAutoresizingMaskIntoConstraints = false
        changeKeyboardImageView.contentMode = .scaleAspectFit
        button.tintColor = UIColor.white
        button.backgroundColor = navColor
        addButtonShadow(button)
        return button
    }
    
    func createSpaceButton() -> UIButton {
        let button = UIButton(type: .custom) as UIButton
        button.setTitle("Space", for: UIControlState())
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.addTarget(self, action: #selector(TextKeyboardView.didPressSpace(_:)), for: [.touchUpInside, .touchUpOutside])
        button.addTarget(self, action: #selector(TextKeyboardView.textButtonActive(_:)), for: .touchDown)
        addButtonShadow(button)
        return button
    }
    
    func createTrumpButton() -> UIButton {
        let button = UIButton(type: .custom) as UIButton
        button.setTitle("Replace", for: UIControlState())
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.backgroundColor = trumpDisabledColor
        addButtonShadow(button)
        return button
    }
    
    func didTapTextButton(_ button: UIButton) {
        let letter = button.title(for: UIControlState())
        let oldLabel = activeButton.title(for: UIControlState())
        name = "\(oldLabel!)\(letter!)"
        activeButton.setTitle(name, for: UIControlState())
        button.backgroundColor = UIColor.white
        
    }
    
    func didPressSpace(_ button: UIButton) {
        let oldLabel = activeButton.title(for: UIControlState())
        name = "\(oldLabel!) "
        activeButton.setTitle(name, for: UIControlState())
        button.backgroundColor = UIColor.white
    }
    
    func didPressDelete(_ sender: AnyObject?) {
        let oldLabel = activeButton.title(for: UIControlState())
        if oldLabel!.characters.count > 0 {
            name = (oldLabel! as NSString).substring(to: oldLabel!.characters.count - 1)
            activeButton.setTitle(name, for: UIControlState())
        }
        deleteButton.backgroundColor = activeColor
        deleteButton.imageView!.tintColor = UIColor.black
        
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(TextKeyboardView.beginRapidDelete(_:)), userInfo: nil, repeats: false)
    }
    
    func beginRapidDelete(_ sender: AnyObject?) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TextKeyboardView.rapidDelete(_:)), userInfo: nil, repeats: true)
    }
    
    func rapidDelete(_ sender: AnyObject?) {
        
        let oldLabel = activeButton.title(for: UIControlState())
        if oldLabel!.characters.count > 0 {
            name = (oldLabel! as NSString).substring(to: oldLabel!.characters.count - 1)
            activeButton.setTitle(name, for: UIControlState())
        }
        deleteButton.backgroundColor = activeColor
        deleteButton.imageView!.tintColor = UIColor.black
    }
    
    func checkWhetherNameEmpty() {
        if name == "" {
            cancelButton.isHidden = true
        } else {
            cancelButton.isHidden = false
        }
    }
    
    func checkWhetherNameChanged() {
        if name == oldName {
            didNameChange =  false
        } else {
            didNameChange = true
        }
    }
    
    func clearName(_ sender: UIButton) {
        name = ""
        activeButton.setTitle(name, for: UIControlState())
    }
    
    func cancelButtonActive(_ sender: UIButton) {
        cancelImageView.tintColor = activeColor
    }
    
    func cancelButtonInactive(_ sender: UIButton) {
        cancelImageView.tintColor = UIColor.gray
    }
    
    func navButtonInactive(_ button: UIButton) {
        button.backgroundColor = navColor
        timer.invalidate()
    }
    
    func textButtonActive(_ button: UIButton) {
        button.backgroundColor = activeColor
    }
    
    func trumpButtonEnabled(_ sender: UIButton) {
        trumpButton.isEnabled = true
        trumpButton.backgroundColor = navColor
    }
    
    func trumpButtonDisabled(_ sender: UIButton) {
        trumpButton.isEnabled = false
        trumpButton.backgroundColor = trumpDisabledColor
    }
    

}
