//
//  ViewController.swift
//  ContainingAppForBard-3
//
//  Created by Test Account on 7/14/15.
//  Copyright (c) 2015 Vibin Kundukulam. All rights reserved.
//

import UIKit
import MessageUI
import QuartzCore

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
   // "Test"
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self 
        mailComposerVC.setToRecipients(["vibin.kundukulam@gmail.com"])
        mailComposerVC.setSubject("Feedback")
        let messageBody = "Feel free to comment on... \n\n1) UX - Easy to install and use?\n\n\n\n2) Design - Colors and layout?\n\n\n\n3) Content - Favorite category? Which ones need more quotes?\n\n\n\n4) Bugs - What broke, and what were you doing that led up to it? Please include iPhone model and iOS version.\n\n\n\n5) Marketing - Who do you think would love Trumped, and what would they use it for?"
        
        mailComposerVC.setMessageBody(messageBody, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }


}

class DesignableButton: UIButton {
@IBInspectable var borderColor: UIColor = UIColor.whiteColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
}

