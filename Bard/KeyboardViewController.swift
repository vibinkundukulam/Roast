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
    
    @IBOutlet weak var nameEntryTextFieldLeft: NSLayoutConstraint!
    @IBOutlet weak var categoryTableViewTop: NSLayoutConstraint!
    @IBOutlet weak var textKeyboardRowOne: UIView!
    @IBOutlet weak var backButton: Draw2D!
    @IBOutlet weak var categoryTableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var expandCategoryButton: UIButton!
    @IBOutlet weak var textKeyboardRowTwo: UIView!
    @IBOutlet weak var textKeyboardRowThree: UIView!
    @IBOutlet weak var nextKeyboard: UIButton!
    @IBOutlet weak var textKeyboardRowFour: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var categoryHeader: UIView!
    @IBOutlet weak var textKeyboardView: TextKeyboardView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var chooseQuoteView: UIView!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameEntryTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    // Ensure keyboard remembers last key, quote
    
    var lastRow = -1
    var wasDeleteLastKey = 0
    var lastCategorySelected = ""
    var selectedCategory = ""
    var lastCategoryDisplayed = ""
    var sectionExpanded = false
    
    
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
    let buttonTitlesRowFour = ["Space"]
    var buttonsRowOne = [UIButton]()
    var buttonsRowTwo = [UIButton]()
    var buttonsRowThree = [UIButton]()
    var buttonsRowFour = [UIButton]()
    
    
    
    // Creating initial arrays to hold quotes
    
    var yourArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var mommaArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var incompetentArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var disgustingArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var poorArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var fatArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var uglyArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var gonnaArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var worstArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var groupArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var awkwardArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var annoyingArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var oldArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var boringArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var unfashionableArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var unwantedArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var shortArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var easyArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var uncaringArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var stupidArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var talkingArray: [(NSMutableAttributedString, NSAttributedString)] = []
    var rudeArray: [(NSMutableAttributedString, NSAttributedString)] = []
    
    var buttonTitles = Dictionary<String,[(NSMutableAttributedString, NSAttributedString)]>()
    
    
    //
    //
    // Load everything when the keyboard first pops up
    //
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        talkingArray += [(NSMutableAttributedString(string: "You speak an infinite deal of nothing.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You speak unskilfully: or, if your knowledge be more, it is much darkened in your malice.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "I scorn you, scurvy companion. What, you poor, base, rascally, cheating, lack-linen mate! Away, you moldy rogue, away!\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        mommaArray += [(NSMutableAttributedString(string: "Thou slander of thy heavy mother's womb!\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "Thy food is such as hath been belch'd upon by infected lungs.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "Away, you bottle-ale rascal, you filthy bung, away!\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        disgustingArray += [(NSMutableAttributedString(string: "Thy breath stinks with eating toasted cheese.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Thou art spacious in the possesion of dirt.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        disgustingArray += [(NSMutableAttributedString(string: "Would thou were clean enough to spit upon!\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "O illiterate loiterer!\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "Would the fountain of your mind were clear again, that I might water an ass at it.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "Thou art a wretch whose natural gifts were poor.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        fatArray += [(NSMutableAttributedString(string: "Thou art as fat as butter.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "Thou clay-brained guts, thou knotty-pated fool, thou whoreson obscene greasy tallow-catch!\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Thou art the rudeliest welcome to this world.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        gonnaArray += [(NSMutableAttributedString(string: "We leak in your chimney.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        rudeArray += [(NSMutableAttributedString(string: "A weasel hath not such a deal of spleen as you are toss'd with.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "I took thee for thy better.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "Were I like thee I'd throw away myself.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "Thou loathed issue of thy father's loins!\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "O teach me how I should forget to think.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "You starveling, you elfskin, you dried neat's tongue, you bull's pizzle, you stockfish!\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "The empty vessel makes the greatest sound.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        mommaArray += [(NSMutableAttributedString(string: "Villain, I have done thy mother.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        gonnaArray += [(NSMutableAttributedString(string: "I bite my thumb at you!\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        mommaArray += [(NSMutableAttributedString(string: "My grandma could do better, and she's dead!\n", attributes: normalAttributes), NSAttributedString(string: "Gordon Ramsay" , attributes: subtitleAttributes))]
        gonnaArray += [(NSMutableAttributedString(string: "I wish you'd jump in the oven!\n", attributes: normalAttributes), NSAttributedString(string: "Gordon Ramsay" , attributes: subtitleAttributes))]
        groupArray += [(NSMutableAttributedString(string: "This is a really tough decision, because you're both crap.\n", attributes: normalAttributes), NSAttributedString(string: "Gordon Ramsay" , attributes: subtitleAttributes))]
        talkingArray += [(NSMutableAttributedString(string: "Hey, panini head, are you listening to me?\n", attributes: normalAttributes), NSAttributedString(string: "Gordon Ramsay" , attributes: subtitleAttributes))]
        gonnaArray += [(NSMutableAttributedString(string: "You deserve a kick in the nuts.\n", attributes: normalAttributes), NSAttributedString(string: "Gordon Ramsay" , attributes: subtitleAttributes))]
        awkwardArray += [(NSMutableAttributedString(string: "You look like you're just about to lose your virginity.\n", attributes: normalAttributes), NSAttributedString(string: "Gordon Ramsay" , attributes: subtitleAttributes))]
        annoyingArray += [(NSMutableAttributedString(string: "You sound like Dolly Parton on helium.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You look like the Incredible Hulk’s wife.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Your mouth is far, far too big. I mean, it was like looking into a cave. I’ve never seen anything so huge in my life.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        oldArray += [(NSMutableAttributedString(string: "You’re too old to be a barbie doll sweetheart.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        annoyingArray += [(NSMutableAttributedString(string: "You have one of the worst voices I have ever heard. It is almost non-human.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Shave off your beard and wear a dress. I think you’d be a great female impersonator.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        boringArray += [(NSMutableAttributedString(string: "You have the personality of a handle.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "You’re one of those packages at Christmas time where you say, ‘Can I give it back?’\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "You're a bit like ordering a hamburger, and only getting the bun.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "Have you ever got a shirt back from the laundry where it’s got too much starch in it? You know like you literally can’t put it on because it’s made of wood? That’s what you were like.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "You're like a goldfish wanting to be a shark.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        boringArray += [(NSMutableAttributedString(string: "You have the charisma of a banana.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        annoyingArray += [(NSMutableAttributedString(string: "You’re like the llama in the petting area.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        unfashionableArray += [(NSMutableAttributedString(string: "I presume there was no mirror in your dressing room tonight.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        annoyingArray += [(NSMutableAttributedString(string: "You have just invented a new form of torture.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        annoyingArray += [(NSMutableAttributedString(string: "You sound like a cat in a vacuum cleaner.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "There's only so many words I can drag out of my vocabulary to say how awful you are.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "You call yourself champagne but are actually the house wine.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        boringArray += [(NSMutableAttributedString(string: "I could sell you as a sleeping aid. I've never heard anything more boring in my life.\n", attributes: normalAttributes), NSAttributedString(string: "Simon Cowell" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "Irrelevant clown.\n", attributes: normalAttributes), NSAttributedString(string: "Donald Trump" , attributes: subtitleAttributes))]
        disgustingArray += [(NSMutableAttributedString(string: "Disgusting, both inside and out.\n", attributes: normalAttributes), NSAttributedString(string: "Donald Trump" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "Spoiled brat without a properly functioning brain.\n", attributes: normalAttributes), NSAttributedString(string: "Donald Trump" , attributes: subtitleAttributes))]
        gonnaArray += [(NSMutableAttributedString(string: "Someone needs to follow you into an alley and hit you in the head with a pipe.\n", attributes: normalAttributes), NSAttributedString(string: "Louis CK" , attributes: subtitleAttributes))]
        boringArray += [(NSMutableAttributedString(string: "You don't have a soul.\n", attributes: normalAttributes), NSAttributedString(string: "Louis CK" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "If you robbed a bank and the dude was describing you to the police sketch artist, he’d be like ‘no seriously, what does he look like?’ Nobody looks like you. I can’t believe I’m looking at you.\n", attributes: normalAttributes), NSAttributedString(string: "Louis CK" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "Now look here, you gourd-bellied codpiece!\n", attributes: normalAttributes), NSAttributedString(string: "Stewie (Family Guy)" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Get out of here, you hobo!\n", attributes: normalAttributes), NSAttributedString(string: "Stewie (Family Guy)" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "You're the end result of a drunken backseat grope-fest and a broken prophylactic.\n", attributes: normalAttributes), NSAttributedString(string: "Stewie (Family Guy)" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Yes, this is the thing that will ruin your reputation, not your years of grotesque appearance or awkward social graces, or that Felix Unger-ish way you clear your sinuses.\n", attributes: normalAttributes), NSAttributedString(string: "Stewie (Family Guy)" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Your skin has the texture of a decorative autumn squash.\n", attributes: normalAttributes), NSAttributedString(string: "Stewie (Family Guy)" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "You sack-bellied strumpet!\n", attributes: normalAttributes), NSAttributedString(string: "Stewie (Family Guy)" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "You bovine lummox!\n", attributes: normalAttributes), NSAttributedString(string: "Stewie (Family Guy)" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "Pudgey-faced apple-john!\n", attributes: normalAttributes), NSAttributedString(string: "Stewie (Family Guy)" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "Damn you, vile woman!\n", attributes: normalAttributes), NSAttributedString(string: "Stewie (Family Guy)" , attributes: subtitleAttributes))]
        fatArray += [(NSMutableAttributedString(string: "Why you sick, sick little moo-cow.\n", attributes: normalAttributes), NSAttributedString(string: "Stewie (Family Guy)" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You look like Snoopy, and it makes me smile.\n", attributes: normalAttributes), NSAttributedString(string: "Stewie (Family Guy)" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "Mealy-mouthed crotch pheasant!\n", attributes: normalAttributes), NSAttributedString(string: "Stewie (Family Guy)" , attributes: subtitleAttributes))]
        awkwardArray += [(NSMutableAttributedString(string: "I bet you lost your virginity to a mechanical bull.\n", attributes: normalAttributes), NSAttributedString(string: "Stewie (Family Guy)" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "On a scale from one to ten, ten being the dumbest a person can look, you are definitely nineteen.\n", attributes: normalAttributes), NSAttributedString(string: "Chandler (Friends)" , attributes: subtitleAttributes))]
        awkwardArray += [(NSMutableAttributedString(string: "Good night, you big freak-of-nature!\n", attributes: normalAttributes), NSAttributedString(string: "Chandler (Friends)" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You know, you have to stop pushing the Q-Tip when there is resistance.\n", attributes: normalAttributes), NSAttributedString(string: "Chandler (Friends)" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "Hell is filled with people like you.\n", attributes: normalAttributes), NSAttributedString(string: "Chandler (Friends)" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You look like an avocado had sex with an older avocado.\n", attributes: normalAttributes), NSAttributedString(string: "Deadpool (comic book)" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You are haunting.\n", attributes: normalAttributes), NSAttributedString(string: "Deadpool (comic book)" , attributes: subtitleAttributes))]
        fatArray += [(NSMutableAttributedString(string: "You're a less angry Rosie O’Donnell.\n", attributes: normalAttributes), NSAttributedString(string: "Deadpool (comic book)" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "Thou cream-faced loon.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "Thou art as loathsome as a toad.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        fatArray += [(NSMutableAttributedString(string: "Peace, ye fat guts.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "I do desire we may be better strangers.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "Thou art a flesh-monger, a fool, and a coward.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "Thou art a boil, a plague sore, an embossed carbuncle in my corrupted blood.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        shortArray += [(NSMutableAttributedString(string: "Away, you three-inch fool!\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        boringArray += [(NSMutableAttributedString(string: "Thou hast neither heat, affection, limb, nor beauty to make thy riches pleasant.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        fatArray += [(NSMutableAttributedString(string: "Is not your chin double? Your wit single?\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "Thou leathern-jerkin, crystal-button, knot-pated, agatering, puke-stocking, caddis-garter, smooth-tongue, Spanish pouch!\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "Thou art a most notable coward, an infinite and endless liar, an hourly promise breaker, the owner of no one good quality.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Out of my sight! Thou dost infect my eyes.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You have such a February face, so full of frost, of storm and cloudiness.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        fatArray += [(NSMutableAttributedString(string: "No longer from head to foot than from hip to hip, you are spherical, like a globe, I could find out countries in you.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        annoyingArray += [(NSMutableAttributedString(string: "More of your conversation would infect my brain.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "Methink’st thou art a general offence, and every man should beat thee.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "Heaven truly knows that thou art false as hell.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You abilities are too infant-like for doing much alone.\n", attributes: normalAttributes), NSAttributedString(string: "Shakespeare" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You're a jackass. But you're talented.\n", attributes: normalAttributes), NSAttributedString(string: "Obama" , attributes: subtitleAttributes))]
        shortArray += [(NSMutableAttributedString(string: "You're a modest little person, with much to be modest about.\n", attributes: normalAttributes), NSAttributedString(string: "Churchill" , attributes: subtitleAttributes))]
        unfashionableArray += [(NSMutableAttributedString(string: "You're a sheep in sheep's clothing.\n", attributes: normalAttributes), NSAttributedString(string: "Churchill" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "I wish you no ill, but it would have been much better if you had never lived.\n", attributes: normalAttributes), NSAttributedString(string: "Churchill" , attributes: subtitleAttributes))]
        awkwardArray += [(NSMutableAttributedString(string: "What can you do with a someone who looks like a female llama surprised when bathing?\n", attributes: normalAttributes), NSAttributedString(string: "Churchill" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You have, more than any other man, the gift of compressing the largest amount of words into the smallest amount of thought.\n", attributes: normalAttributes), NSAttributedString(string: "Churchill" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You can put lipstick on a pig, but it's still a pig.\n", attributes: normalAttributes), NSAttributedString(string: "Obama" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "You have all the virtues I dislike and none of the vices I admire.\n", attributes: normalAttributes), NSAttributedString(string: "Churchill" , attributes: subtitleAttributes))]
        awkwardArray += [(NSMutableAttributedString(string: "Why do you sit there looking like an envelope without any address on it?\n", attributes: normalAttributes), NSAttributedString(string: "Mark Twain" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "I do not believe I could learn to like you except on a raft at sea with no other provisions in sight\n", attributes: normalAttributes), NSAttributedString(string: "Mark Twain" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "Your head was an hour-glass; it could stow an idea, but it has to do it a grain at a time, not the whole idea at once.\n", attributes: normalAttributes), NSAttributedString(string: "Mark Twain" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "I don’t want to talk to you no more, you empty-headed animal food trough wiper.\n", attributes: normalAttributes), NSAttributedString(string: "Monty Python" , attributes: subtitleAttributes))]
        gonnaArray += [(NSMutableAttributedString(string: "I fart in your general direction!\n", attributes: normalAttributes), NSAttributedString(string: "Monty Python" , attributes: subtitleAttributes))]
        mommaArray += [(NSMutableAttributedString(string: "Your mother was a hamster and your father smelt of elderberries!\n", attributes: normalAttributes), NSAttributedString(string: "Monty Python" , attributes: subtitleAttributes))]
        gonnaArray += [(NSMutableAttributedString(string: "Now go away or I shall taunt you a second time!\n", attributes: normalAttributes), NSAttributedString(string: "Monty Python" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "Go and boil your bottoms, you sons of a silly person.\n", attributes: normalAttributes), NSAttributedString(string: "Monty Python" , attributes: subtitleAttributes))]
        gonnaArray += [(NSMutableAttributedString(string: "I blow my nose at you!\n", attributes: normalAttributes), NSAttributedString(string: "Monty Python" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "You stupid, furry, bucktoothed git!\n", attributes: normalAttributes), NSAttributedString(string: "Monty Python" , attributes: subtitleAttributes))]
        talkingArray += [(NSMutableAttributedString(string: "Button your lip, you ratbag!\n", attributes: normalAttributes), NSAttributedString(string: "Monty Python" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "You miserable man...do your worst, you worm!\n", attributes: normalAttributes), NSAttributedString(string: "Monty Python" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "You stupid, interfering little rat! Damn your lemon curd tartlet!\n", attributes: normalAttributes), NSAttributedString(string: "Monty Python" , attributes: subtitleAttributes))]
        gonnaArray += [(NSMutableAttributedString(string: "I unclog my nose in your direction...I wave my private parts at your aunties, you cheesey-lover second-hand election donkey-bottom biters!\n", attributes: normalAttributes), NSAttributedString(string: "Monty Python" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "You are a great fat good-natured, kind-hearted, chicken-livered slave.\n", attributes: normalAttributes), NSAttributedString(string: "Mark Twain" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "You have no more pride than a tramp, no more sand than a rabbit, no more moral sense than a wax figure, and no more sex than a tapeworm.\n", attributes: normalAttributes), NSAttributedString(string: "Mark Twain" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "You are a furious blusterer on the outside, and at heart a coward.\n", attributes: normalAttributes), NSAttributedString(string: "Mark Twain" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "Your lips are as familiar with lies, deceptions, swindles and treacheries as are your nostrils with breath.\n", attributes: normalAttributes), NSAttributedString(string: "Mark Twain" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "I think you are the best hated person I have ever known and the most liberally despised.\n", attributes: normalAttributes), NSAttributedString(string: "Mark Twain" , attributes: subtitleAttributes))]
        boringArray += [(NSMutableAttributedString(string: "You are tedious, witless, commonplace, love to hear yourself talk, and are a spirit-rotting bore.\n", attributes: normalAttributes), NSAttributedString(string: "Mark Twain" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "You can always be depended upon to take the simplest half dozen facts and draw from them a conclusion that will astonish the idiots in the asylum.\n", attributes: normalAttributes), NSAttributedString(string: "Mark Twain" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "I never met so eloquent a fool.\n", attributes: normalAttributes), NSAttributedString(string: "Oscar Wilde" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "Some cause happiness wherever they go; you, whenever you go.\n", attributes: normalAttributes), NSAttributedString(string: "Oscar Wilde" , attributes: subtitleAttributes))]
        rudeArray += [(NSMutableAttributedString(string: "I’m not questioning your honor, I’m denying its existence.\n", attributes: normalAttributes), NSAttributedString(string: "Game of Thrones" , attributes: subtitleAttributes))]
        easyArray += [(NSMutableAttributedString(string: "You're like a human Macarena. Something everyone did at parties in 1996.\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        disgustingArray += [(NSMutableAttributedString(string: "Isn’t there a slanket somewhere you should be filling with your farts?\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "You are the sexual equivalent of a million Hindenburgs.\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        disgustingArray += [(NSMutableAttributedString(string: "Your breath! When did you find time to eat a diaper you found on the beach?\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        unfashionableArray += [(NSMutableAttributedString(string: "Did the medical supply store where you bought those shoes have any… women’s stuff?\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "I can see every line and pore in your face. It looks like a YMCA climbing wall.\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You have the wind-battered face of a New England cod fisherman.\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        awkwardArray += [(NSMutableAttributedString(string: "The grown-up dating world is like your haircut. Sometimes, awkward triangles occur.\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        unfashionableArray += [(NSMutableAttributedString(string: "You look like Tootsie today.\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You’re going to have to work your backside. Because chest-wise, you have the measurements of an altar boy.\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        boringArray += [(NSMutableAttributedString(string: "Your motto is “Above all, be boring.”\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        uncaringArray += [(NSMutableAttributedString(string: "There are terrorist cells more nurturing than you are.\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "You turtle-faced goon. I will cut you open like a tauntaun, you mouth-breathing Appalachian!\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        talkingArray += [(NSMutableAttributedString(string: "You listen to me, Li’l Abner. Keep your fried baloney hole shut!\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "You look like a turtle who lost his shell.\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        mommaArray += [(NSMutableAttributedString(string: "What’s the difference between yo’ mama and washing machine? When I drop a load in the washing machine, it doesn’t follow me around for a week.\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You look like a condom that’s been dropped on the floor of a barbershop.\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        unfashionableArray += [(NSMutableAttributedString(string: "Who picks your clothes, Stevie Wonder?\n", attributes: normalAttributes), NSAttributedString(string: "Don Rickles" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "I think – no, I’m positive - that you are the most unattractive man I have ever met in my entire life.\n", attributes: normalAttributes), NSAttributedString(string: "The Witches of Eastwick" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "You know, in the short time we've been together, you have demonstrated every loathsome characteristic of the male personality and even discovered a few new ones.\n", attributes: normalAttributes), NSAttributedString(string: "The Witches of Eastwick" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "You are physically repulsive, intellectually retarded, you're morally reprehensible, vulgar, insensitive, selfish, stupid, you have no taste, a lousy sense of humour and you smell. You're not even interesting enough to make me sick.\n", attributes: normalAttributes), NSAttributedString(string: "The Witches of Eastwick" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "My great aunt Jennifer ate a whole box of candy every day of her life. She lived to be a hundred and two, and - when she’d been dead three days - she looked better than you do now.\n", attributes: normalAttributes), NSAttributedString(string: "The Man Who Came to Dinner" , attributes: subtitleAttributes))]
        talkingArray += [(NSMutableAttributedString(string: "Listen up, fives. A ten is speaking.\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You look terrible, and I once watched you eat oysters while you had a cold.\n", attributes: normalAttributes), NSAttributedString(string: "30 Rock" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "Your mother should have thrown you away and kept the stork.\n", attributes: normalAttributes), NSAttributedString(string: "Mae West" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "You have Van Gogh's ear for music.\n", attributes: normalAttributes), NSAttributedString(string: "Billy Wilder" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "You have delusions of adequacy.\n", attributes: normalAttributes), NSAttributedString(string: "Walter Kerr" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "There's nothing wrong with you that reincarnation won't cure.\n", attributes: normalAttributes), NSAttributedString(string: "Jack E. Leonard" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "I never forgot a face, but in your case I'd be glad to make an exception.\n", attributes: normalAttributes), NSAttributedString(string: "Groucho Marx" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You're so ugly that your proctologist stuck his finger in your mouth.\n", attributes: normalAttributes), NSAttributedString(string: "Rodney Dangerfield" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "I'll use small words so that you'll be sure to understand, you warthog-faced buffoon.\n", attributes: normalAttributes), NSAttributedString(string: "The Princess Bride" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "Why, you stuck-up, half-witted, scruffy-looking nerf-herder!\n", attributes: normalAttributes), NSAttributedString(string: "Princess Leia" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "You clinking, clanking, clattering collection of caliginous junk!\n", attributes: normalAttributes), NSAttributedString(string: "The Wizard of Oz" , attributes: subtitleAttributes))]
        worstArray += [(NSMutableAttributedString(string: "You dirt-eating piece of slime! You scum-sucking pig! You son of a motherless goat!\n", attributes: normalAttributes), NSAttributedString(string: "Three Amigos" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "You are a sad, strange little man, and you have my pity.\n", attributes: normalAttributes), NSAttributedString(string: "Buzz Lightyear" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "What you've just said is one of the most insanely idiotic things I have ever heard. Everyone in this room is now dumber for having listened to it. May God have mercy on your soul.\n", attributes: normalAttributes), NSAttributedString(string: "Billy Madison" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "To call you stupid would be an insult to stupid people.\n", attributes: normalAttributes), NSAttributedString(string: "A Fish Called Wanda" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "You're a gutless turd.\n", attributes: normalAttributes), NSAttributedString(string: "The Breakfast Club" , attributes: subtitleAttributes))]
        talkingArray += [(NSMutableAttributedString(string: "Shut up, you Teutonic twat!\n", attributes: normalAttributes), NSAttributedString(string: "Blazing Saddles" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "You're somewhere between a cockroach and that white stuff that accumulates at the corner of your mouth when you're really thirsty.\n", attributes: normalAttributes), NSAttributedString(string: "Con Air" , attributes: subtitleAttributes))]
        rudeArray += [(NSMutableAttributedString(string: "You have the manners of a goat and you smell like a dung-heap.\n", attributes: normalAttributes), NSAttributedString(string: "Highlander" , attributes: subtitleAttributes))]
        yourArray += [(NSMutableAttributedString(string: "You foul, loathsome, evil little cockroach!\n", attributes: normalAttributes), NSAttributedString(string: "Hermione" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "Is it true that, when you were born, the doctor turned around and slapped your mother?\n", attributes: normalAttributes), NSAttributedString(string: "The Adventures of Priscilla, Queen of the Desert" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "You are nothing! If you were in my toilet I wouldn't bother flushing it. My bathmat means more to me than you.\n", attributes: normalAttributes), NSAttributedString(string: "Swimming With Sharks" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "What is it like in your funny little brain? It must be so boring.\n", attributes: normalAttributes), NSAttributedString(string: "Sherlock" , attributes: subtitleAttributes))]
        talkingArray += [(NSMutableAttributedString(string: "Don't talk out loud, you lower the IQ of the whole street.\n", attributes: normalAttributes), NSAttributedString(string: "Sherlock" , attributes: subtitleAttributes))]
        talkingArray += [(NSMutableAttributedString(string: "If you don't mind, I'd like to stop listening to you.\n", attributes: normalAttributes), NSAttributedString(string: "The Big Bang Theory" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "I never said that you're not good at what you do. It's just that what you do is not worth doing.\n", attributes: normalAttributes), NSAttributedString(string: "The Big Bang Theory" , attributes: subtitleAttributes))]
        talkingArray += [(NSMutableAttributedString(string: "I'm listening. It just takes me a minute to process so much stupid all at once.\n", attributes: normalAttributes), NSAttributedString(string: "The Big Bang Theory" , attributes: subtitleAttributes))]
        unfashionableArray += [(NSMutableAttributedString(string: "Where'd you get those clothes? The toilet store?\n", attributes: normalAttributes), NSAttributedString(string: "Anchorman" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "You're so ugly, you could be a modern art masterpiece.\n", attributes: normalAttributes), NSAttributedString(string: "Full Metal Jacket" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "You're mediocre. Of all the ocres, you're the mediest.\n", attributes: normalAttributes), NSAttributedString(string: "Veep" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "I don't have time to ignore you.\n", attributes: normalAttributes), NSAttributedString(string: "Veep" , attributes: subtitleAttributes))]
        groupArray += [(NSMutableAttributedString(string: "I like half of you half as well as I should like, and I like less than half of you half as well as you deserve!\n", attributes: normalAttributes), NSAttributedString(string: "Lord of the Rings" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "If I wanted to punish you, I'd hold up a mirror.\n", attributes: normalAttributes), NSAttributedString(string: "Picket Fences" , attributes: subtitleAttributes))]
        unwantedArray += [(NSMutableAttributedString(string: "I could dance with you until the cows come home... on second thoughts, I'll dance with the cows and you go home.\n", attributes: normalAttributes), NSAttributedString(string: "Groucho Marx" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "If minds were like dominoes, surely yours would be the double blank.\n", attributes: normalAttributes), NSAttributedString(string: "P.G. Wodehouse" , attributes: subtitleAttributes))]
        stupidArray += [(NSMutableAttributedString(string: "Were you always this stupid, or did you take lessons?\n", attributes: normalAttributes), NSAttributedString(string: "The Long Kiss Goodnight" , attributes: subtitleAttributes))]
        talkingArray += [(NSMutableAttributedString(string: "The trouble with you is that you lacks the power of conversation but not the power of speech.\n", attributes: normalAttributes), NSAttributedString(string: "George Bernard Shaw" , attributes: subtitleAttributes))]
        rudeArray += [(NSMutableAttributedString(string: "You're like school on a Saturday... no class!\n", attributes: normalAttributes), NSAttributedString(string: "Fat Albert" , attributes: subtitleAttributes))]
        talkingArray += [(NSMutableAttributedString(string: "If your mind isn't open, keep your mouth shut too.\n", attributes: normalAttributes), NSAttributedString(string: "M is for Malice" , attributes: subtitleAttributes))]
        talkingArray += [(NSMutableAttributedString(string: "Why don't you do the world a favor. Pull your bottom lip up over your head and swallow.\n", attributes: normalAttributes), NSAttributedString(string: "Grumpy Old Men" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Your family is so poor, they had to take out a second mortgage on their cardboard box.\n", attributes: normalAttributes), NSAttributedString(string: "Cartman" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Your momma is so poor, she can't even pay attention.\n", attributes: normalAttributes), NSAttributedString(string: "Cartman" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Your momma is so poor, she uses Cheerios for earrings.\n", attributes: normalAttributes), NSAttributedString(string: "Cartman" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Your momma is so poor, the ducks throw bread at her!\n", attributes: normalAttributes), NSAttributedString(string: "Cartman" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Your momma is so poor that when she goes to KFC, she has to lick other people's fingers!\n", attributes: normalAttributes), NSAttributedString(string: "Cartman" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Your momma is so poor, she waves around a popsicle and calls it air conditioning.\n", attributes: normalAttributes), NSAttributedString(string: "Cartman" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Your momma's so poor, she opene a gmail account just so she could eat the spam!\n", attributes: normalAttributes), NSAttributedString(string: "Cartman" , attributes: subtitleAttributes))]
        poorArray += [(NSMutableAttributedString(string: "Your momma's so poor, when she gets mad she can't afford to fly off the handle so she's gotta go Greyhound off the handle!\n", attributes: normalAttributes), NSAttributedString(string: "Cartman" , attributes: subtitleAttributes))]
        oldArray += [(NSMutableAttributedString(string: "You're so old, your blood type was discontinued.\n", attributes: normalAttributes), NSAttributedString(string: "Phyllis Diller" , attributes: subtitleAttributes))]
        oldArray += [(NSMutableAttributedString(string: "You're alive, but only in the sense that you can't be legally buried.\n", attributes: normalAttributes), NSAttributedString(string: "Geoffrey Madan" , attributes: subtitleAttributes))]
        oldArray += [(NSMutableAttributedString(string: "You should stay away from natural foods. At your age, you need all the preservatives you can get.\n", attributes: normalAttributes), NSAttributedString(string: "George Burns" , attributes: subtitleAttributes))]
        fatArray += [(NSMutableAttributedString(string: "You’re fattening faster than you’re aging. You’re like the Curious Case of Benjamin Glutton.\n", attributes: normalAttributes), NSAttributedString(string: "Greg Giraldo" , attributes: subtitleAttributes))]
        unfashionableArray += [(NSMutableAttributedString(string: "You’re an old man who dresses like a Hooter’s waitress.\n", attributes: normalAttributes), NSAttributedString(string: "Greg Giraldo" , attributes: subtitleAttributes))]
        uglyArray += [(NSMutableAttributedString(string: "Could your original face have been that much worse than that clown mask you’ve had welded on?\n", attributes: normalAttributes), NSAttributedString(string: "Greg Giraldo" , attributes: subtitleAttributes))]
        shortArray += [(NSMutableAttributedString(string: "You're so short you can parachute off a dime.\n", attributes: normalAttributes), NSAttributedString(string: "84C MoPic" , attributes: subtitleAttributes))]
        incompetentArray += [(NSMutableAttributedString(string: "You have the driving skills of Stevie Wonder.\n", attributes: normalAttributes), NSAttributedString(string: "Kevin Hart" , attributes: subtitleAttributes))]
        shortArray += [(NSMutableAttributedString(string: "You're so short you call Lil Wayne, Wayne.\n", attributes: normalAttributes), NSAttributedString(string: "Justin Bieber" , attributes: subtitleAttributes))]
        
        buttonTitles["You're a..."] = yourArray
        buttonTitles["Your momma's so..."] = mommaArray
        buttonTitles["Incompetent"] = incompetentArray
        buttonTitles["Disgusting"] = disgustingArray
        buttonTitles["Poor"] = poorArray
        buttonTitles["Fat"] = fatArray
        buttonTitles["Ugly"] = uglyArray
        buttonTitles["I'm gonna..."] = gonnaArray
        buttonTitles["Worst"] = worstArray
        buttonTitles["Group"] = groupArray
        buttonTitles["Awkward"] = awkwardArray
        buttonTitles["Annoying"] = annoyingArray
        buttonTitles["Old"] = oldArray
        buttonTitles["Boring"] = boringArray
        buttonTitles["Unfashionable"] = unfashionableArray
        buttonTitles["Unwanted"] = unwantedArray
        buttonTitles["Short"] = shortArray
        buttonTitles["Easy"] = easyArray
        buttonTitles["Cold"] = uncaringArray
        buttonTitles["Stupid"] = stupidArray
        buttonTitles["Talking too much"] = talkingArray
        buttonTitles["Rude"] = rudeArray
        
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
        
        backButton.hidden = true
        textKeyboardView.hidden = true
        self.view.autoresizesSubviews = true
        
        
        // Set up table of quotes and categories
        
        tableView1.delegate = self
        tableView1.dataSource = self
        
        tableView2.delegate = self
        tableView2.dataSource = self
        
        tableView1.rowHeight = UITableViewAutomaticDimension
        tableView1.estimatedRowHeight = 30
        tableView1.registerClass(UITableViewCell.self,forCellReuseIdentifier: "cell")
        tableView1.backgroundColor = quoteColor
        tableView1.separatorColor = UIColor.clearColor()
        
        
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
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator);
        coordinator.animateAlongsideTransition(nil, completion: {
            _ in
            print("Test width = \(self.textKeyboardRowOne.frame.width)")
            print("Test height = \(self.view.frame.height)")
            self.textKeyboardView.addIndividualButtonConstraints(&self.buttonsRowOne, mainView: self.textKeyboardRowOne)
            self.textKeyboardView.addIndividualButtonConstraints(&self.buttonsRowTwo, mainView: self.textKeyboardRowTwo)
            self.textKeyboardView.addIndividualButtonConstraints(&self.buttonsRowThree, mainView: self.textKeyboardRowThree)
            self.textKeyboardView.addIndividualButtonConstraints(&self.buttonsRowFour, mainView: self.textKeyboardRowFour)
        })
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        nameLabel.hidden = true
        chooseQuoteView.hidden = true
        
        // Add text keyboard in background
        
        textKeyboardView.addRowOfButtons(&textKeyboardRowOne, buttonTitles: buttonTitlesRowOne, buttons: &buttonsRowOne)
        textKeyboardView.addRowOfButtons(&textKeyboardRowTwo, buttonTitles: buttonTitlesRowTwo, buttons: &buttonsRowTwo)
        textKeyboardView.addRowOfButtons(&textKeyboardRowThree, buttonTitles: buttonTitlesRowThree, buttons: &buttonsRowThree)
        textKeyboardView.addRowOfButtons(&textKeyboardRowFour, buttonTitles: buttonTitlesRowFour, buttons: &buttonsRowFour)
        textKeyboardView.addIndividualButtonConstraints(&buttonsRowOne, mainView: textKeyboardRowOne)
        textKeyboardView.addIndividualButtonConstraints(&buttonsRowTwo, mainView: textKeyboardRowTwo)
        textKeyboardView.addIndividualButtonConstraints(&buttonsRowThree, mainView: textKeyboardRowThree)
        textKeyboardView.addIndividualButtonConstraints(&buttonsRowFour, mainView: textKeyboardRowFour)
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
        showNameLabel()
        nameEntryTextField.layer.borderColor = borderColor
    }

    func showNameLabel() {
        if nameEntryTextField.text == "" && !nameEntryTextField.isFirstResponder() {
            nameLabel.hidden = false
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
    
    @IBAction func expandCategory() {
        if sectionExpanded {
            
            self.categoryLabel.text = lastCategoryDisplayed

            self.view.removeConstraint(categoryTableViewTop)
            
            let newTopConstraint = NSLayoutConstraint(
                item: self.categoryHeader,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self.tableView1,
                attribute: .Bottom,
                multiplier: 1,
                constant: 0
            )
            
            let newBottomConstraint = NSLayoutConstraint(
                item: self.categoryHeader,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Bottom,
                multiplier: 1,
                constant: 0
            )
            
            self.categoryTableViewTop = newTopConstraint
            self.categoryTableViewBottom = newBottomConstraint
            self.view.addConstraints([newTopConstraint, newBottomConstraint])

            UIView.animateWithDuration(0.2, animations: {
                self.view.layoutIfNeeded()
                })
            sectionExpanded = false
            self.arrowIcon.transform = CGAffineTransformMakeScale(1,1)
            
        } else {
            
            self.categoryLabel.text = ""
            
            self.view.removeConstraint(categoryTableViewTop)
            self.view.removeConstraint(categoryTableViewBottom)
            
            let newTopConstraint = NSLayoutConstraint(
                item: self.categoryHeader,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Top,
                multiplier: 1,
                constant: 0
            )
            
            self.categoryTableViewTop = newTopConstraint
            self.view.addConstraint(newTopConstraint)
            
            UIView.animateWithDuration(0.2, animations: {
                self.view.layoutIfNeeded()
                })
            sectionExpanded = true
            self.arrowIcon.transform = CGAffineTransformMakeScale(1,-1)
        }
        
    }
    
    
}
