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
    
    // Consraints
    
    @IBOutlet weak var nameEntryTextFieldLeft: NSLayoutConstraint!
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
    @IBOutlet weak var deleteButton: UIButton!
    
    
    // Name input
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameEntryTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backButton: Draw2D!
    
    
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
    var wasDeleteLastKey = 0
    var lastCategorySelected = ""
    var selectedCategory = ""
    var lastCategoryDisplayed = ""
    var sectionExpanded = false
    var name = ""
    
    
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
    
    // Creating buttons for text keyboard
    
    let buttonTitlesRowOne = ["q","w","e","r","t","y","u","i","o","p"]
    let buttonTitlesRowTwo = ["a","s","d","f","g","h","j","k","l"]
    let buttonTitlesRowThree = ["z","x","c","v","b","n","m"]
    let buttonTitlesRowFour = ["CHG", "Space", "Trump 'Em"]
    var buttonsRowOne = [UIButton]()
    var buttonsRowTwo = [UIButton]()
    var buttonsRowThree = [UIButton]()
    var buttonsRowFour = [UIButton]()
    
    
    
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
        
        // Set up name entry text field
        
        nameEntryTextField.layer.borderColor = borderColor
        nameEntryTextField.layer.cornerRadius = 10
        nameEntryTextField.layer.borderWidth = 1
        
        nameEntryTextField.delegate = self
        
        nameLabel.attributedText = NSAttributedString(string: "Name...", attributes: inactiveTextAttributes)
        showNameLabel()
        
        
        // Set up text keyboard in background
        
        backButton.userInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("backButtonPressed"))
        backButton.addGestureRecognizer(gestureRecognizer)
        
        self.view.setNeedsLayout()
        self.textKeyboardRowOne.setNeedsLayout()
        self.textKeyboardRowTwo.setNeedsLayout()
        self.textKeyboardRowThree.setNeedsLayout()
        self.textKeyboardRowFour.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        
        textKeyboardView.addRowOfButtons(&textKeyboardRowOne, buttonTitles: buttonTitlesRowOne, buttons: &buttonsRowOne)
        textKeyboardView.addRowOfButtons(&textKeyboardRowTwo, buttonTitles: buttonTitlesRowTwo, buttons: &buttonsRowTwo)
        textKeyboardView.addRowOfButtons(&textKeyboardRowThree, buttonTitles: buttonTitlesRowThree, buttons: &buttonsRowThree)
        textKeyboardView.addFinalRowOfButtons(&textKeyboardRowFour, buttonTitles: buttonTitlesRowFour, buttons: &buttonsRowFour)
        textKeyboardView.addIndividualButtonConstraints(&buttonsRowOne, mainView: textKeyboardRowOne)
        textKeyboardView.addIndividualButtonConstraints(&buttonsRowTwo, mainView: textKeyboardRowTwo)
        textKeyboardView.addIndividualButtonConstraints(&buttonsRowThree, mainView: textKeyboardRowThree)
        textKeyboardView.addFinalRowButtonConstraints(&buttonsRowFour, mainView: textKeyboardRowFour)
        
        
        buttonsRowFour[0].addTarget(self, action: "nextKeyboardPressed:", forControlEvents: .TouchUpInside)
        buttonsRowFour[2].addTarget(self, action: "trumpButtonPressed:", forControlEvents: .TouchUpInside)
        
        backButton.hidden = true
        textKeyboardView.hidden = true
        self.view.autoresizesSubviews = true
        
        
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
        
        deleteButton.addTarget(self, action: "buttonActive:", forControlEvents: .TouchDown)
        deleteButton.addTarget(self, action: "buttonInactive:", forControlEvents: .TouchDragExit)
        deleteButton.addTarget(self, action: "deletePressed:", forControlEvents: .TouchUpInside)
        deleteButton.addTarget(self, action: "buttonInactive:", forControlEvents: .TouchUpInside)
    }
    
    //
    //
    // End of view loading method
    //
    //
    
    func trumpButtonPressed(sender: AnyObject?) {
        nameEntryTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        
        backButton.backgroundColor = UIColor.whiteColor()
        nameLabel.hidden = true
        chooseQuoteView.hidden = true
        
        backButton.hidden = false
        textKeyboardView.hidden = false
        
        nameEntryTextFieldLeft.constant = 30
        nameEntryTextField.layer.borderColor = activeColor.CGColor
        UIView.animateWithDuration(0.2, animations: {
            self.nameEntryTextField.layoutIfNeeded()
        })
        
        textKeyboardView.activeTextField = nameEntryTextField

    }
    
    func textFieldDidEndEditing(textField: UITextField) {  //delegate method

        
        nameEntryTextField.layer.borderColor = borderColor
        textKeyboardView.hidden = true
        backButton.hidden = true
        showNameLabel()
        chooseQuoteView.hidden = false
        
        nameEntryTextFieldLeft.constant = 10
        nameEntryTextField.layoutIfNeeded()
        name = nameEntryTextField.text!
        
        if nameEntryTextField.text == "" && !nameEntryTextField.isFirstResponder() {
            createInsultsWithoutName()
        } else {
            createInsultsWithName()
        }
        
        
        tableView1.reloadData()
        
        textKeyboardView.activeTextField = nil

    }

    func showNameLabel() {
        if nameEntryTextField.text == "" && !nameEntryTextField.isFirstResponder() {
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
            let string = quote.0.string + "- " + quote.1.string
            
            if lastRow != -1 {
                let lastCategoryQuotes = self.buttonTitles[lastCategorySelected]
                let lastQuote = lastCategoryQuotes![lastRow]
                let lastString = lastQuote.0.string + "- " + lastQuote.1.string
                let lastStringLength = lastString.characters.count - wasDeleteLastKey
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
                wasDeleteLastKey = 0
                
            } else {
                (textDocumentProxy as UIKeyInput).insertText("\(string)")
                wasDeleteLastKey = 0
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
                let stringLength = string.characters.count - wasDeleteLastKey
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
    
    func deletePressed(button: UIButton) {
        (textDocumentProxy as UIKeyInput).deleteBackward()
        wasDeleteLastKey = wasDeleteLastKey + 1
    }
    
    func backButtonPressed() {
        nameEntryTextField.resignFirstResponder()
        backButton.backgroundColor = activeColor
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
        
        liarArray += [(NSMutableAttributedString(string: "Crooked!\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "Your temperament is weak.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You don't even look presidential.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You suffer from plain old bad judgement.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You have zero imagination and even less stamina.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You have ZERO leadership ability.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        manipulativeArray += [(NSMutableAttributedString(string: "You're constantly playing the women's card - it is sad!\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're one of the all time great enablers!\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "Who should star in a reboot of Liar Liar - you or Ted Cruz? Let me know.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "You're a major national security risk.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're totally incompetent as a manager and leader.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You want to look cool, but it's far too late.\n", attributes: normalAttributes), NSAttributedString(string: "Jeb Bush" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You're by far the weakest of the lot.\n", attributes: normalAttributes), NSAttributedString(string: "Jeb Bush" , attributes: subtitleAttributes))]
        jealousArray += [(NSMutableAttributedString(string: "You will do anything to stay at the trough.\n", attributes: normalAttributes), NSAttributedString(string: "Jeb Bush" , attributes: subtitleAttributes))]
        uptightArray += [(NSMutableAttributedString(string: "You should go home and relax!\n", attributes: normalAttributes), NSAttributedString(string: "Jeb Bush" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're a total embarassment to yourself and your family.\n", attributes: normalAttributes), NSAttributedString(string: "Jeb Bush" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're bottom (and gone), I'm top (by a lot).\n", attributes: normalAttributes), NSAttributedString(string: "Jeb Bush" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "You really went wacko today.\n", attributes: normalAttributes), NSAttributedString(string: "Ted Cruz" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're mathematically dead and totally desperate.\n", attributes: normalAttributes), NSAttributedString(string: "Ted Cruz" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "All you can do is be a spoiler, never a nice thing to do.\n", attributes: normalAttributes), NSAttributedString(string: "Ted Cruz" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "You lie like a dog-over and over again!\n", attributes: normalAttributes), NSAttributedString(string: "Ted Cruz" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "You're a world class LIAR!\n", attributes: normalAttributes), NSAttributedString(string: "Ted Cruz" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "You're the worst liar, crazy or very dishonest.\n", attributes: normalAttributes), NSAttributedString(string: "Ted Cruz" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You will fall like all others.\n", attributes: normalAttributes), NSAttributedString(string: "Ted Cruz" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "If I listen to you for more than ten minutes straight, I develop a massive headache.\n", attributes: normalAttributes), NSAttributedString(string: "Carly Fiorina" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "YOU'RE ALL TALK AND NO ACTION!\n", attributes: normalAttributes), NSAttributedString(string: "Lindsey Graham" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You're a dumb mouthpiece.\n", attributes: normalAttributes), NSAttributedString(string: "Lindsey Graham" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "I will sue you just for fun!\n", attributes: normalAttributes), NSAttributedString(string: "John Kasich" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You couldn't be elected dog catcher.\n", attributes: normalAttributes), NSAttributedString(string: "George Pataki" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You didn't get the right gene.\n", attributes: normalAttributes), NSAttributedString(string: "Rand Paul" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "You should be forced to take an IQ test.\n", attributes: normalAttributes), NSAttributedString(string: "Rick Perry" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You will never MAKE AMERICA GREAT AGAIN!\n", attributes: normalAttributes), NSAttributedString(string: "Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You look like a little boy on stage.\n", attributes: normalAttributes), NSAttributedString(string: "Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You couldn't even respond properly without pouring sweat & chugging water.\n", attributes: normalAttributes), NSAttributedString(string: "Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You're a perfect little puppet.\n", attributes: normalAttributes), NSAttributedString(string: "Marco Rubio" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You've never made ten cents.\n", attributes: normalAttributes), NSAttributedString(string: "Marco Rubio" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You know nothing about finance.\n", attributes: normalAttributes), NSAttributedString(string: "Marco Rubio" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "I know more about you than you knows about yourself.\n", attributes: normalAttributes), NSAttributedString(string: "Cory Booker" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "You're the WORST abuser of women in US history.\n", attributes: normalAttributes), NSAttributedString(string: "Bill Clinton" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "YOU DEMONSTRATED A PENCHANT FOR SEXISM.\n", attributes: normalAttributes), NSAttributedString(string: "Bill Clinton" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You're a crude dope!\n", attributes: normalAttributes), NSAttributedString(string: "Michael Nutter" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You look and sound so ridiculous.\n", attributes: normalAttributes), NSAttributedString(string: "Barack Obama" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "You have a career that is totally based on a lie.\n", attributes: normalAttributes), NSAttributedString(string: "Elizabeth Warren" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "Perv sleazebag.\n", attributes: normalAttributes), NSAttributedString(string: "Anthony Weiner" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You should focus on all of the problems that you've caused with your ineptitude.\n", attributes: normalAttributes), NSAttributedString(string: "Bill de Blasio" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "The people of South Carolina are embarrassed by you!\n", attributes: normalAttributes), NSAttributedString(string: "Nikki Haley" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "All you do is talk, talk, talk, but you're incapable of doing anything.\n", attributes: normalAttributes), NSAttributedString(string: "John McCain" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You choked like a dog.\n", attributes: normalAttributes), NSAttributedString(string: "Mitt Romney" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You're a mixed up person who doesn't have a clue.\n", attributes: normalAttributes), NSAttributedString(string: "Mitt Romney" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You're the person who choked and let us all down.\n", attributes: normalAttributes), NSAttributedString(string: "Mitt Romney" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're a total joke, and everyone knows it!\n", attributes: normalAttributes), NSAttributedString(string: "Mitt Romney" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You are so awkward and goofy.\n", attributes: normalAttributes), NSAttributedString(string: "Mitt Romney" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "I don't need your angry advice!\n", attributes: normalAttributes), NSAttributedString(string: "Mitt Romney" , attributes: subtitleAttributes))]
        whatArray += [(NSMutableAttributedString(string: "You look more like a gym rat than a U.S. Senator.\n", attributes: normalAttributes), NSAttributedString(string: "Ben Sasse" , attributes: subtitleAttributes))]
        whatArray += [(NSMutableAttributedString(string: "You forgot to mention my phenomenal biz success rate.\n", attributes: normalAttributes), NSAttributedString(string: "John Sununu" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You're a failing, crying, lost soul!\n", attributes: normalAttributes), NSAttributedString(string: "Glenn Beck" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "You're a mental basketcase.\n", attributes: normalAttributes), NSAttributedString(string: "Glenn Beck" , attributes: subtitleAttributes))]
        whatArray += [(NSMutableAttributedString(string: "You always seem to be crying.\n", attributes: normalAttributes), NSAttributedString(string: "Glenn Beck" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Lightweight, you come to my office begging for money like a dog.\n", attributes: normalAttributes), NSAttributedString(string: "Brent Bozell" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "I consider you one of the dumbest of all pundits- you have no sense of the real world!\n", attributes: normalAttributes), NSAttributedString(string: "David Brooks" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You're closing in on being the dumbest of them all. You don't have a clue.\n", attributes: normalAttributes), NSAttributedString(string: "David Brooks" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You have been so wrong & you hate it!\n", attributes: normalAttributes), NSAttributedString(string: "Carl Cameron" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You have been largely forgotten.\n", attributes: normalAttributes), NSAttributedString(string: "Katie Couric" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You're a totally biased loser who doesn't have a clue.\n", attributes: normalAttributes), NSAttributedString(string: "S.E. Cupp" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're hard to watch, zero talent!\n", attributes: normalAttributes), NSAttributedString(string: "S.E. Cupp" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "You're a major sleaze and buffoon.\n", attributes: normalAttributes), NSAttributedString(string: "Erick Erickson" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Uncomfortable looking!\n", attributes: normalAttributes), NSAttributedString(string: "Willie Geist" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "You just don't know about winning! But you're a nice person.\n", attributes: normalAttributes), NSAttributedString(string: "Bernard Goldberg" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Sleepy Eyes!\n", attributes: normalAttributes), NSAttributedString(string: "Bernard Goldberg" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You're not smart enough to know what's going on at the border.\n", attributes: normalAttributes), NSAttributedString(string: "Mary Katharine Ham" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're just a 3rd rate 'gotcha' guy!\n", attributes: normalAttributes), NSAttributedString(string: "Hugh Hewitt" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "You wouldn't know the truth if it hit you in the face.\n", attributes: normalAttributes), NSAttributedString(string: "Jeff Horwitz" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "Liberal clown.\n", attributes: normalAttributes), NSAttributedString(string: "Arianna Huffington" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "Dope!\n", attributes: normalAttributes), NSAttributedString(string: "Brit Hume" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "You're so average in so many ways!\n", attributes: normalAttributes), NSAttributedString(string: "Megyn Kelly" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You're sick, & the most overrated person!\n", attributes: normalAttributes), NSAttributedString(string: "Megyn Kelly" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "Get a life!\n", attributes: normalAttributes), NSAttributedString(string: "Megyn Kelly" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "I refuse to call you a bimbo, because that would not be politically correct.\n", attributes: normalAttributes), NSAttributedString(string: "Megyn Kelly" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You're very bad at math.\n", attributes: normalAttributes), NSAttributedString(string: "Megyn Kelly" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You should take another eleven day 'unscheduled' vacation.\n", attributes: normalAttributes), NSAttributedString(string: "Megyn Kelly" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "No focus, poor level of concentration!\n", attributes: normalAttributes), NSAttributedString(string: "Ruth Marcus" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "I think you should have gone to prison for what you did.\n", attributes: normalAttributes), NSAttributedString(string: "Steve Rattner" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "Not much power or insight!\n", attributes: normalAttributes), NSAttributedString(string: "Joe Scarborough" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "You're a major lightweight with no credibility.\n", attributes: normalAttributes), NSAttributedString(string: "Ben Schreckinger" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "Hater & racist.\n", attributes: normalAttributes), NSAttributedString(string: "Tavis Smiley" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "You should be ashamed of yourself.\n", attributes: normalAttributes), NSAttributedString(string: "Shep Smith" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "Really dumb puppet.\n", attributes: normalAttributes), NSAttributedString(string: "Marc Threaten (sic)" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "Sleepy eyes, you will be fired like a dog. I can't imagine what is taking so long!\n", attributes: normalAttributes), NSAttributedString(string: "Chuck Todd" , attributes: subtitleAttributes))]
        
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
        
        liarArray += [(NSMutableAttributedString(string: "Crooked \(name)!\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s temperament is weak.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "\(name) doesn't even look presidential.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name) suffers from plain old bad judgement.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) has zero imagination and even less stamina.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) has ZERO leadership ability.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        manipulativeArray += [(NSMutableAttributedString(string: "\(name)'s constantly playing the women's card - it is sad!\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s one of the all time great enablers!\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "Who should star in a reboot of Liar Liar - \(name) or Ted Cruz? Let me know.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "\(name)'s a major national security risk.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s totally incompetent as a manager and leader.\n", attributes: normalAttributes), NSAttributedString(string: "Hillary Clinton" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "\(name) wants to look cool, but it's far too late.\n", attributes: normalAttributes), NSAttributedString(string: "Jeb Bush" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s by far the weakest of the lot.\n", attributes: normalAttributes), NSAttributedString(string: "Jeb Bush" , attributes: subtitleAttributes))]
        jealousArray += [(NSMutableAttributedString(string: "\(name) will do anything to stay at the trough.\n", attributes: normalAttributes), NSAttributedString(string: "Jeb Bush" , attributes: subtitleAttributes))]
        uptightArray += [(NSMutableAttributedString(string: "\(name) should go home and relax!\n", attributes: normalAttributes), NSAttributedString(string: "Jeb Bush" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s a total embarassment to themselves and their family.\n", attributes: normalAttributes), NSAttributedString(string: "Jeb Bush" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s bottom (and gone), I'm top (by a lot).\n", attributes: normalAttributes), NSAttributedString(string: "Jeb Bush" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "\(name) really went wacko today.\n", attributes: normalAttributes), NSAttributedString(string: "Ted Cruz" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s mathematically dead and totally desparate.\n", attributes: normalAttributes), NSAttributedString(string: "Ted Cruz" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "All \(name) can do is be a spoiler, never a nice thing to do.\n", attributes: normalAttributes), NSAttributedString(string: "Ted Cruz" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "\(name) lies like a dog-over and over again!\n", attributes: normalAttributes), NSAttributedString(string: "Ted Cruz" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "\(name) is a world class LIAR!\n", attributes: normalAttributes), NSAttributedString(string: "Ted Cruz" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "\(name)'s the worst liar, crazy or very dishonest\n", attributes: normalAttributes), NSAttributedString(string: "Ted Cruz" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) will fall like all others.\n", attributes: normalAttributes), NSAttributedString(string: "Ted Cruz" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "If I listen to \(name) for more than ten minutes straight, I develop a massive headache.\n", attributes: normalAttributes), NSAttributedString(string: "Carly Fiorina" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) - ALL TALK AND NO ACTION!\n", attributes: normalAttributes), NSAttributedString(string: "Lindsey Graham" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s a dumb mouthpiece.\n", attributes: normalAttributes), NSAttributedString(string: "Lindsey Graham" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "I will sue \(name) just for fun!\n", attributes: normalAttributes), NSAttributedString(string: "John Kasich" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) couldn't be elected dog catcher\n", attributes: normalAttributes), NSAttributedString(string: "George Pataki" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) didn't get the right gene.\n", attributes: normalAttributes), NSAttributedString(string: "Rand Paul" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "\(name) should be forced to take an IQ test.\n", attributes: normalAttributes), NSAttributedString(string: "Rick Perry" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) will never MAKE AMERICA GREAT AGAIN!\n", attributes: normalAttributes), NSAttributedString(string: "Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) looks like a little boy on stage.\n", attributes: normalAttributes), NSAttributedString(string: "Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) couldn't even respond properly without pouring sweat and chugging water.\n", attributes: normalAttributes), NSAttributedString(string: "Marco Rubio" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s a perfect little puppet.\n", attributes: normalAttributes), NSAttributedString(string: "Marco Rubio" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s never made ten cents.\n", attributes: normalAttributes), NSAttributedString(string: "Marco Rubio" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name) knows nothing about finance\n", attributes: normalAttributes), NSAttributedString(string: "Marco Rubio" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "I know more about \(name) than they knows about themselves.\n", attributes: normalAttributes), NSAttributedString(string: "Cory Booker" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "\(name)'s the WORST abuser of woman in U.S. political history.\n", attributes: normalAttributes), NSAttributedString(string: "Bill Clinton" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "\(name) DEMONSTRATED A PENCHANT FOR SEXISM.\n", attributes: normalAttributes), NSAttributedString(string: "Bill Clinton" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s a crude dope!\n", attributes: normalAttributes), NSAttributedString(string: "Michael Nutter" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "\(name) looks and sounds so ridiculous.\n", attributes: normalAttributes), NSAttributedString(string: "Barack Obama" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "\(name) has a career that is totally based on a lie.\n", attributes: normalAttributes), NSAttributedString(string: "Elizabeth Warren" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "Perv sleazebag.\n", attributes: normalAttributes), NSAttributedString(string: "Anthony Weiner" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) should focus on all of the problems that they've caused with their ineptitude.\n", attributes: normalAttributes), NSAttributedString(string: "Bill de Blasio" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "The people of South Carolina are embarrassed by \(name)!\n", attributes: normalAttributes), NSAttributedString(string: "Nikki Haley" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "All \(name) does is talk, talk, talk, but they're incapable of doing anything.\n", attributes: normalAttributes), NSAttributedString(string: "John McCain" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name) choked like a dog.\n", attributes: normalAttributes), NSAttributedString(string: "Mitt Romney" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s a mixed up person who doesn't have a clue.\n", attributes: normalAttributes), NSAttributedString(string: "Mitt Romney" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s the person who choked and let us all down.\n", attributes: normalAttributes), NSAttributedString(string: "Mitt Romney" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s a total joke, and everyone knows it!\n", attributes: normalAttributes), NSAttributedString(string: "Mitt Romney" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s so awkward and goofy.\n", attributes: normalAttributes), NSAttributedString(string: "Mitt Romney" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "I don't need \(name)'s angry advice!\n", attributes: normalAttributes), NSAttributedString(string: "Mitt Romney" , attributes: subtitleAttributes))]
        whatArray += [(NSMutableAttributedString(string: "\(name) looks more like a gym rat than a U.S. Senator.\n", attributes: normalAttributes), NSAttributedString(string: "Ben Sasse" , attributes: subtitleAttributes))]
        whatArray += [(NSMutableAttributedString(string: "\(name) forgot to mention my phenomenal biz success rate.\n", attributes: normalAttributes), NSAttributedString(string: "John Sununu" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s a failing, crying, lost soul!\n", attributes: normalAttributes), NSAttributedString(string: "Glenn Beck" , attributes: subtitleAttributes))]
        crazyArray += [(NSMutableAttributedString(string: "\(name)'s a mental basketcase.\n", attributes: normalAttributes), NSAttributedString(string: "Glenn Beck" , attributes: subtitleAttributes))]
        whatArray += [(NSMutableAttributedString(string: "\(name) always seems to be crying.\n", attributes: normalAttributes), NSAttributedString(string: "Glenn Beck" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Lightweight, \(name) comes to my office begging for money like a dog.\n", attributes: normalAttributes), NSAttributedString(string: "Brent Bozell" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "I consider \(name) one of the dumbest of all pundits- \(name) has no sense of the real world!\n", attributes: normalAttributes), NSAttributedString(string: "David Brooks" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s closing in on being the dumbest of them all. \(name) doesn't have a clue.\n", attributes: normalAttributes), NSAttributedString(string: "David Brooks" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s been so wrong & hates it!\n", attributes: normalAttributes), NSAttributedString(string: "Carl Cameron" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) has been largely forgotten.\n", attributes: normalAttributes), NSAttributedString(string: "Katie Couric" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s a totally biased loser who doesn't have a clue.\n", attributes: normalAttributes), NSAttributedString(string: "S.E. Cupp" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s hard to watch, zero talent!\n", attributes: normalAttributes), NSAttributedString(string: "S.E. Cupp" , attributes: subtitleAttributes))]
        sleazyArray += [(NSMutableAttributedString(string: "\(name)'s a major sleaze and buffoon.\n", attributes: normalAttributes), NSAttributedString(string: "Erick Erickson" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Uncomfortable looking, \(name)!\n", attributes: normalAttributes), NSAttributedString(string: "Willie Geist" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "\(name) just doesn't know about winning! But a nice person.\n", attributes: normalAttributes), NSAttributedString(string: "Bernard Goldberg" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Sleepy Eyes, \(name)!\n", attributes: normalAttributes), NSAttributedString(string: "Bernard Goldberg" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s not smart enough to know what's going on at the border.\n", attributes: normalAttributes), NSAttributedString(string: "Mary Katharine Ham" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s just a 3rd rate 'gotcha' guy!\n", attributes: normalAttributes), NSAttributedString(string: "Hugh Hewitt" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "\(name) wouldn't know the truth if it hit them in the face.\n", attributes: normalAttributes), NSAttributedString(string: "Jeff Horwitz" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "Liberal clown.\n", attributes: normalAttributes), NSAttributedString(string: "Arianna Huffington" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "Dope!\n", attributes: normalAttributes), NSAttributedString(string: "Brit Hume" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "\(name)'s so average in so many ways!\n", attributes: normalAttributes), NSAttributedString(string: "Megyn Kelly" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name)'s sick, & the most overrated person!\n", attributes: normalAttributes), NSAttributedString(string: "Megyn Kelly" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name), get a life!\n", attributes: normalAttributes), NSAttributedString(string: "Megyn Kelly" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "I refuse to call \(name) a bimbo, because that would not be politically correct.\n", attributes: normalAttributes), NSAttributedString(string: "Megyn Kelly" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "\(name)'s very bad at math.\n", attributes: normalAttributes), NSAttributedString(string: "Megyn Kelly" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) should take another eleven day 'unscheduled' vacation.\n", attributes: normalAttributes), NSAttributedString(string: "Megyn Kelly" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "No focus, poor level of concentration!\n", attributes: normalAttributes), NSAttributedString(string: "Ruth Marcus" , attributes: subtitleAttributes))]
        liarArray += [(NSMutableAttributedString(string: "I think \(name) should have gone to prison for what they did.\n", attributes: normalAttributes), NSAttributedString(string: "Steve Rattner" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "Not much power or insight!\n", attributes: normalAttributes), NSAttributedString(string: "Joe Scarborough" , attributes: subtitleAttributes))]
        weakArray += [(NSMutableAttributedString(string: "\(name)'s a major lightweight with no credibility.\n", attributes: normalAttributes), NSAttributedString(string: "Ben Schreckinger" , attributes: subtitleAttributes))]
        bestArray += [(NSMutableAttributedString(string: "Hater & racist.\n", attributes: normalAttributes), NSAttributedString(string: "Tavis Smiley" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "\(name) should be ashamed of themselves.\n", attributes: normalAttributes), NSAttributedString(string: "Shep Smith" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "Really dumb puppet.\n", attributes: normalAttributes), NSAttributedString(string: "Marc Threaten (sic)" , attributes: subtitleAttributes))]
        worthlessArray += [(NSMutableAttributedString(string: "Sleepy eyes \(name) will be fired like a dog. I can't imagine what is taking so long!\n", attributes: normalAttributes), NSAttributedString(string: "Chuck Todd" , attributes: subtitleAttributes))]
        
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
    }

    
}
