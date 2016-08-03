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

class KeyboardViewController: UIInputViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Table consraints
    
    @IBOutlet weak var categoryTableViewHeaderTop: NSLayoutConstraint!
    @IBOutlet weak var categoryTableViewHeaderBottom: NSLayoutConstraint!
    var expandedCategoryTableViewHeaderTopConstraint: NSLayoutConstraint? = nil
    var expandedQuoteTableViewBottomConstraint: NSLayoutConstraint? = nil
    


    
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
    
    
    
    // Choose quote
    
    @IBOutlet weak var chooseQuoteView: UIView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var categoryHeader: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var expandCategoryButton: UIButton!
    
    
    // Ensure keyboard remembers last key, quote, name
    
    var lastRow = -1
    var lastCategorySelected = ""
    var selectedCategory = ""
    var lastCategoryDisplayed = ""
    var sectionExpanded = false
    var name = ""
    var shiftButtonPressed = false
    
    
    // Color scheme
    
    let navColor = UIColor(red: 136/255, green: 5/255, blue: 5/255, alpha: 1.0)
    let activeColor = UIColor(red: 223/255, green: 122/255, blue: 128/255, alpha: 0.5)
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
    
    var liarArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var weakArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var uglyArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var stupidArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var manipulativeArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var worthlessArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var bestArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var jealousArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var uptightArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var crazyArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var sleazyArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var whatArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var poorArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var meanArray: [(NSMutableAttributedString, NSAttributedString)] = []
    
    var buttonTitles = Dictionary<String,[(NSMutableAttributedString, NSAttributedString)]>()
    
    
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
        selectedCategory = categoryArray[0]
        lastCategoryDisplayed = selectedCategory
        nameEntryButton.setTitle("", forState: .Normal)
        
        
        // Set up name entry text field
        
        nameEntryButton.layer.borderColor = borderColor
        nameEntryButton.layer.cornerRadius = 10
        nameEntryButton.layer.borderWidth = 1
        nameEntryButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)
        nameEntryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        nameEntryButton.addTarget(self, action: "nameEntryButtonPressed:", forControlEvents: .TouchUpInside)
        
        nameLabel.attributedText = NSAttributedString(string: "Name...", attributes: inactiveTextAttributes)
        showNameLabel()
        
        
        
        self.view.autoresizesSubviews = true
        
        // Set up text keyboard in background
        
        backButton.addTarget(self, action: "nameEntryButtonDidEndEditing:", forControlEvents: .TouchUpInside)
        
        self.view.setNeedsLayout()
        self.textKeyboardRowOne.setNeedsLayout()
        self.textKeyboardRowTwo.setNeedsLayout()
        self.textKeyboardRowThree.setNeedsLayout()
        self.textKeyboardRowFour.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        
        textKeyboardView.addRowOfButtons(&textKeyboardRowOne, buttonTitles: textKeyboardView.buttonTitlesRowOne)
        textKeyboardView.addRowOfButtons(&textKeyboardRowTwo, buttonTitles: textKeyboardView.buttonTitlesRowTwo)
        textKeyboardView.addRowOfButtons(&textKeyboardRowThree, buttonTitles: textKeyboardView.buttonTitlesRowThree)
        textKeyboardView.addFinalRowOfButtons(&textKeyboardRowFour)
        
        textKeyboardView.addShiftButton(&textKeyboardRowThree)
        textKeyboardView.addDeleteButton(&textKeyboardRowThree)
        
        
        textKeyboardView.addIndividualButtonConstraints(&textKeyboardView.buttonsRowOne, mainView: textKeyboardRowOne)
        textKeyboardView.addIndividualButtonConstraints(&textKeyboardView.buttonsRowTwo, mainView: textKeyboardRowTwo)
        textKeyboardView.addIndividualButtonConstraints(&textKeyboardView.buttonsRowThree, mainView: textKeyboardRowThree)
        textKeyboardView.addFinalRowButtonConstraints(textKeyboardRowFour)
        textKeyboardView.addShiftButtonConstraints(textKeyboardRowThree)
        textKeyboardView.addDeleteButtonConstraints(textKeyboardRowThree)
        
        
        textKeyboardView.buttonsRowFour[0].addTarget(self, action: "nextKeyboardPressed:", forControlEvents: .TouchUpInside)
        textKeyboardView.buttonsRowFour[2].addTarget(self, action: "nameEntryButtonDidEndEditing:", forControlEvents: .TouchUpInside)
        textKeyboardView.shiftButton.addTarget(self, action: "shiftButtonPressed:", forControlEvents:. TouchUpInside)
        
        
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
        categoryLabel.text = selectedCategory
        
        let selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView2.selectRowAtIndexPath(selectedIndexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        
        nextKeyboard.addTarget(self, action: "buttonActive:", forControlEvents: .TouchDown)
        nextKeyboard.addTarget(self, action: "buttonInactive:", forControlEvents: .TouchDragExit)
        nextKeyboard.addTarget(self, action: "nextKeyboardPressed:", forControlEvents: .TouchUpInside)
    }
    
    //
    //
    // End of view loading method
    //
    //
    
    func nameEntryButtonPressed(button: UIButton) {    //delegate method
        
        backButton.backgroundColor = UIColor.whiteColor()
        nameLabel.hidden = true
        chooseQuoteView.hidden = true
        
        backButton.hidden = false
        textKeyboardView.hidden = false
        
        nameEntryButtonLeft.constant = 30.0
        
        UIView.animateWithDuration(0.2, animations: {
        self.nameView.layoutIfNeeded()
        })
 

        nameEntryButton.layer.borderColor = navColor.CGColor

        
        textKeyboardView.activeButton = nameEntryButton

    }
    
    func shiftButtonPressed(sender: AnyObject?) {
        if shiftButtonPressed {
            for subview in textKeyboardRowOne.subviews { subview.removeFromSuperview() }
            for subview in textKeyboardRowTwo.subviews { subview.removeFromSuperview() }
            for subview in textKeyboardRowThree.subviews { subview.removeFromSuperview() }
            textKeyboardView.addRowOfButtons(&textKeyboardRowOne, buttonTitles: textKeyboardView.buttonTitlesRowOne)
            textKeyboardView.addRowOfButtons(&textKeyboardRowTwo, buttonTitles: textKeyboardView.buttonTitlesRowTwo)
            textKeyboardView.addRowOfButtons(&textKeyboardRowThree, buttonTitles: textKeyboardView.buttonTitlesRowThree)
            textKeyboardView.addShiftButton(&textKeyboardRowThree)
            textKeyboardView.addDeleteButton(&textKeyboardRowThree)
            textKeyboardView.addIndividualButtonConstraints(&textKeyboardView.buttonsRowOne, mainView: textKeyboardRowOne)
            textKeyboardView.addIndividualButtonConstraints(&textKeyboardView.buttonsRowTwo, mainView: textKeyboardRowTwo)
            textKeyboardView.addIndividualButtonConstraints(&textKeyboardView.buttonsRowThree, mainView: textKeyboardRowThree)
            textKeyboardView.addShiftButtonConstraints(textKeyboardRowThree)
            textKeyboardView.addDeleteButtonConstraints(textKeyboardRowThree)
            
            textKeyboardView.buttonsRowFour[0].addTarget(self, action: "nextKeyboardPressed:", forControlEvents: .TouchUpInside)
            textKeyboardView.buttonsRowFour[2].addTarget(self, action: "nameEntryButtonDidEndEditing:", forControlEvents: .TouchUpInside)
            textKeyboardView.shiftButton.addTarget(self, action: "shiftButtonPressed:", forControlEvents:. TouchUpInside)
            
        } else {
            
            for subview in textKeyboardRowOne.subviews { subview.removeFromSuperview() }
            for subview in textKeyboardRowTwo.subviews { subview.removeFromSuperview() }
            for subview in textKeyboardRowThree.subviews { subview.removeFromSuperview() }
            textKeyboardView.addRowOfButtons(&textKeyboardRowOne, buttonTitles: textKeyboardView.shiftedButtonTitlesRowOne)
            textKeyboardView.addRowOfButtons(&textKeyboardRowTwo, buttonTitles: textKeyboardView.shiftedButtonTitlesRowTwo)
            textKeyboardView.addRowOfButtons(&textKeyboardRowThree, buttonTitles: textKeyboardView.shiftedButtonTitlesRowThree)
            textKeyboardView.addShiftButton(&textKeyboardRowThree)
            textKeyboardView.addDeleteButton(&textKeyboardRowThree)
            textKeyboardView.addIndividualButtonConstraints(&textKeyboardView.buttonsRowOne, mainView: textKeyboardRowOne)
            textKeyboardView.addIndividualButtonConstraints(&textKeyboardView.buttonsRowTwo, mainView: textKeyboardRowTwo)
            textKeyboardView.addIndividualButtonConstraints(&textKeyboardView.buttonsRowThree, mainView: textKeyboardRowThree)
            textKeyboardView.addShiftButtonConstraints(textKeyboardRowThree)
            textKeyboardView.addDeleteButtonConstraints(textKeyboardRowThree)
            
            textKeyboardView.buttonsRowFour[0].addTarget(self, action: "nextKeyboardPressed:", forControlEvents: .TouchUpInside)
            textKeyboardView.buttonsRowFour[2].addTarget(self, action: "nameEntryButtonDidEndEditing:", forControlEvents: .TouchUpInside)
            textKeyboardView.shiftButton.addTarget(self, action: "shiftButtonPressed:", forControlEvents:. TouchUpInside)
        }
        
        shiftButtonPressed = !shiftButtonPressed
    }
    
    func nameEntryButtonDidEndEditing(sender: AnyObject?) {
        name = textKeyboardView.activeButton!.titleForState(.Normal)!
        
        nameEntryButton.layer.borderColor = borderColor
        textKeyboardView.hidden = true
        backButton.hidden = true
        chooseQuoteView.hidden = false
        showNameLabel()
        
        nameEntryButtonLeft.constant = 10.0
        
        if name == "" {
            createInsultsWithoutName()
        } else {
            createInsultsWithName()
        }
        
        
        tableView1.reloadData()
        
        textKeyboardView.activeButton = nil


    }

    func showNameLabel() {
        if name == "" {
            nameLabel.hidden = false
        }
    }
    
    @IBAction func expandCategory() {
        if sectionExpanded {
            self.categoryLabel.text = lastCategoryDisplayed
            
            nameView.hidden = false
            
            NSLayoutConstraint.deactivateConstraints([expandedCategoryTableViewHeaderTopConstraint!, expandedQuoteTableViewBottomConstraint!])
            NSLayoutConstraint.activateConstraints([categoryTableViewHeaderBottom, categoryTableViewHeaderTop])
            
            UIView.animateWithDuration(0.2, animations: {
                self.view.layoutIfNeeded()
            })
            sectionExpanded = false
            self.arrowIcon.transform = CGAffineTransformMakeScale(1,1)
            
        } else {
            self.categoryLabel.text = ""
            
            nameView.hidden = true
            
            NSLayoutConstraint.deactivateConstraints([categoryTableViewHeaderBottom, categoryTableViewHeaderTop])
            
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
            
            expandedQuoteTableViewBottomConstraint =
            NSLayoutConstraint(
                item: self.tableView1,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Bottom,
                multiplier: 1,
                constant: 0
            )
            expandedQuoteTableViewBottomConstraint!.identifier = "New Quote Table Bottom - Parent View Bottom"
            
            self.view.addConstraints([expandedCategoryTableViewHeaderTopConstraint!, expandedQuoteTableViewBottomConstraint!])
            
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
            return buttonTitles[selectedCategory]!.count
        } else {
            return buttonTitles.count

        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        if tableView == tableView1 {
            let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell")
            
            var categoryQuotes = self.buttonTitles[selectedCategory]
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
            var categoryQuotes = self.buttonTitles[selectedCategory]
            let quote = categoryQuotes![indexPath.row]
            let string = quote.0.string
            
            if lastRow != -1 {
                let lastCategoryQuotes = self.buttonTitles[lastCategorySelected]
                let lastQuote = lastCategoryQuotes![lastRow]
                let lastString = lastQuote.0.string
                let lastStringLength = lastString.characters.count
                for var i = lastStringLength; i > 0; --i {
                    (textDocumentProxy as UIKeyInput).deleteBackward()
                }
          
                if lastRow == indexPath.row && lastCategorySelected == selectedCategory {
                    self.tableView1.deselectRowAtIndexPath(indexPath, animated: false)
                    lastRow = -1
                    lastCategorySelected = ""
                } else {
                    (textDocumentProxy as UIKeyInput).insertText("\(string)")
                    lastRow = indexPath.row
                    lastCategorySelected = selectedCategory
                }
                
                lastCategoryDisplayed = selectedCategory
                
            } else {
                (textDocumentProxy as UIKeyInput).insertText("\(string)")
                lastRow = indexPath.row
                lastCategorySelected = selectedCategory
            }
        } else {
                var categoryArray = Array(self.buttonTitles.keys).sort(<)
                selectedCategory = categoryArray[indexPath.row]
                if lastCategoryDisplayed != selectedCategory {
                    categoryLabel.text = selectedCategory
                    lastCategoryDisplayed = selectedCategory
                    tableView1.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Right)
                }
        expandCategory()
        }
        
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == tableView1 {
                var categoryQuotes = self.buttonTitles[selectedCategory]
                let quote = categoryQuotes![indexPath.row]
                let string = quote.0.string + "- " + quote.1.string
                let stringLength = string.characters.count
                for var i = stringLength; i > 0; --i {
                    (textDocumentProxy as UIKeyInput).deleteBackward()
                }
        }
    }
   
    func buttonActive(button: UIButton) {
        button.backgroundColor = activeColor
    }
    
    func buttonInactive(button: UIButton) {
        button.backgroundColor = navColor
    }

    func nextKeyboardPressed(button: UIButton) {
        advanceToNextInputMode()
    }
    

    
    func createInsultsWithoutName() {
        
        liarArray.removeAll()
        weakArray.removeAll()
        uglyArray.removeAll()
        stupidArray.removeAll()
        manipulativeArray.removeAll()
        worthlessArray.removeAll()
        bestArray.removeAll()
        jealousArray.removeAll()
        uptightArray.removeAll()
        crazyArray.removeAll()
        sleazyArray.removeAll()
        whatArray.removeAll()
        poorArray.removeAll()
        meanArray.removeAll()
        
        liarArray += [(NSMutableAttributedString(string: "Crooked!", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "Your temperament is weak.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You don't even look presidential.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You suffer from plain old bad judgement.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You have zero imagination and even less stamina.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You have ZERO leadership ability.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        manipulativeArray += [(NSMutableAttributedString(string: "You're constantly playing the women's card - it is sad!", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're one of the all time great enablers!", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "Who should star in a reboot of Liar Liar - you or Ted Cruz? Let me know.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "You're a major national security risk.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're totally incompetent as a manager and leader.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You want to look cool, but it's far too late.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You're by far the weakest of the lot.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        jealousArray += [(NSMutableAttributedString(string: "You will do anything to stay at the trough.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        uptightArray += [(NSMutableAttributedString(string: "You should go home and relax!", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're a total embarassment to yourself and your family.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're bottom (and gone), I'm top (by a lot).", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "You really went wacko today.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're mathematically dead and totally desperate.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "All you can do is be a spoiler, never a nice thing to do.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "You lie like a dog-over and over again!", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "You're a world class LIAR!", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "You're the worst liar, crazy or very dishonest.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You will fall like all others.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "If I listen to you for more than ten minutes straight, I develop a massive headache.", attributes: normalAttributes), NSAttributedString(string: "on Carly Fiorina" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "YOU'RE ALL TALK AND NO ACTION!", attributes: normalAttributes), NSAttributedString(string: "on Lindsey Graham" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You're a dumb mouthpiece.", attributes: normalAttributes), NSAttributedString(string: "on Lindsey Graham" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "I will sue you just for fun!", attributes: normalAttributes), NSAttributedString(string: "on John Kasich" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You couldn't be elected dog catcher.", attributes: normalAttributes), NSAttributedString(string: "on George Pataki" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You didn't get the right gene.", attributes: normalAttributes), NSAttributedString(string: "on Rand Paul" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "You should be forced to take an IQ test.", attributes: normalAttributes), NSAttributedString(string: "on Rick Perry" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You will never MAKE AMERICA GREAT AGAIN!", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You look like a little boy on stage.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You couldn't even respond properly without pouring sweat & chugging water.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You're a perfect little puppet.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You've never made ten cents.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You know nothing about finance.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "I know more about you than you knows about yourself.", attributes: normalAttributes), NSAttributedString(string: "on Cory Booker" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "You're the WORST abuser of women in US history.", attributes: normalAttributes), NSAttributedString(string: "on Bill Clinton" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "YOU DEMONSTRATED A PENCHANT FOR SEXISM.", attributes: normalAttributes), NSAttributedString(string: "on Bill Clinton" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You're a crude dope!", attributes: normalAttributes), NSAttributedString(string: "on Michael Nutter" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You look and sound so ridiculous.", attributes: normalAttributes), NSAttributedString(string: "on Barack Obama" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "You have a career that is totally based on a lie.", attributes: normalAttributes), NSAttributedString(string: "on Elizabeth Warren" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "Perv sleazebag.", attributes: normalAttributes), NSAttributedString(string: "on Anthony Weiner" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You should focus on all of the problems that you've caused with your ineptitude.", attributes: normalAttributes), NSAttributedString(string: "on Bill de Blasio" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "The people of South Carolina are embarrassed by you!", attributes: normalAttributes), NSAttributedString(string: "on Nikki Haley" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "All you do is talk, talk, talk, but you're incapable of doing anything.", attributes: normalAttributes), NSAttributedString(string: "on John McCain" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You choked like a dog.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You're a mixed up person who doesn't have a clue.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You're the person who choked and let us all down.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're a total joke, and everyone knows it!", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You are so awkward and goofy.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "I don't need your angry advice!", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        whatArray += [(NSMutableAttributedString(string: "You look more like a gym rat than a U.S. Senator.", attributes: normalAttributes), NSAttributedString(string: "on Ben Sasse" , attributes: subtitleAttributes))]
        whatArray += [(NSMutableAttributedString(string: "You forgot to mention my phenomenal biz success rate.", attributes: normalAttributes), NSAttributedString(string: "on John Sununu" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You're a failing, crying, lost soul!", attributes: normalAttributes), NSAttributedString(string: "on Glenn Beck" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "You're a mental basketcase.", attributes: normalAttributes), NSAttributedString(string: "on Glenn Beck" , attributes: subtitleAttributes))]
        whatArray += [(NSMutableAttributedString(string: "You always seem to be crying.", attributes: normalAttributes), NSAttributedString(string: "on Glenn Beck" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Lightweight, you come to my office begging for money like a dog.", attributes: normalAttributes), NSAttributedString(string: "on Brent Bozell" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "I consider you one of the dumbest of all pundits- you have no sense of the real world!", attributes: normalAttributes), NSAttributedString(string: "on David Brooks" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You're closing in on being the dumbest of them all. You don't have a clue.", attributes: normalAttributes), NSAttributedString(string: "on David Brooks" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You have been so wrong & you hate it!", attributes: normalAttributes), NSAttributedString(string: "on Carl Cameron" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You have been largely forgotten.", attributes: normalAttributes), NSAttributedString(string: "on Katie Couric" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You're a totally biased loser who doesn't have a clue.", attributes: normalAttributes), NSAttributedString(string: "on S.E. Cupp" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're hard to watch, zero talent!", attributes: normalAttributes), NSAttributedString(string: "on S.E. Cupp" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "You're a major sleaze and buffoon.", attributes: normalAttributes), NSAttributedString(string: "on Erick Erickson" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Uncomfortable looking!", attributes: normalAttributes), NSAttributedString(string: "on Willie Geist" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "You just don't know about winning! But you're a nice person.", attributes: normalAttributes), NSAttributedString(string: "on Bernard Goldberg" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Sleepy Eyes!", attributes: normalAttributes), NSAttributedString(string: "on Bernard Goldberg" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You're not smart enough to know what's going on at the border.", attributes: normalAttributes), NSAttributedString(string: "on Mary Katharine Ham" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're just a 3rd rate 'gotcha' guy!", attributes: normalAttributes), NSAttributedString(string: "on Hugh Hewitt" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "You wouldn't know the truth if it hit you in the face.", attributes: normalAttributes), NSAttributedString(string: "on Jeff Horwitz" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "Liberal clown.", attributes: normalAttributes), NSAttributedString(string: "on Arianna Huffington" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "Dope!", attributes: normalAttributes), NSAttributedString(string: "on Brit Hume" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "You're so average in so many ways!", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're sick, & the most overrated person!", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "Get a life!", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "I refuse to call you a bimbo, because that would not be politically correct.", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You're very bad at math.", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You should take another eleven day 'unscheduled' vacation.", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "No focus, poor level of concentration!", attributes: normalAttributes), NSAttributedString(string: "on Ruth Marcus" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "I think you should have gone to prison for what you did.", attributes: normalAttributes), NSAttributedString(string: "on Steve Rattner" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "Not much power or insight!", attributes: normalAttributes), NSAttributedString(string: "on Joe Scarborough" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You're a major lightweight with no credibility.", attributes: normalAttributes), NSAttributedString(string: "on Ben Schreckinger" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "Hater & racist.", attributes: normalAttributes), NSAttributedString(string: "on Tavis Smiley" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You should be ashamed of yourself.", attributes: normalAttributes), NSAttributedString(string: "on Shep Smith" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "Really dumb puppet.", attributes: normalAttributes), NSAttributedString(string: "on Marc Threaten (sic)" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "Sleepy eyes, you will be fired like a dog. I can't imagine what is taking so long!", attributes: normalAttributes), NSAttributedString(string: "on Chuck Todd" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "Hokey garbage.", attributes: normalAttributes), NSAttributedString(string: "on Penn Jillette" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "Goofball atheist.", attributes: normalAttributes), NSAttributedString(string: "on Penn Jillette" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "Not a nice person!", attributes: normalAttributes), NSAttributedString(string: "on Rounda Rousey" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "A total waste of money!", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush's campaign" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "Very gentle and soft.", attributes: normalAttributes), NSAttributedString(string: "on Democratic candidates" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "Low level degenerate.", attributes: normalAttributes), NSAttributedString(string: "on ISIS" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "All bull...all talk and no action.", attributes: normalAttributes), NSAttributedString(string: "on other candidates" , attributes: subtitleAttributes))]
        manipulativeArray += [(NSMutableAttributedString(string: "You're an expert in never facing any consequence.", attributes: normalAttributes), NSAttributedString(string: "on politicians" , attributes: subtitleAttributes))]
        
        buttonTitles["Liar"] = liarArray
        buttonTitles["Weak"] = weakArray
        buttonTitles["Ugly"] = uglyArray
        buttonTitles["Stupid"] = stupidArray
        buttonTitles["Manipulative"] = manipulativeArray
        buttonTitles["Worthless"] = worthlessArray
        buttonTitles["The Best"] = bestArray
        buttonTitles["Jealous"] = jealousArray
        buttonTitles["Uptight"] = uptightArray
        buttonTitles["Crazy"] = crazyArray
        buttonTitles["Sleazy"] = sleazyArray
        buttonTitles["What?"] = whatArray
        buttonTitles["Poor"] = poorArray
        buttonTitles["Mean"] = meanArray
    }
    
    func createInsultsWithName() {
        
        liarArray.removeAll()
        weakArray.removeAll()
        uglyArray.removeAll()
        stupidArray.removeAll()
        manipulativeArray.removeAll()
        worthlessArray.removeAll()
        bestArray.removeAll()
        jealousArray.removeAll()
        uptightArray.removeAll()
        crazyArray.removeAll()
        sleazyArray.removeAll()
        whatArray.removeAll()
        poorArray.removeAll()
        meanArray.removeAll()
        
        liarArray += [(NSMutableAttributedString(string: "Crooked \(name)!", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s temperament is weak.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "\(name) doesn't even look presidential.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name) suffers from plain old bad judgement.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) has zero imagination and even less stamina.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) has ZERO leadership ability.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        manipulativeArray += [(NSMutableAttributedString(string: "\(name)'s constantly playing the women's card - it is sad!", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s one of the all time great enablers!", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "Who should star in a reboot of Liar Liar - \(name) or Ted Cruz? Let me know.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "\(name)'s a major national security risk.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s totally incompetent as a manager and leader.", attributes: normalAttributes), NSAttributedString(string: "on Hillary Clinton" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "\(name) wants to look cool, but it's far too late.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s by far the weakest of the lot.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        jealousArray += [(NSMutableAttributedString(string: "\(name) will do anything to stay at the trough.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        uptightArray += [(NSMutableAttributedString(string: "\(name) should go home and relax!", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s a total embarassment to themselves and their family.", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s bottom (and gone), I'm top (by a lot).", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "\(name) really went wacko today.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s mathematically dead and totally desparate.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "All \(name) can do is be a spoiler, never a nice thing to do.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "\(name) lies like a dog-over and over again!", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "\(name) is a world class LIAR!", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "\(name)'s the worst liar, crazy or very dishonest", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) will fall like all others.", attributes: normalAttributes), NSAttributedString(string: "on Ted Cruz" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "If I listen to \(name) for more than ten minutes straight, I develop a massive headache.", attributes: normalAttributes), NSAttributedString(string: "on Carly Fiorina" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) - ALL TALK AND NO ACTION!", attributes: normalAttributes), NSAttributedString(string: "on Lindsey Graham" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s a dumb mouthpiece.", attributes: normalAttributes), NSAttributedString(string: "on Lindsey Graham" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "I will sue \(name) just for fun!", attributes: normalAttributes), NSAttributedString(string: "on John Kasich" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) couldn't be elected dog catcher", attributes: normalAttributes), NSAttributedString(string: "on George Pataki" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) didn't get the right gene.", attributes: normalAttributes), NSAttributedString(string: "on Rand Paul" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "\(name) should be forced to take an IQ test.", attributes: normalAttributes), NSAttributedString(string: "on Rick Perry" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) will never MAKE AMERICA GREAT AGAIN!", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) looks like a little boy on stage.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) couldn't even respond properly without pouring sweat and chugging water.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s a perfect little puppet.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s never made ten cents.", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name) knows nothing about finance", attributes: normalAttributes), NSAttributedString(string: "on Marco Rubio" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "I know more about \(name) than they knows about themselves.", attributes: normalAttributes), NSAttributedString(string: "on Cory Booker" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "\(name)'s the WORST abuser of woman in U.S. political history.", attributes: normalAttributes), NSAttributedString(string: "on Bill Clinton" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "\(name) DEMONSTRATED A PENCHANT FOR SEXISM.", attributes: normalAttributes), NSAttributedString(string: "on Bill Clinton" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s a crude dope!", attributes: normalAttributes), NSAttributedString(string: "on Michael Nutter" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "\(name) looks and sounds so ridiculous.", attributes: normalAttributes), NSAttributedString(string: "on Barack Obama" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "\(name) has a career that is totally based on a lie.", attributes: normalAttributes), NSAttributedString(string: "on Elizabeth Warren" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "Perv sleazebag.", attributes: normalAttributes), NSAttributedString(string: "on Anthony Weiner" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) should focus on all of the problems that they've caused with their ineptitude.", attributes: normalAttributes), NSAttributedString(string: "on Bill de Blasio" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "The people of South Carolina are embarrassed by \(name)!", attributes: normalAttributes), NSAttributedString(string: "on Nikki Haley" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "All \(name) does is talk, talk, talk, but they're incapable of doing anything.", attributes: normalAttributes), NSAttributedString(string: "on John McCain" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) choked like a dog.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s a mixed up person who doesn't have a clue.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s the person who choked and let us all down.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s a total joke, and everyone knows it!", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s so awkward and goofy.", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "I don't need \(name)'s angry advice!", attributes: normalAttributes), NSAttributedString(string: "on Mitt Romney" , attributes: subtitleAttributes))]
        whatArray += [(NSMutableAttributedString(string: "\(name) looks more like a gym rat than a U.S. Senator.", attributes: normalAttributes), NSAttributedString(string: "on Ben Sasse" , attributes: subtitleAttributes))]
        whatArray += [(NSMutableAttributedString(string: "\(name) forgot to mention my phenomenal biz success rate.", attributes: normalAttributes), NSAttributedString(string: "on John Sununu" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s a failing, crying, lost soul!", attributes: normalAttributes), NSAttributedString(string: "on Glenn Beck" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "\(name)'s a mental basketcase.", attributes: normalAttributes), NSAttributedString(string: "on Glenn Beck" , attributes: subtitleAttributes))]
        whatArray += [(NSMutableAttributedString(string: "\(name) always seems to be crying.", attributes: normalAttributes), NSAttributedString(string: "on Glenn Beck" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Lightweight, \(name) comes to my office begging for money like a dog.", attributes: normalAttributes), NSAttributedString(string: "on Brent Bozell" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "I consider \(name) one of the dumbest of all pundits- \(name) has no sense of the real world!", attributes: normalAttributes), NSAttributedString(string: "on David Brooks" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s closing in on being the dumbest of them all. \(name) doesn't have a clue.", attributes: normalAttributes), NSAttributedString(string: "on David Brooks" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s been so wrong & hates it!", attributes: normalAttributes), NSAttributedString(string: "on Carl Cameron" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) has been largely forgotten.", attributes: normalAttributes), NSAttributedString(string: "on Katie Couric" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s a totally biased loser who doesn't have a clue.", attributes: normalAttributes), NSAttributedString(string: "on S.E. Cupp" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s hard to watch, zero talent!", attributes: normalAttributes), NSAttributedString(string: "on S.E. Cupp" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "\(name)'s a major sleaze and buffoon.", attributes: normalAttributes), NSAttributedString(string: "on Erick Erickson" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Uncomfortable looking, \(name)!", attributes: normalAttributes), NSAttributedString(string: "on Willie Geist" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "\(name) just doesn't know about winning! But a nice person.", attributes: normalAttributes), NSAttributedString(string: "on Bernard Goldberg" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Sleepy Eyes, \(name)!", attributes: normalAttributes), NSAttributedString(string: "on Bernard Goldberg" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s not smart enough to know what's going on at the border.", attributes: normalAttributes), NSAttributedString(string: "on Mary Katharine Ham" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s just a 3rd rate 'gotcha' guy!", attributes: normalAttributes), NSAttributedString(string: "on Hugh Hewitt" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "\(name) wouldn't know the truth if it hit them in the face.", attributes: normalAttributes), NSAttributedString(string: "on Jeff Horwitz" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "Liberal clown.", attributes: normalAttributes), NSAttributedString(string: "on Arianna Huffington" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "Dope!", attributes: normalAttributes), NSAttributedString(string: "on Brit Hume" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "\(name)'s so average in so many ways!", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s sick, & the most overrated person!", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name), get a life!", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "I refuse to call \(name) a bimbo, because that would not be politically correct.", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s very bad at math.", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) should take another eleven day 'unscheduled' vacation.", attributes: normalAttributes), NSAttributedString(string: "on Megyn Kelly" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "No focus, poor level of concentration!", attributes: normalAttributes), NSAttributedString(string: "on Ruth Marcus" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "I think \(name) should have gone to prison for what they did.", attributes: normalAttributes), NSAttributedString(string: "on Steve Rattner" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "Not much power or insight!", attributes: normalAttributes), NSAttributedString(string: "on Joe Scarborough" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s a major lightweight with no credibility.", attributes: normalAttributes), NSAttributedString(string: "on Ben Schreckinger" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "Hater & racist.", attributes: normalAttributes), NSAttributedString(string: "on Tavis Smiley" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) should be ashamed of themselves.", attributes: normalAttributes), NSAttributedString(string: "on Shep Smith" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "Really dumb puppet.", attributes: normalAttributes), NSAttributedString(string: "on Marc Threaten (sic)" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "Sleepy eyes \(name) will be fired like a dog. I can't imagine what is taking so long!", attributes: normalAttributes), NSAttributedString(string: "on Chuck Todd" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s hokey garbage.", attributes: normalAttributes), NSAttributedString(string: "on Penn Jillette" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s a goofball atheist.", attributes: normalAttributes), NSAttributedString(string: "on Penn Jillette" , attributes: subtitleAttributes))]
        meanArray += [(NSMutableAttributedString(string: "\(name)'s not a nice person!", attributes: normalAttributes), NSAttributedString(string: "on Rounda Rousey" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s a total waste of money!", attributes: normalAttributes), NSAttributedString(string: "on Jeb Bush's campaign" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s very gentle and soft.", attributes: normalAttributes), NSAttributedString(string: "on Democratic candidates" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s a low level degenerate.", attributes: normalAttributes), NSAttributedString(string: "on ISIS" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "\(name)'s all bull...all talk and no action.", attributes: normalAttributes), NSAttributedString(string: "on Other candidates" , attributes: subtitleAttributes))]
        manipulativeArray += [(NSMutableAttributedString(string: "\(name)'s an expert in never facing any consequence.", attributes: normalAttributes), NSAttributedString(string: "on Politicians" , attributes: subtitleAttributes))]
        
        buttonTitles["Liar"] = liarArray
        buttonTitles["Weak"] = weakArray
        buttonTitles["Ugly"] = uglyArray
        buttonTitles["Stupid"] = stupidArray
        buttonTitles["Manipulative"] = manipulativeArray
        buttonTitles["Worthless"] = worthlessArray
        buttonTitles["The Best"] = bestArray
        buttonTitles["Jealous"] = jealousArray
        buttonTitles["Uptight"] = uptightArray
        buttonTitles["Crazy"] = crazyArray
        buttonTitles["Sleazy"] = sleazyArray
        buttonTitles["What?"] = whatArray
        buttonTitles["Poor"] = poorArray
        buttonTitles["Mean"] = meanArray
    }

    
}
