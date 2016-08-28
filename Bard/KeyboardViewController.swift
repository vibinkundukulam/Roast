//
//  KeyboardViewController.swift
//  Bard
//
//  Created by Test Account on 7/14/15.
//  Copyright (c) 2015 Vibin Kundukulam. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

class KeyboardViewController: UIInputViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIApplicationDelegate {
    
    // Table constraints
    
    @IBOutlet var categoryTableViewHeaderTop: NSLayoutConstraint!
    @IBOutlet var categoryTableViewHeaderBottom: NSLayoutConstraint!
    var expandedCategoryTableViewHeaderTopConstraint: NSLayoutConstraint? = nil
    var expandedChooseQuoteViewBottomConstraint: NSLayoutConstraint? = nil
    
    // Text keyboard
    
    @IBOutlet weak var textKeyboardView: TextKeyboardView!
    @IBOutlet weak var textKeyboardRowOne: UIView!
    @IBOutlet weak var textKeyboardRowTwo: UIView!
    @IBOutlet weak var textKeyboardRowThree: UIView!
    @IBOutlet weak var textKeyboardRowFour: UIView!
    
    @IBOutlet weak var nextKeyboard: UIButton!
    
    
    // Name input
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameEntryButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backButton: Draw2D!
    @IBOutlet weak var nameEntryButtonLeft: NSLayoutConstraint!
    
    // Share button
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareButtonImage: UIImageView!
    
    
    
    
    // Choose quote
    
    @IBOutlet weak var chooseQuoteView: UIView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var categoryHeader: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var expandCategoryButton: UIButton!
    @IBOutlet var categoryHeaderBorderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryHeaderBorderView: UIView!
    var newCategoryHeaderBorderViewHeight: NSLayoutConstraint? = nil
    
    // Ensure keyboard remembers last key, quote, name
    
    var lastRow = -1
    var lastCategorySelected = ""   // Last category whose quote was used
    var lastQuote = ""
    var currentCategoryDisplayed = ""   // The current category the user is viewing
    var sectionExpanded = false
    var name = ""
    var shiftButtonPressed = false
    var textChangeCount = 0
    
    
    // Color scheme
    
    let navColor = UIColor(red: 136/255, green: 5/255, blue: 5/255, alpha: 1.0)
    let activeColor = UIColor(red: 223/255, green: 122/255, blue: 128/255, alpha: 1.0)
    let quoteColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    let borderColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0).CGColor
    let textColor = UIColor.blackColor()
    let textInactiveColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
    
    var inactiveTextAttributes: [String: NSObject] {
        get {
            return [NSFontAttributeName : UIFont(name: "HelveticaNeue-Italic", size: 12)!,NSForegroundColorAttributeName : textInactiveColor]
        }
    }
    
    var subtitleAttributes: [String: NSObject] {
        get {
            return [NSFontAttributeName : UIFont(name: "HelveticaNeue-Italic", size: 14)!,NSForegroundColorAttributeName : textColor]
        }
    }
    
    var normalAttributes: [String: NSObject] {
        get {
            return [NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 14)!,NSForegroundColorAttributeName : textColor]
        }
    }
    
    // Creating initial arrays to hold quotes
    
    var crookedArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var weakArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var uglyArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var manipulativeArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var crazyArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var sleazyArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var poorArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var meanArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var softArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var embarassmentArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var loserArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var unpopularArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var incompetentArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var dummyArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var talkingtoomuchArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var wrongArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var bestquotesArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var cluelessArray: [(NSMutableAttributedString, NSAttributedString)] = []
    
    var buttonTitles = Dictionary<String,[(NSMutableAttributedString, NSAttributedString)]>()
    
    var shareAppArray: [NSMutableAttributedString] = []
    
    
    //
    //
    // Load everything when the keyboard first pops up
    //
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createInsultsWithoutName()
        
        let nib = UINib(nibName: "View", bundle: nil)
        let objects = nib.instantiateWithOwner(self, options: nil)
        view = objects[0] as! UIView;

        var categoryArray = Array(self.buttonTitles.keys).sort(<)
        currentCategoryDisplayed = categoryArray[0]
        nameEntryButton.setTitle("", forState: .Normal)
        createShareQuotesWithoutName()
        
        // Set up name entry text field
        
        nameEntryButton.layer.borderColor = borderColor
        nameEntryButton.layer.cornerRadius = 10
        nameEntryButton.layer.borderWidth = 1
        nameEntryButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)
        nameEntryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        nameEntryButton.addTarget(self, action: #selector(KeyboardViewController.nameEntryButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        nameLabel.attributedText = NSAttributedString(string: "Replace name...", attributes: inactiveTextAttributes)
        showNameLabel()
        
        
        // Set up textKeyboard
        
        textKeyboardView.addCancelButton(&nameEntryButton)
        textKeyboardView.addCancelButtonConstraints(nameEntryButton)
        textKeyboardView.cancelButton.hidden = true
        
        textKeyboardView.addCursorWithConstraints(&nameView, nameEntryButton: &nameEntryButton)
        textKeyboardView.cursor.hidden = true
        
        self.view.autoresizesSubviews = true
        
        
        self.view.setNeedsLayout()
        self.textKeyboardRowOne.setNeedsLayout()
        self.textKeyboardRowTwo.setNeedsLayout()
        self.textKeyboardRowThree.setNeedsLayout()
        self.textKeyboardRowFour.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        shareButton.addTarget(self, action: #selector(KeyboardViewController.shareApp(_:)), forControlEvents: .TouchUpInside)
        shareButton.addTarget(self, action: #selector(KeyboardViewController.shareButtonActive(_:)), forControlEvents: .TouchDown)
        shareButton.addTarget(self, action: #selector(KeyboardViewController.shareButtonInactive(_:)), forControlEvents: [.TouchDragExit, .TouchDragOutside])
        
        backButton.addTarget(self, action: #selector(KeyboardViewController.nameEntryButtonOldName(_:)), forControlEvents: .TouchUpInside)
        backButton.addTarget(self, action: #selector(KeyboardViewController.buttonActive(_:)), forControlEvents: .TouchDown)
        backButton.addTarget(self, action: #selector(KeyboardViewController.buttonInactive(_:)), forControlEvents: [.TouchDragExit, .TouchDragOutside])
        
        textKeyboardView.addRowOfButtons(&textKeyboardRowOne, buttonTitles: textKeyboardView.buttonTitlesRowOne)
        textKeyboardView.addRowOfButtons(&textKeyboardRowTwo, buttonTitles: textKeyboardView.buttonTitlesRowTwo)
        textKeyboardView.addRowOfButtons(&textKeyboardRowThree, buttonTitles: textKeyboardView.buttonTitlesRowThree)
        textKeyboardView.addFinalRowOfButtons(&textKeyboardRowFour)
        
        textKeyboardView.addShiftButton(&textKeyboardRowThree)
        textKeyboardView.addDeleteButton(&textKeyboardRowThree)
        textKeyboardView.addIndividualButtonConstraints(&textKeyboardRowOne, rowTwoView: &textKeyboardRowTwo, rowThreeView: &textKeyboardRowThree)
        textKeyboardView.addFinalRowButtonConstraints(textKeyboardRowFour)
        textKeyboardView.addShiftButtonConstraints(textKeyboardRowThree)
        textKeyboardView.addDeleteButtonConstraints(textKeyboardRowThree)
        
        textKeyboardView.buttonsRowFour[0].addTarget(self, action: #selector(KeyboardViewController.nextKeyboardPressed(_:)), forControlEvents: .TouchUpInside)
        textKeyboardView.buttonsRowFour[0].addTarget(self, action: #selector(KeyboardViewController.navButtonActive(_:)), forControlEvents: .TouchDown)
        textKeyboardView.buttonsRowFour[0].addTarget(self, action: #selector(KeyboardViewController.navButtonInactive(_:)), forControlEvents: [.TouchDragExit, .TouchDragOutside])
        
        textKeyboardView.buttonsRowFour[2].addTarget(self, action: #selector(KeyboardViewController.navButtonActive(_:)), forControlEvents: .TouchDown)
        textKeyboardView.buttonsRowFour[2].addTarget(self, action: #selector(KeyboardViewController.navButtonInactive(_:)), forControlEvents: [.TouchDragExit, .TouchDragOutside])
        textKeyboardView.buttonsRowFour[2].addTarget(self, action: #selector(KeyboardViewController.nameEntryButtonNewName(_:)), forControlEvents: .TouchUpInside)
        textKeyboardView.buttonsRowFour[2].addTarget(self, action: #selector(KeyboardViewController.navButtonInactive(_:)), forControlEvents: .TouchUpInside)
        
        textKeyboardView.shiftButton.addTarget(self, action: #selector(KeyboardViewController.shiftButtonPressed(_:)), forControlEvents: .TouchDown)
        
        backButton.hidden = true
        textKeyboardView.hidden = true
        
        
        // Set up table of quotes and categories
        
        tableView1.delegate = self
        tableView1.dataSource = self
        
        tableView2.delegate = self
        tableView2.dataSource = self
        
        
        // Quotes
        
        tableView1.rowHeight = UITableViewAutomaticDimension
        tableView1.estimatedRowHeight = 30
        tableView1.registerClass(UITableViewCell.self,forCellReuseIdentifier: "cell")
        tableView1.backgroundColor = quoteColor
        tableView1.separatorColor = UIColor.clearColor()
        
        
        // Categories
        
        tableView2.rowHeight = UITableViewAutomaticDimension
        tableView2.estimatedRowHeight = 30
        tableView2.registerClass(UITableViewCell.self,forCellReuseIdentifier: "cell2")
        tableView2.backgroundColor = navColor
        categoryLabel.text = currentCategoryDisplayed
        
        let selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView2.selectRowAtIndexPath(selectedIndexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        
        nextKeyboard.addTarget(self, action: #selector(KeyboardViewController.navButtonActive(_:)), forControlEvents: .TouchDown)
        nextKeyboard.addTarget(self, action: #selector(KeyboardViewController.navButtonInactive(_:)), forControlEvents: [.TouchDragExit, .TouchDragOutside])
        nextKeyboard.addTarget(self, action: #selector(KeyboardViewController.nextKeyboardPressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    //
    //
    // End of view loading method
    //
    //
    
    
    
    func nameEntryButtonPressed(button: UIButton) {
        
        backButton.backgroundColor = UIColor.whiteColor()
        nameLabel.hidden = true
        chooseQuoteView.hidden = true
        shareButton.hidden = true
        shareButtonImage.hidden = true
        categoryHeader.hidden = true
        
        backButton.hidden = false
        textKeyboardView.hidden = false
        textKeyboardView.cursor.hidden = false
        textKeyboardView.startCursorBlinking()

        
        if nameEntryButton.titleForState(.Normal) == "" {
            textKeyboardView.cancelButton.hidden = true
        } else {
            textKeyboardView.cancelButton.hidden = false
        }
        
        self.nameView.layoutIfNeeded()
        nameEntryButton.layer.borderColor = navColor.CGColor

        textKeyboardView.activeButton = nameEntryButton
        name = textKeyboardView.activeButton.titleForState(.Normal)!
        textKeyboardView.didNameChange = false
        textKeyboardView.oldName = name
        
        if !textKeyboardView.didNameChange && textKeyboardView.name == "" {
            textKeyboardView.trumpButtonDisabled(UIButton())
        }


    }
    
    func shiftButtonPressed(sender: AnyObject?) {
        if shiftButtonPressed {
            
            textKeyboardView.makeLowerCase()
            
            textKeyboardView.shiftButton.backgroundColor = navColor
            textKeyboardView.shiftImageView.tintColor = UIColor.whiteColor()

            
        } else {
            
            textKeyboardView.makeCaps()
            
            textKeyboardView.shiftButton.backgroundColor = activeColor
            textKeyboardView.shiftImageView.tintColor = UIColor.blackColor()
        }
        
        shiftButtonPressed = !shiftButtonPressed
    }
    
    func nameEntryButtonNewName(sender: AnyObject?) {
        name = textKeyboardView.activeButton.titleForState(.Normal)!
        nameEntryButtonDidEndEditing(UIButton())
        lastRow = -2
        tableView1.reloadData()
    }
    
    func nameEntryButtonOldName(sender: AnyObject?) {
        textKeyboardView.activeButton.setTitle(name, forState: .Normal)
        textKeyboardView.name = textKeyboardView.activeButton.titleForState(.Normal)!
        nameEntryButtonDidEndEditing(UIButton())
    }
    
    func nameEntryButtonDidEndEditing(sender: AnyObject?) {
        
        nameEntryButton.layer.borderColor = borderColor
        textKeyboardView.hidden = true
        backButton.hidden = true
        textKeyboardView.cursor.hidden = true
        textKeyboardView.stopCursorBlinking()
        chooseQuoteView.hidden = false
        shareButton.hidden = false
        shareButtonImage.hidden = false
        categoryHeader.hidden = false
        showNameLabel()
        
        if name == "" {
            createInsultsWithoutName()
            createShareQuotesWithoutName()
        } else {
            createInsultsWithName()
            createShareQuotesWithName()
        }
        
        textKeyboardView.cancelButton.hidden = true
        

    }
    
    func shareApp(button: UIButton){
        let randomIndex = Int(arc4random_uniform(UInt32(shareAppArray.count)))
        let string = shareAppArray[randomIndex].string
        var allTextBefore: String
        if let string = textDocumentProxy.documentContextBeforeInput {
            allTextBefore = string
        } else {
            allTextBefore = ""
        }
        
        let allTextBeforeLength = allTextBefore.characters.count
        let lastStringLength = lastQuote.characters.count
        var stringToCheck: String?
        
        if allTextBeforeLength <= lastStringLength {
            let indexToCheckFrom = allTextBefore.startIndex
            stringToCheck = allTextBefore.substringFromIndex(indexToCheckFrom)
        } else {
            let indexToCheckFrom = allTextBefore.endIndex.advancedBy(-lastStringLength)
            stringToCheck = allTextBefore.substringFromIndex(indexToCheckFrom)
        }
        
        if lastRow != -1 {
            
            if stringToCheck == lastQuote {
                deleteBackwardRepeat(lastStringLength)
            }
            
            
            if lastRow == -3 {
                shareButtonImage.image = UIImage(named: "share-gray")
                lastRow = -1
                lastCategorySelected = ""
                lastQuote = ""
            } else {
                if lastCategorySelected == currentCategoryDisplayed {
                    self.tableView1.deselectRowAtIndexPath(NSIndexPath(forRow: lastRow, inSection: 0), animated: false)
                    lastRow = -1
                    lastCategorySelected = ""
                    lastQuote = ""
                }
                (textDocumentProxy as UIKeyInput).insertText("\(string)")
                lastRow = -3
                lastCategorySelected = ""
                lastQuote = shareAppArray[randomIndex].string
            }
            
        } else {
            (textDocumentProxy as UIKeyInput).insertText("\(string)")
            lastRow = -3
            lastCategorySelected = ""
            lastQuote = shareAppArray[randomIndex].string
        }
    }
    
    func createShareQuotesWithName() {
        shareAppArray.removeAll()
        let linkOne = NSMutableAttributedString(string: "\(name) doesn't have the Trumped app? SAD! bit.ly/2aRrcR0", attributes: normalAttributes)
        let linkTwo = NSMutableAttributedString(string: "\(name) should check out bit.ly/2aRrcR0 - if their short fingers can handle it..", attributes: normalAttributes)
        let linkThree = NSMutableAttributedString(string: "#MakeDonaldDrumpfAgain at bit.ly/2aRrcR0", attributes: normalAttributes)
        let linkFour = NSMutableAttributedString(string: "\(name) has ZERO imagination. You need bit.ly/2aRrcR0", attributes: normalAttributes)
        let linkFive = NSMutableAttributedString(string: "\(name) is a dumb mouthpiece. Maybe this will help - bit.ly/2aRrcR0", attributes: normalAttributes)
        let linkSix = NSMutableAttributedString(string: "Wacko! All \(name) does is talk, talk, talk. This will make it easier. bit.ly/2aRrcR0", attributes: normalAttributes)
        shareAppArray += [addLinkToString(linkOne), addLinkToString(linkTwo), addLinkToString(linkThree), addLinkToString(linkFour), addLinkToString(linkFive), addLinkToString(linkSix)]
    }
    
    func createShareQuotesWithoutName() {
        let linkOne = NSMutableAttributedString(string: "You don't have the Trumped app? SAD! bit.ly/2aRrcR0", attributes: normalAttributes)
        let linkTwo = NSMutableAttributedString(string: "Check out bit.ly/2aRrcR0 - if your short fingers can handle it.", attributes: normalAttributes)
        let linkThree = NSMutableAttributedString(string: "#MakeDonaldDrumpfAgain. bit.ly/2aRrcR0", attributes: normalAttributes)
        let linkFour = NSMutableAttributedString(string: "ZERO imagination. You need bit.ly/2aRrcR0", attributes: normalAttributes)
        let linkFive = NSMutableAttributedString(string: "You're a dumb mouthpiece. Maybe this will help - bit.ly/2aRrcR0", attributes: normalAttributes)
        let linkSix = NSMutableAttributedString(string: "Wacko! All you do is talk, talk, talk. This will make it easier. bit.ly/2aRrcR0", attributes: normalAttributes)
        shareAppArray += [addLinkToString(linkOne), addLinkToString(linkTwo), addLinkToString(linkThree), addLinkToString(linkFour), addLinkToString(linkFive), addLinkToString(linkSix)]
    }
    
    func addLinkToString(string: NSMutableAttributedString) -> NSMutableAttributedString {
        string.addAttribute(NSLinkAttributeName, value: "www.facebook.com/trumpedkeyboard", range: (string.string as NSString).rangeOfString(string.string))
        return string
    }

    func showNameLabel() {
        if name == "" {
            nameLabel.hidden = false
        }
    }
    
    func expandCategory() {
        if sectionExpanded {
            self.categoryLabel.text = currentCategoryDisplayed
            NSLayoutConstraint.deactivateConstraints([expandedCategoryTableViewHeaderTopConstraint!, expandedChooseQuoteViewBottomConstraint!, newCategoryHeaderBorderViewHeight!])
            NSLayoutConstraint.activateConstraints([categoryTableViewHeaderBottom, categoryTableViewHeaderTop, categoryHeaderBorderViewHeight])

            nameView.hidden = false
            
            NSLayoutConstraint.deactivateConstraints([expandedCategoryTableViewHeaderTopConstraint!, expandedChooseQuoteViewBottomConstraint!])
            NSLayoutConstraint.activateConstraints([categoryTableViewHeaderBottom, categoryTableViewHeaderTop])
            
            UIView.animateWithDuration(0.2, animations: {
                self.view.layoutIfNeeded()
            })
            sectionExpanded = false
            self.arrowIcon.transform = CGAffineTransformMakeScale(1,1)
            
        } else {
            self.categoryLabel.text = ""
            nameView.hidden = true
            
            NSLayoutConstraint.deactivateConstraints([categoryTableViewHeaderBottom, categoryTableViewHeaderTop, categoryHeaderBorderViewHeight])
            
            
            expandedCategoryTableViewHeaderTopConstraint = NSLayoutConstraint(
                item: self.categoryHeader,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Top,
                multiplier: 1,
                constant: 0
            )
            expandedCategoryTableViewHeaderTopConstraint!.identifier = "New Category Header Top - Parent View Top"
            
            expandedChooseQuoteViewBottomConstraint =
            NSLayoutConstraint(
                item: self.chooseQuoteView,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Bottom,
                multiplier: 1,
                constant: 0
            )
            expandedChooseQuoteViewBottomConstraint!.identifier = "New Quote Table Bottom - Parent View Bottom"
            
            newCategoryHeaderBorderViewHeight =
                NSLayoutConstraint(
                    item: self.categoryHeaderBorderView,
                    attribute: .Height,
                    relatedBy: .Equal,
                    toItem: nil,
                    attribute: .NotAnAttribute,
                    multiplier: 1,
                    constant: 1.0
            )
            expandedChooseQuoteViewBottomConstraint!.identifier = "New Quote Table Bottom - Parent View Bottom"
            
            self.view.addConstraints([expandedCategoryTableViewHeaderTopConstraint!, expandedChooseQuoteViewBottomConstraint!, newCategoryHeaderBorderViewHeight!])
            
            
            UIView.animateWithDuration(0.2, animations: {
                self.view.layoutIfNeeded()
            })
            sectionExpanded = true
            self.arrowIcon.transform = CGAffineTransformMakeScale(1,-1)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return buttonTitles[currentCategoryDisplayed]!.count
        } else {
            return buttonTitles.count

        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == tableView1 {
            let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell")
            
            var categoryQuotes = self.buttonTitles[currentCategoryDisplayed]
            let quote = categoryQuotes![indexPath.row].0
            let author = categoryQuotes![indexPath.row].1
            let fullQuote = NSMutableAttributedString()
            fullQuote.appendAttributedString(quote)
            fullQuote.appendAttributedString(NSAttributedString(string: "\n"))
            fullQuote.appendAttributedString(author)
            
            cell.textLabel?.attributedText = fullQuote
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.numberOfLines = 0
            
            cell.backgroundColor = quoteColor
            
            let myCustomSelectionColorView = UIView()
            myCustomSelectionColorView.backgroundColor = activeColor
            cell.selectedBackgroundView = myCustomSelectionColorView
            
            cell.preservesSuperviewLayoutMargins = false
            cell.layoutMargins = UIEdgeInsetsZero
            cell.separatorInset = UIEdgeInsetsZero
                
            return cell
           
        } else {
            
            let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell2")
            
            var categoryArray = Array(self.buttonTitles.keys).sort(<)
            cell.textLabel?.text = categoryArray[indexPath.row]
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.font = UIFont(name: "Helvetica Neue-Bold", size: 15)
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.textLabel?.numberOfLines = 0
            cell.backgroundColor = navColor
            
            let myCustomSelectionColorView = UIView()
            myCustomSelectionColorView.backgroundColor = activeColor
            cell.selectedBackgroundView = myCustomSelectionColorView
            
            cell.preservesSuperviewLayoutMargins = false
            cell.layoutMargins = UIEdgeInsetsZero
            cell.separatorInset = UIEdgeInsetsZero
            
            return cell
        }
     
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == tableView1 {
            let categoryQuotes = self.buttonTitles[currentCategoryDisplayed]
            var quote: (NSMutableAttributedString, NSAttributedString)
            if let selectedCategoryQuotes = categoryQuotes {
                quote = selectedCategoryQuotes[indexPath.row]
            } else {
                quote = (NSMutableAttributedString(string: "", attributes: normalAttributes), NSAttributedString(string: "" , attributes: subtitleAttributes))
            }
            let string = quote.0.string
            
            var allTextBefore: String
            if let stringToTest = textDocumentProxy.documentContextBeforeInput {
                allTextBefore = stringToTest
            } else {
                allTextBefore = ""
            }
            
            let allTextBeforeLength = allTextBefore.characters.count
            let lastStringLength = lastQuote.characters.count
            var stringToCheck: String?
            
            if allTextBeforeLength <= lastStringLength {
                let indexToCheckFrom = allTextBefore.startIndex
                stringToCheck = allTextBefore.substringFromIndex(indexToCheckFrom)
            } else {
                let indexToCheckFrom = allTextBefore.endIndex.advancedBy(-lastStringLength)
                stringToCheck = allTextBefore.substringFromIndex(indexToCheckFrom)
            }
            
            if lastRow != -1 {
                
                if stringToCheck == lastQuote {
                    deleteBackwardRepeat(lastStringLength)
                }
                
                if lastRow == indexPath.row && lastCategorySelected == currentCategoryDisplayed {

                    self.tableView1.deselectRowAtIndexPath(indexPath, animated: false)
                    lastRow = -1
                    lastCategorySelected = ""
                    lastQuote = ""

                } else {
                    shareButtonImage.image = UIImage(named: "share-gray")
                    (textDocumentProxy as UIKeyInput).insertText("\(string)")
                    lastRow = indexPath.row
                    lastCategorySelected = currentCategoryDisplayed
                    let lastCategoryQuotes = self.buttonTitles[lastCategorySelected]
                    lastQuote = lastCategoryQuotes![lastRow].0.string
                }

            } else {
                (textDocumentProxy as UIKeyInput).insertText("\(string)")
                lastRow = indexPath.row
                lastCategorySelected = currentCategoryDisplayed
                let lastCategoryQuotes = self.buttonTitles[lastCategorySelected]
                lastQuote = lastCategoryQuotes![lastRow].0.string
            }
            
        } else {
            var categoryArray = Array(self.buttonTitles.keys).sort(<)
            currentCategoryDisplayed = categoryArray[indexPath.row]
            categoryLabel.text = currentCategoryDisplayed
            tableView1.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Right)
            if lastCategorySelected == currentCategoryDisplayed {
                self.tableView1.selectRowAtIndexPath(NSIndexPath(forRow: lastRow, inSection: 0), animated: false, scrollPosition: .Middle)
            }
            expandCategory()
        }
    
    }
    
    func deleteBackwardRepeat(numberOfTimes: Int) {
        var i = numberOfTimes
        while i > 0 {
            (textDocumentProxy as UIKeyInput).deleteBackward()
            i -= 1
        }
    }
    
    func buttonActive(button: UIButton) {
        button.backgroundColor = activeColor
    }
    
    func buttonInactive(button: UIButton) {
        button.backgroundColor = UIColor.whiteColor()
    }
    
    func shareButtonActive(button: UIButton) {
        shareButtonImage.image = UIImage(named: "share-red")
    }
    
    func shareButtonInactive(button: UIButton) {
        shareButtonImage.image = UIImage(named: "share-gray")
    }
    
    func navButtonActive(button: UIButton) {
        button.backgroundColor = activeColor
    }
    
    func navButtonInactive(button: UIButton) {
        button.backgroundColor = navColor
    }

    func nextKeyboardPressed(button: UIButton) {
        advanceToNextInputMode()
    }
    

    
    func refreshNameArrays() {
        crookedArray.removeAll()
        weakArray.removeAll()
        uglyArray.removeAll()
        manipulativeArray.removeAll()
        crazyArray.removeAll()
        sleazyArray.removeAll()
        poorArray.removeAll()
        meanArray.removeAll()
        softArray.removeAll()
        embarassmentArray.removeAll()
        loserArray.removeAll()
        unpopularArray.removeAll()
        incompetentArray.removeAll()
        dummyArray.removeAll()
        talkingtoomuchArray.removeAll()
        wrongArray.removeAll()
        bestquotesArray.removeAll()
        cluelessArray.removeAll()
    }
    
    func refreshButtonTitles() {
        buttonTitles["Crooked!"] = crookedArray
        buttonTitles["Weak"] = weakArray
        buttonTitles["Ugly"] = uglyArray
        buttonTitles["Manipulative"] = manipulativeArray
        buttonTitles["Crazy"] = crazyArray
        buttonTitles["Sleazy"] = sleazyArray
        buttonTitles["Poor"] = poorArray
        buttonTitles["Mean"] = meanArray
        buttonTitles["Soft"] = softArray
        buttonTitles["Embarassment"] = embarassmentArray
        buttonTitles["Loser"] = loserArray
        buttonTitles["Unpopular"] = unpopularArray
        buttonTitles["Incompetent"] = incompetentArray
        buttonTitles["Dummy"] = dummyArray
        buttonTitles["Talking too much"] = talkingtoomuchArray
        buttonTitles["Wrong"] = wrongArray
        buttonTitles["Best Quotes"] = bestquotesArray
        buttonTitles["Clueless"] = cluelessArray
    }
    
    func createInsultsWithoutName() {
        refreshNameArrays()
        crookedArray += [(NSMutableAttributedString(string: "Crooked!", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "Your temperament is weak.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You don't even look presidential.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        wrongArray += [(NSMutableAttributedString(string: "You suffer from plain old bad judgement.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "You have zero imagination and even less stamina.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You have ZERO leadership ability.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        manipulativeArray += [(NSMutableAttributedString(string: "You're constantly playing the women's card - it is sad!", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        manipulativeArray += [(NSMutableAttributedString(string: "You're one of the all time great enablers!", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "Who should star in a reboot of Liar Liar - you or Ted Cruz? Let me know.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "You're a major national security risk.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "You're totally incompetent as a manager and leader.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You want to look cool, but it's far too late.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "You're by far the weakest of the lot.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "You will do anything to stay at the trough.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "You should go home and relax!", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "You're a total embarassment to yourself and your family.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "You're bottom (and gone), I'm top (by a lot).", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "You really went wacko today.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "You're mathematically dead and totally desperate.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "All you can do is be a spoiler, never a nice thing to do.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "You lie like a dog-over and over again!", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "You're a world class LIAR!", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "You're the worst liar, crazy or very dishonest.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You will fall like all others.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "If I listen to you for more than ten minutes straight, I develop a massive headache.", attributes: normalAttributes), NSAttributedString(string: "on Carly Fiorina" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "YOU'RE ALL TALK AND NO ACTION!", attributes: normalAttributes), NSAttributedString(string: "on Lindsey Graham" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "You're a dumb mouthpiece.", attributes: normalAttributes), NSAttributedString(string: "on Lindsey Graham" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "I will sue you just for fun!", attributes: normalAttributes), NSAttributedString(string: "on John Kasich" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "You couldn't be elected dog catcher.", attributes: normalAttributes), NSAttributedString(string: "on George Pataki" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "You didn't get the right gene.", attributes: normalAttributes), NSAttributedString(string: "on Rand Paul" , attributes: subtitleAttributes))]
        wrongArray += [(NSMutableAttributedString(string: "You should be forced to take an IQ test.", attributes: normalAttributes), NSAttributedString(string: "on Rick Perry" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "You will never MAKE AMERICA GREAT AGAIN!", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "You look like a little boy on stage.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You couldn't even respond properly without pouring sweat & chugging water.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You're a perfect little puppet.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "You've never made ten cents.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        cluelessArray += [(NSMutableAttributedString(string: "You know nothing about finance.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "I know more about you than you know about yourself.", attributes: normalAttributes), NSAttributedString(string: "on Cory Booker" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "You're the WORST abuser of women in US history.", attributes: normalAttributes), NSAttributedString(string: "on Bill Clinton" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "YOU DEMONSTRATED A PENCHANT FOR SEXISM.", attributes: normalAttributes), NSAttributedString(string: "on Bill Clinton" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "You're a crude dope!", attributes: normalAttributes), NSAttributedString(string: "on Michael Nutter" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You look and sound so ridiculous.", attributes: normalAttributes), NSAttributedString(string: "on Barack Obama" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "You have a career that is totally based on a lie.", attributes: normalAttributes), NSAttributedString(string: "on Elizabeth Warren" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "Perv sleazebag.", attributes: normalAttributes), NSAttributedString(string: "on Anthony Weiner" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "You should focus on all of the problems that you've caused with your ineptitude.", attributes: normalAttributes), NSAttributedString(string: "on Bill de Blasio" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "The people are embarrassed by you!", attributes: normalAttributes), NSAttributedString(string: "on Nikki Haley" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "All you do is talk, talk, talk, but you're incapable of doing anything.", attributes: normalAttributes), NSAttributedString(string: "on John McCain" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You choked like a dog. You're a choker.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        cluelessArray += [(NSMutableAttributedString(string: "You're a mixed up person who doesn't have a clue.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You're the person who choked and let us all down.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "You're a total joke, and everyone knows it!", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "You are so awkward and goofy.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "I don't need your angry advice!", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "Wacko. You're a failing, crying, lost soul!", attributes: normalAttributes), NSAttributedString(string: "on Glenn Beck" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "You're a mental basketcase.", attributes: normalAttributes), NSAttributedString(string: "on Glenn Beck" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "Wacky, you always seems to be crying - a real nut job!", attributes: normalAttributes), NSAttributedString(string: "on Glenn Beck" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Lightweight, you come to my office begging for money like a dog.", attributes: normalAttributes), NSAttributedString(string: "on Brent Bozell" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "I consider you one of the dumbest of all - you have no sense of the real world!", attributes: normalAttributes), NSAttributedString(string: "on David Brooks" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "You're closing in on being the dumbest of them all. You don't have a clue.", attributes: normalAttributes), NSAttributedString(string: "on David Brooks" , attributes: subtitleAttributes))]
        wrongArray += [(NSMutableAttributedString(string: "You have been so wrong & you hate it!", attributes: normalAttributes), NSAttributedString(string: "on Carl Cameron" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "You have been largely forgotten.", attributes: normalAttributes), NSAttributedString(string: "on Katie Couric" , attributes: subtitleAttributes))]
        cluelessArray += [(NSMutableAttributedString(string: "You're a totally biased loser who doesn't have a clue.", attributes: normalAttributes), NSAttributedString(string: "on S.E. Cupp" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "You're hard to watch, zero talent!", attributes: normalAttributes), NSAttributedString(string: "on S.E. Cupp" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "You're a major sleaze and buffoon.", attributes: normalAttributes), NSAttributedString(string: "on Erick Erickson" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Uncomfortable looking, calling me to ask for favors and then mockingly smiling.", attributes: normalAttributes), NSAttributedString(string: "on Willie Geist" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "You just don't know about winning! But you're a nice person.", attributes: normalAttributes), NSAttributedString(string: "on Bernard Goldberg" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Sleepy Eyes!", attributes: normalAttributes), NSAttributedString(string: "on Bernard Goldberg" , attributes: subtitleAttributes))]
        cluelessArray += [(NSMutableAttributedString(string: "You're not smart enough to know what's going on.", attributes: normalAttributes), NSAttributedString(string: "on Mary Katharine Ham" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "You wouldn't know the truth if it hit you in the face.", attributes: normalAttributes), NSAttributedString(string: "on Jeff Horwitz" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "Liberal clown.", attributes: normalAttributes), NSAttributedString(string: "on Arianna Huffington" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "Dope!", attributes: normalAttributes), NSAttributedString(string: "on Brit Hume" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "You're so average in so many ways!", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "You're sick, & the most overrated person!", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "Get a life!", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "I refuse to call you a bimbo, because that would not be politically correct.", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        cluelessArray += [(NSMutableAttributedString(string: "You're very bad at math.", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "You should take another eleven day 'unscheduled' vacation.", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "No focus, poor level of concentration!", attributes: normalAttributes), NSAttributedString(string: "on Ruth Marcus" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "I think you should have gone to prison for what you did.", attributes: normalAttributes), NSAttributedString(string: "on Steve Rattner" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "Not much power or insight!", attributes: normalAttributes), NSAttributedString(string: "on Joe Scarborough" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "You're a major lightweight with no credibility.", attributes: normalAttributes), NSAttributedString(string: "on Ben Schreckinger" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "Hater & racist.", attributes: normalAttributes), NSAttributedString(string: "on Tavis Smiley" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "You should be ashamed of yourself.", attributes: normalAttributes), NSAttributedString(string: "on Shep Smith" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "Really dumb puppet.", attributes: normalAttributes), NSAttributedString(string: "on Marc Threaten (sic)" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "Sleepy eyes, you will be fired like a dog. I can't imagine what is taking so long!", attributes: normalAttributes), NSAttributedString(string: "on Chuck Todd" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "Hokey garbage.", attributes: normalAttributes), NSAttributedString(string: "on Penn Jillette" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "Goofball atheist, never had a chance.", attributes: normalAttributes), NSAttributedString(string: "on Penn Jillette" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "Not a nice person!", attributes: normalAttributes), NSAttributedString(string: "on Rounda Rousey" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "A total waste of money!", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush's campaign" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "Very gentle and soft.", attributes: normalAttributes), NSAttributedString(string: "on Democratic candidates" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "Low level degenerate.", attributes: normalAttributes), NSAttributedString(string: "on ISIS" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "All bull...all talk and no action.", attributes: normalAttributes), NSAttributedString(string: "on other candidates" , attributes: subtitleAttributes))]
        manipulativeArray += [(NSMutableAttributedString(string: "You're an expert in never facing any consequence.", attributes: normalAttributes), NSAttributedString(string: "on politicians" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "You're a nasty person with no heart!", attributes: normalAttributes), NSAttributedString(string: "on Russell Moore" , attributes: subtitleAttributes))]
        wrongArray += [(NSMutableAttributedString(string: "You're wrong on so many subjects!", attributes: normalAttributes), NSAttributedString(string: "on George Will" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "You talk about me but know nothing about me - crazy!", attributes: normalAttributes), NSAttributedString(string: "on Harry Hurt III" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "Your a low-class slob.", attributes: normalAttributes), NSAttributedString(string: "on Frank Luntz" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "You never say anything good & never will.", attributes: normalAttributes), NSAttributedString(string: "on Karl Rove" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You're an all talk, no action dummy!", attributes: normalAttributes), NSAttributedString(string: "on Karl Rove" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You irrelevant clown, sweating and shaking nervously as you talk bull about me. Zero cred.", attributes: normalAttributes), NSAttributedString(string: "on Karl Rove" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "You're a dumb person who fails @ virtually everything you touch.", attributes: normalAttributes), NSAttributedString(string: "on Stuart Stevens" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "You're a total phony and con!", attributes: normalAttributes), NSAttributedString(string: "on Bob Vander Plaats" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "Weak and totally conflicted people like you should be given an I.Q. test. Dumb as a rock!", attributes: normalAttributes), NSAttributedString(string: "on Rick Wilson" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "I don’t like your golf swing. Not athletic. Play you for charity!", attributes: normalAttributes), NSAttributedString(string: "on Samuel L. Jackson" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "You're just plain dumb!", attributes: normalAttributes), NSAttributedString(string: "on CNN" , attributes: subtitleAttributes))]
        wrongArray += [(NSMutableAttributedString(string: "Why can't you get it right - it's really not that hard!", attributes: normalAttributes), NSAttributedString(string: "on CNN" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "How stupid, how desperate!", attributes: normalAttributes), NSAttributedString(string: "on The New Hampshire Union Leader" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You're dying in turmoil - like a bully that got knocked out!", attributes: normalAttributes), NSAttributedString(string: "on The New Hampshire Union Leader" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "I am happy to hear how badly you are doing. Becoming irrelevant!", attributes: normalAttributes), NSAttributedString(string: "on The New York Times" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "3rd rate $ losing. No credibility.", attributes: normalAttributes), NSAttributedString(string: "on Politico" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "If you were legit, you would be doing far better!", attributes: normalAttributes), NSAttributedString(string: "on Politico" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "I was so happy when I heard that you are losing a fortune. Pure scum!", attributes: normalAttributes), NSAttributedString(string: "on Politico" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "You have no power, but so dishonest!", attributes: normalAttributes), NSAttributedString(string: "on Politico" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "You're doing really poorly. You've gotten worse and worse over the years, and have lost almost all of your former allure!", attributes: normalAttributes), NSAttributedString(string: "on Vanity Fair" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "You are bad at math. The good news is, nobody cares what you say anymore, especially me!", attributes: normalAttributes), NSAttributedString(string: "on The Wall Street Journal" , attributes: subtitleAttributes))]
        cluelessArray += [(NSMutableAttributedString(string: "Dopey - knows nothing about me or my wealth. A waste!", attributes: normalAttributes), NSAttributedString(string: "on Anderson Cooper writer" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "You're a catastrophe that must be stopped. Will lead to at least partial world destruction.", attributes: normalAttributes), NSAttributedString(string: "on Iran nuclear deal" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "You suck and are bad for U.S.A.", attributes: normalAttributes), NSAttributedString(string: "on Macy's stores" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "Really boring, slow, lethargic - very hard to watch!", attributes: normalAttributes), NSAttributedString(string: "on The State of the Union" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "You're totally overrated clown who speaks without knowing facts.", attributes: normalAttributes), NSAttributedString(string: "on Charles Krauthammer" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "I love watching you fail!", attributes: normalAttributes), NSAttributedString(string: "on Chuck Todd" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "Graduated last in your class - dummy!", attributes: normalAttributes), NSAttributedString(string: "on John McCain" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You need a new pair of glasses.", attributes: normalAttributes), NSAttributedString(string: "on Rick Perry" , attributes: subtitleAttributes))]
        manipulativeArray += [(NSMutableAttributedString(string: "Why do you constantly seek out trivial nonsense?", attributes: normalAttributes), NSAttributedString(string: "on Forbes" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "Loser.", attributes: normalAttributes), NSAttributedString(string: "on pretty much everybody" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "You did an absolutely horrible job. You should be ashamed of yourself.", attributes: normalAttributes), NSAttributedString(string: "on Rick Perry" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "You simply can't perform without drugs.", attributes: normalAttributes), NSAttributedString(string: "on Alex Rodriguez" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Poor you. I have a store that’s worth more money than you are.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "You walk like a penguin. LIKE A PENGUIN!", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "You're a sleaze, in my book. You’re a sleaze because you know the facts, and you know the facts well.", attributes: normalAttributes), NSAttributedString(string: "on Tom Llamas" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "What a stiff, what a stiff.", attributes: normalAttributes), NSAttributedString(string: "on Lindsey Graham" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "I like the way you used to look. I don’t like the way you look now. … you're a solid four. You went from an eight to a solid four.", attributes: normalAttributes), NSAttributedString(string: "on Nicolette Sheridan" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "You put on glasses so people will think you're smart. And it just doesn't work! You know people can see through the glasses.", attributes: normalAttributes), NSAttributedString(string: "on Rick Perry" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "You never speak well of me & yet when I saw you, you ran over like a child and wanted a picture.", attributes: normalAttributes), NSAttributedString(string: "on Juan Williams" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "You are basically a very untalented person who's a bully. Your intelligence is less than average in my opinion.", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Big, fat pig.", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "You're a mental midget, a low-life.", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Disgusting both inside and out. Look at you, a slob.", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "I'm not allowed to talk about your ugly face or body - so I won't. Is this a double standard?", attributes: normalAttributes), NSAttributedString(string: "on Bette Midler" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "While you are an extremely unattractive person, I refuse to say that because I always insist on being politically correct.", attributes: normalAttributes), NSAttributedString(string: "on Bette Midler" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "You flirted with me - consciously or unconsciously. That's to be expected.", attributes: normalAttributes), NSAttributedString(string: "on women of The Apprentice" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Unattractive both inside and out.", attributes: normalAttributes), NSAttributedString(string: "on Arianna Huffington" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "I’d look at you right in that fat, ugly face of yours, I’d say - ‘You’re fired.’", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "I think the only difference between me and you is that I'm more honest and my women are more beautiful.", attributes: normalAttributes), NSAttributedString(string: "on other candidates" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "Sorry losers and haters, but my I.Q. is one of the highest - and you all know it! Please don't feel so stupid or insecure, it's not your fault.", attributes: normalAttributes), NSAttributedString(string: "on everyone" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "I promise not to talk about your massive plastic surgeries that didn’t work.", attributes: normalAttributes), NSAttributedString(string: "on Cher" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "I have a Gucci store that’s worth more than you.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "How stupid are you?", attributes: normalAttributes), NSAttributedString(string: "on the people of Iowa" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "You talk like a truck driver, you don't have your facts, you'll say anything that comes to your mind.", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Do you mind if I sit back a little bit? Because your breath is very bad. It really is.", attributes: normalAttributes), NSAttributedString(string: "on Larry King" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "Show me someone without an ego, and I'll show you a loser - having a healthy ego, or high opinion of yourself, is a real positive in life!", attributes: normalAttributes), NSAttributedString(string: "on the humble" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "Over your life, you’ve been called a lot worse. Isn’t that right?", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Some people aren’t meant to be rich. It’s a talent. Some people have a talent for piano. I just happen to have a talent for making money.", attributes: normalAttributes), NSAttributedString(string: "on the not rich" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Look at that face! I mean, you're a woman, and I'm not supposed to say bad things, but really, folks, come on. Are we serious?", attributes: normalAttributes), NSAttributedString(string: "on Carly Fiorina" , attributes: subtitleAttributes))]
        cluelessArray += [(NSMutableAttributedString(string: "You don't have a clue about life!", attributes: normalAttributes), NSAttributedString(string: "on Kareem Abdul-Jabbar" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "You're ashamed of your last name. You're a loser.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "You can't negotiate your way out of a paper bag.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "I don’t think you've got the right temperament. I don’t think you've got the right judgment. A little bit of a maniac.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "You're a total low life. A dummy with no “it” factor. Will fade fast.", attributes: normalAttributes), NSAttributedString(string: "on Erick Erickson" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "Virtually incompetent.", attributes: normalAttributes), NSAttributedString(string: "on Cheri Jacobus" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "Once you opened your mouth, people realized you were a complete & total dud!", attributes: normalAttributes), NSAttributedString(string: "on John Kasich" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "Poor you. You don't have what it takes.", attributes: normalAttributes), NSAttributedString(string: "on John Kasich" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Sadly, you're no longer a 10.", attributes: normalAttributes), NSAttributedString(string: "on Heidi Klum" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "You pretend to be smart, but you aren't. A dummy - an overrated clown!", attributes: normalAttributes), NSAttributedString(string: "on Charles Krauthammer" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "You've lost all self respect. You're very embarrassed to even walk down the street.", attributes: normalAttributes), NSAttributedString(string: "on Bill Kristol" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "There's something wrong with you.", attributes: normalAttributes), NSAttributedString(string: "on Barack Obama" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "Like a little baby. Like a disgusting, little, weak, pathetic baby. ", attributes: normalAttributes), NSAttributedString(string: "on Martin O'Malley" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "Truly weird. You remind me of a spoiled brat without a properly functioning brain.", attributes: normalAttributes), NSAttributedString(string: "on Rand Paul" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "I easily beat you on the golf course and will even more easily beat you now, in the world.", attributes: normalAttributes), NSAttributedString(string: "on Rand Paul" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "Highly untalented, a real dummy.", attributes: normalAttributes), NSAttributedString(string: "on Jennifer Rubin" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "You are like a little baby: soft, weak, little baby.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "Knitwit.", attributes: normalAttributes), NSAttributedString(string: "on Paul Ryan" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "You are living in the world of make-believe.", attributes: normalAttributes), NSAttributedString(string: "on Chris Wallace" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "Now I know why people always treated you so badly - they couldn’t stand you.", attributes: normalAttributes), NSAttributedString(string: "on Kareem Abdul-Jabbar" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "I have never seen a human being eat in such a disgusting fashion.", attributes: normalAttributes), NSAttributedString(string: "on John Kasich" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "You're one of the dumbest human beings I have ever seen.", attributes: normalAttributes), NSAttributedString(string: "on Lindsey Graham" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "You're a lightweight - dumb as a rock.", attributes: normalAttributes), NSAttributedString(string: "on Don Lemon" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "If I looked like you, I'd struggle with depression, too.", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "I feel sorry for your partner in love whose parents are devastated at the thought of their child being with you - a true loser.", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        
        refreshButtonTitles()
    }
    
    func createInsultsWithName() {
        
        refreshNameArrays()
        
        crookedArray += [(NSMutableAttributedString(string: "Crooked \(name)!", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "\(name)'s temperament is weak.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "\(name) doesn't even look presidential.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        wrongArray += [(NSMutableAttributedString(string: "\(name) suffers from plain old bad judgement.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "\(name) has zero imagination and even less stamina.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) has ZERO leadership ability.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        manipulativeArray += [(NSMutableAttributedString(string: "\(name)'s constantly playing the women's card - it is sad!", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        manipulativeArray += [(NSMutableAttributedString(string: "\(name)'s one of the all time great enablers!", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "Who should star in a reboot of Liar Liar - \(name) or Ted Cruz? Let me know.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "\(name)'s a major national security risk.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "\(name)'s totally incompetent as a manager and leader.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "\(name) wants to look cool, but it's far too late.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "\(name)'s by far the weakest of the lot.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "\(name) will do anything to stay at the trough.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "\(name) should go home and relax!", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "\(name)'s a total embarassment.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "\(name)'s bottom (and gone), I'm top (by a lot).", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "\(name) really went wacko today.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "\(name)'s mathematically dead and totally desparate.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "All \(name) can do is be a spoiler, never a nice thing to do.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "\(name) lies like a dog-over and over again!", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "\(name) is a world class LIAR!", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "\(name)'s the worst liar, crazy or very dishonest.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) will fall like all others.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "If I listen to \(name) for more than ten minutes straight, I develop a massive headache.", attributes: normalAttributes), NSAttributedString(string: "on Carly Fiorina" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "\(name) - ALL TALK AND NO ACTION!", attributes: normalAttributes), NSAttributedString(string: "on Lindsey Graham" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "\(name)'s a dumb mouthpiece.", attributes: normalAttributes), NSAttributedString(string: "on Lindsey Graham" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "I will sue \(name) just for fun!", attributes: normalAttributes), NSAttributedString(string: "on John Kasich" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "\(name) couldn't be elected dog catcher", attributes: normalAttributes), NSAttributedString(string: "on George Pataki" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "\(name) didn't get the right gene.", attributes: normalAttributes), NSAttributedString(string: "on Rand Paul" , attributes: subtitleAttributes))]
        wrongArray += [(NSMutableAttributedString(string: "\(name) should be forced to take an IQ test.", attributes: normalAttributes), NSAttributedString(string: "on Rick Perry" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "\(name) will never MAKE AMERICA GREAT AGAIN!", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "\(name) looks like a little boy on stage.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) couldn't even respond properly without pouring sweat and chugging water.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s a perfect little puppet.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "\(name)'s never made ten cents.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        cluelessArray += [(NSMutableAttributedString(string: "\(name) knows nothing about finance", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "I know more about you than you know about yourself.", attributes: normalAttributes), NSAttributedString(string: "on Cory Booker" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "\(name)'s the WORST abuser of woman in U.S. political history.", attributes: normalAttributes), NSAttributedString(string: "on Bill Clinton" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "\(name) DEMONSTRATED A PENCHANT FOR SEXISM.", attributes: normalAttributes), NSAttributedString(string: "on Bill Clinton" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "\(name)'s a crude dope!", attributes: normalAttributes), NSAttributedString(string: "on Michael Nutter" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "\(name) looks and sounds so ridiculous.", attributes: normalAttributes), NSAttributedString(string: "on Barack Obama" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "\(name) has a career that is totally based on a lie.", attributes: normalAttributes), NSAttributedString(string: "on Elizabeth Warren" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "Perv sleazebag.", attributes: normalAttributes), NSAttributedString(string: "on Anthony Weiner" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "\(name) should focus on all of the problems caused by ineptitude.", attributes: normalAttributes), NSAttributedString(string: "on Bill de Blasio" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "The people are embarrassed by \(name)!", attributes: normalAttributes), NSAttributedString(string: "on Nikki Haley" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "All \(name) does is talk, talk, talk, but incapable of doing anything.", attributes: normalAttributes), NSAttributedString(string: "on John McCain" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) choked like a dog. A choker.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        cluelessArray += [(NSMutableAttributedString(string: "\(name)'s a mixed up person who doesn't have a clue.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s the person who choked and let us all down.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "\(name)'s a total joke, and everyone knows it!", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "\(name)'s so awkward and goofy.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "I don't need \(name)'s angry advice!", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "Wacko \(name)'s a failing, crying, lost soul!", attributes: normalAttributes), NSAttributedString(string: "on Glenn Beck" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "\(name)'s a mental basketcase.", attributes: normalAttributes), NSAttributedString(string: "on Glenn Beck" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "Wacky \(name) who always seems to be crying - a real nut job!", attributes: normalAttributes), NSAttributedString(string: "on Glenn Beck" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Lightweight, \(name) comes to my office begging for money like a dog.", attributes: normalAttributes), NSAttributedString(string: "on Brent Bozell" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "I consider \(name) one of the dumbest of all - \(name) has no sense of the real world!", attributes: normalAttributes), NSAttributedString(string: "on David Brooks" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "\(name)'s closing in on being the dumbest of them all. \(name) doesn't have a clue.", attributes: normalAttributes), NSAttributedString(string: "on David Brooks" , attributes: subtitleAttributes))]
        wrongArray += [(NSMutableAttributedString(string: "\(name)'s been so wrong & hates it!", attributes: normalAttributes), NSAttributedString(string: "on Carl Cameron" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "\(name) has been largely forgotten.", attributes: normalAttributes), NSAttributedString(string: "on Katie Couric" , attributes: subtitleAttributes))]
        cluelessArray += [(NSMutableAttributedString(string: "\(name)'s a totally biased loser who doesn't have a clue.", attributes: normalAttributes), NSAttributedString(string: "on S.E. Cupp" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "\(name)'s hard to watch, zero talent!", attributes: normalAttributes), NSAttributedString(string: "on S.E. Cupp" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "\(name)'s a major sleaze and buffoon.", attributes: normalAttributes), NSAttributedString(string: "on Erick Erickson" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Uncomfortable looking \(name) calls me to ask for favors and then mockingly smiles.", attributes: normalAttributes), NSAttributedString(string: "on Willie Geist" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "\(name) just doesn't know about winning! But a nice person.", attributes: normalAttributes), NSAttributedString(string: "on Bernard Goldberg" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Sleepy Eyes, \(name)!", attributes: normalAttributes), NSAttributedString(string: "on Bernard Goldberg" , attributes: subtitleAttributes))]
        cluelessArray += [(NSMutableAttributedString(string: "\(name)'s not smart enough to know what's going on.", attributes: normalAttributes), NSAttributedString(string: "on Mary Katharine Ham" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "\(name) wouldn't know the truth if hit in the face with it.", attributes: normalAttributes), NSAttributedString(string: "on Jeff Horwitz" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "Liberal clown.", attributes: normalAttributes), NSAttributedString(string: "on Arianna Huffington" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "Dope!", attributes: normalAttributes), NSAttributedString(string: "on Brit Hume" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "\(name)'s so average in so many ways!", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "\(name)'s sick, & the most overrated person!", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "\(name), get a life!", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "I refuse to call \(name) a bimbo, because that would not be politically correct.", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        cluelessArray += [(NSMutableAttributedString(string: "\(name)'s very bad at math.", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "\(name) should take another eleven day 'unscheduled' vacation.", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "No focus, poor level of concentration!", attributes: normalAttributes), NSAttributedString(string: "on Ruth Marcus" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "I think \(name) should have gone to prison.", attributes: normalAttributes), NSAttributedString(string: "on Steve Rattner" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "Not much power or insight!", attributes: normalAttributes), NSAttributedString(string: "on Joe Scarborough" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "\(name)'s a major lightweight with no credibility.", attributes: normalAttributes), NSAttributedString(string: "on Ben Schreckinger" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "Hater & racist.", attributes: normalAttributes), NSAttributedString(string: "on Tavis Smiley" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "\(name) should be ashamed.", attributes: normalAttributes), NSAttributedString(string: "on Shep Smith" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "Really dumb puppet.", attributes: normalAttributes), NSAttributedString(string: "on Marc Threaten (sic)" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "Sleepy eyes \(name) will be fired like a dog. I can't imagine what is taking so long!", attributes: normalAttributes), NSAttributedString(string: "on Chuck Todd" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "\(name)'s hokey garbage.", attributes: normalAttributes), NSAttributedString(string: "on Penn Jillette" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "Goofball atheist \(name) never had a chance.", attributes: normalAttributes), NSAttributedString(string: "on Penn Jillette" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "\(name)'s not a nice person!", attributes: normalAttributes), NSAttributedString(string: "on Rounda Rousey" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "\(name)'s a total waste of money!", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush's campaign" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "\(name)'s very gentle and soft.", attributes: normalAttributes), NSAttributedString(string: "on Democratic candidates" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "\(name)'s a low level degenerate.", attributes: normalAttributes), NSAttributedString(string: "on ISIS" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "\(name)'s all bull...all talk and no action.", attributes: normalAttributes), NSAttributedString(string: "on other candidates" , attributes: subtitleAttributes))]
        manipulativeArray += [(NSMutableAttributedString(string: "\(name)'s an expert in never facing any consequence.", attributes: normalAttributes), NSAttributedString(string: "on politicians" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "\(name)'s a nasty person with no heart!", attributes: normalAttributes), NSAttributedString(string: "on Russell Moore" , attributes: subtitleAttributes))]
        wrongArray += [(NSMutableAttributedString(string: "\(name)'s wrong on so many subjects!", attributes: normalAttributes), NSAttributedString(string: "on George Will" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "\(name) talks about me but knows nothing about me - crazy!", attributes: normalAttributes), NSAttributedString(string: "on Harry Hurt III" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "\(name)'s a low-class slob.", attributes: normalAttributes), NSAttributedString(string: "on Frank Luntz" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "\(name) never says anything good & never will.", attributes: normalAttributes), NSAttributedString(string: "on Karl Rove" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s an all talk, no action dummy!", attributes: normalAttributes), NSAttributedString(string: "on Karl Rove" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "Irrelevant clown \(name) sweats and shakes nervously and talks bull about me. Has zero cred.", attributes: normalAttributes), NSAttributedString(string: "on Karl Rove" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "\(name)'s a dumb person who fails @ virtually everything.", attributes: normalAttributes), NSAttributedString(string: "on Stuart Stevens" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "\(name)'s a total phony and con!", attributes: normalAttributes), NSAttributedString(string: "on Bob Vander Plaats" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "Weak and totally conflicted people like \(name) should be given an I.Q. test. Dumb as a rock!", attributes: normalAttributes), NSAttributedString(string: "on Rick Wilson" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "I don’t like \(name)'s golf swing. Not athletic. Will play for charity!", attributes: normalAttributes), NSAttributedString(string: "on Samuel L. Jackson" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "\(name) is just plain dumb!", attributes: normalAttributes), NSAttributedString(string: "on CNN" , attributes: subtitleAttributes))]
        wrongArray += [(NSMutableAttributedString(string: "Why can't \(name) get it right - it's really not that hard!", attributes: normalAttributes), NSAttributedString(string: "on CNN" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "How stupid, how desperate!", attributes: normalAttributes), NSAttributedString(string: "on The New Hampshire Union Leader" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "The dying \(name) is in turmoil - like a bully that got knocked out!", attributes: normalAttributes), NSAttributedString(string: "on The New Hampshire Union Leader" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "I am happy to hear how badly \(name) is doing. Becoming irrelevant!", attributes: normalAttributes), NSAttributedString(string: "on The New York Times" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "3rd rate $ losing \(name). No credibility.", attributes: normalAttributes), NSAttributedString(string: "on Politico" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "If \(name) were legit, would be doing far better!", attributes: normalAttributes), NSAttributedString(string: "on Politico" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "I was so happy when I heard that \(name) is losing a fortune. Pure scum!", attributes: normalAttributes), NSAttributedString(string: "on Politico" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "\(name) has no power, but so dishonest!", attributes: normalAttributes), NSAttributedString(string: "on Politico" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "\(name) is doing really poorly. Has gotten worse and worse over the years, and has lost almost all of the former allure!", attributes: normalAttributes), NSAttributedString(string: "on Vanity Fair" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "\(name) is bad at math. The good news is, nobody cares anymore, especially me!", attributes: normalAttributes), NSAttributedString(string: "on The Wall Street Journal" , attributes: subtitleAttributes))]
        cluelessArray += [(NSMutableAttributedString(string: "Dopey \(name) knows nothing about me or my wealth. A waste!", attributes: normalAttributes), NSAttributedString(string: "on Anderson Cooper writer" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "\(name) is a catastrophe that must be stopped. Will lead to at least partial world destruction.", attributes: normalAttributes), NSAttributedString(string: "on Iran nuclear deal" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "\(name) sucks and is bad for U.S.A.", attributes: normalAttributes), NSAttributedString(string: "on Macy's stores" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "\(name)'s really boring, slow, lethargic - very hard to watch!", attributes: normalAttributes), NSAttributedString(string: "on The State of the Union" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "\(name)'s a totally overrated clown who speaks without knowing facts.", attributes: normalAttributes), NSAttributedString(string: "on Charles Krauthammer" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "I love watching \(name) fail!", attributes: normalAttributes), NSAttributedString(string: "on Chuck Todd" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "\(name) graduated last in their class - dummy!", attributes: normalAttributes), NSAttributedString(string: "on John McCain" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) need's a new pair of glasses.", attributes: normalAttributes), NSAttributedString(string: "on Rick Perry" , attributes: subtitleAttributes))]
        manipulativeArray += [(NSMutableAttributedString(string: "Why does \(name) constantly seek out trivial nonsense?", attributes: normalAttributes), NSAttributedString(string: "on Forbes" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "Loser.", attributes: normalAttributes), NSAttributedString(string: "on pretty much everybody" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "\(name) did an absolutely horrible job. \(name) should be ashamed.", attributes: normalAttributes), NSAttributedString(string: "on Rick Perry" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "\(name) simply can't perform without drugs.", attributes: normalAttributes), NSAttributedString(string: "on Alex Rodriguez" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Poor \(name). I have a store that’s worth more money than \(name) is.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "\(name) walks like a penguin. LIKE A PENGUIN!", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "\(name)'s a sleaze, in my book. A sleaze because \(name) knows the facts, and knows them well.", attributes: normalAttributes), NSAttributedString(string: "on Tom Llamas" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "What a stiff, what a stiff.", attributes: normalAttributes), NSAttributedString(string: "on Lindsey Graham" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "I like the way \(name) used to look. I don’t like the way \(name) looks now. … a solid four. Went from an eight to a solid four.", attributes: normalAttributes), NSAttributedString(string: "on Nicolette Sheridan" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "\(name) put on glasses to look smart. And it just doesn't work! You know people can see through the glasses.", attributes: normalAttributes), NSAttributedString(string: "on Rick Perry" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "\(name) never speaks well of me & yet ran over like a child and wanted a picture.", attributes: normalAttributes), NSAttributedString(string: "on Juan Williams" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "\(name) is basically a very untalented person who's a bully. \(name)'s intelligence is less than average in my opinion.", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Big fat pig named \(name).", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "\(name)'s a mental midget, a low-life.", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "\(name)'s disgusting both inside and out. You take a look - a slob.", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "I'm not allowed to talk about \(name)'s ugly face or body - so I won't. Is this a double standard?", attributes: normalAttributes), NSAttributedString(string: "on Bette Midler" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "While \(name) is an extremely unattractive person, I refuse to say that because I always insist on being politically correct.", attributes: normalAttributes), NSAttributedString(string: "on Bette Midler" , attributes: subtitleAttributes))]
        bestquotesArray += [(NSMutableAttributedString(string: "\(name) flirted with me - consciously or unconsciously. That's to be expected.", attributes: normalAttributes), NSAttributedString(string: "on women of The Apprentice" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Unattractive both inside and out.", attributes: normalAttributes), NSAttributedString(string: "on Arianna Huffington" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "I’d look at \(name) right in that fat, ugly face, I’d say - ‘You’re fired.’", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        crookedArray += [(NSMutableAttributedString(string: "I think the only difference between me and \(name) is that I'm more honest and my women are more beautiful.", attributes: normalAttributes), NSAttributedString(string: "on other candidates" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "Sorry losers and haters, but my I.Q. is one of the highest - and you all know it! Please don't feel so stupid or insecure, it's not your fault.", attributes: normalAttributes), NSAttributedString(string: "on everyone" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "I promise not to talk about \(name)'s massive plastic surgeries that didn’t work.", attributes: normalAttributes), NSAttributedString(string: "on Cher" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "I have a Gucci store that’s worth more than \(name).", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "How stupid is \(name)?", attributes: normalAttributes), NSAttributedString(string: "on the people of Iowa" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "\(name) talks like a truck driver, doesn’t have the facts, and will say anything that comes to the mind.", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Do you mind if I sit back a little bit? Because \(name)'s breath is very bad. It really is.", attributes: normalAttributes), NSAttributedString(string: "on Larry King" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "Show me someone without an ego, and I'll show you a loser - having a healthy ego, or high opinion of yourself, is a real positive in life!", attributes: normalAttributes), NSAttributedString(string: "on the humble" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "Over life, \(name)'s been called a lot worse. Isn’t that right?", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Some people aren’t meant to be rich. It’s a talent. Some people have a talent for piano. I just happen to have a talent for making money.", attributes: normalAttributes), NSAttributedString(string: "on the not rich" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Look at that face! I mean, \(name)'s a woman, and I'm not supposed to say bad things, but really, folks, come on. Are we serious?", attributes: normalAttributes), NSAttributedString(string: "on Carly Fiorina" , attributes: subtitleAttributes))]
        cluelessArray += [(NSMutableAttributedString(string: "\(name) doesn't have a clue about life!", attributes: normalAttributes), NSAttributedString(string: "on Kareem Abdul-Jabbar" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "\(name) is ashamed of last name. A loser.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "\(name) can't negotiate the way out of a paper bag.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "I don’t think \(name)'s got the right temperament. I don’t think \(name)'s got the right judgment. A little bit of a maniac.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "\(name)'s a total low life. A dummy with no “it” factor. Will fade fast.", attributes: normalAttributes), NSAttributedString(string: "on Erick Erickson" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "Virtually incompetent.", attributes: normalAttributes), NSAttributedString(string: "on Cheri Jacobus" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "Once \(name) started talking, people realized the complete & total dud!", attributes: normalAttributes), NSAttributedString(string: "on John Kasich" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "Poor \(name) doesn't have what it takes.", attributes: normalAttributes), NSAttributedString(string: "on John Kasich" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Sadly, \(name)'s no longer a 10.", attributes: normalAttributes), NSAttributedString(string: "on Heidi Klum" , attributes: subtitleAttributes))]
        talkingtoomuchArray += [(NSMutableAttributedString(string: "\(name) pretends to be smart, but isn't. A dummy - an overrated clown!", attributes: normalAttributes), NSAttributedString(string: "on Charles Krauthammer" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "\(name)'s lost all self respect. \(name)'s very embarrassed to even walk down the street.", attributes: normalAttributes), NSAttributedString(string: "on Bill Kristol" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "There's something wrong with \(name).", attributes: normalAttributes), NSAttributedString(string: "on Barack Obama" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "\(name)'s like a little baby. Like a disgusting, little, weak, pathetic baby.", attributes: normalAttributes), NSAttributedString(string: "on Martin O'Malley" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "Truly weird \(name) reminds me of a spoiled brat without a properly functioning brain.", attributes: normalAttributes), NSAttributedString(string: "on Rand Paul" , attributes: subtitleAttributes))]
        loserArray += [(NSMutableAttributedString(string: "I easily beat \(name) on the golf course and will even more easily beat \(name) now, in the world.", attributes: normalAttributes), NSAttributedString(string: "on Rand Paul" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "Highly untalented \(name), a real dummy.", attributes: normalAttributes), NSAttributedString(string: "on Jennifer Rubin" , attributes: subtitleAttributes))]
        softArray += [(NSMutableAttributedString(string: "\(name) is like a little baby: soft, weak, little baby.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "Knitwit.", attributes: normalAttributes), NSAttributedString(string: "on Paul Ryan" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "\(name) is living in the world of make-believe.", attributes: normalAttributes), NSAttributedString(string: "on Chris Wallace" , attributes: subtitleAttributes))]
        unpopularArray += [(NSMutableAttributedString(string: "Now I know why people always treated \(name) so badly.", attributes: normalAttributes), NSAttributedString(string: "on Kareem Abdul-Jabbar" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "I have never seen a human being eat in such a disgusting fashion.", attributes: normalAttributes), NSAttributedString(string: "on John Kasich" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "\(name)'s one of the dumbest human beings I have ever seen.", attributes: normalAttributes), NSAttributedString(string: "on Lindsey Graham" , attributes: subtitleAttributes))]
        dummyArray += [(NSMutableAttributedString(string: "\(name)'s a lightweight - dumb as a rock.", attributes: normalAttributes), NSAttributedString(string: "on Don Lemon" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "If I looked like \(name), I'd struggle with depression, too.", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        embarassmentArray += [(NSMutableAttributedString(string: "I feel sorry for \(name)'s partner in love whose parents are devastated at the thought of their child being with a true loser.", attributes: normalAttributes), NSAttributedString(string: "on Rosie O'Donnell" , attributes: subtitleAttributes))]
        
        refreshButtonTitles()
    }

    
}
