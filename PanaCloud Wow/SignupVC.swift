//
//  SignupVC.swift
//  AttendanceSystem
//
//  Created by Mohsin on 02/01/2015.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit

class SignupVC: UIViewController, UIScrollViewDelegate {

    
    var msg: String!
    var status: String!
    var rePasswordMatch = false
    var isWating = false
    
    @IBOutlet weak var txtUID: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var lblRePasswordMatchingMsg: UILabel!


    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    
    @IBOutlet weak var imgBackground: UIImageView!

    @IBOutlet weak var lblErrorMsg: UILabel!
    @IBOutlet weak var waitingInd: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btnCancel.layer.cornerRadius = 4.0
        btnCreate.layer.cornerRadius = 4.0
        
        
        self.txtUID.layer.borderWidth = 1.0
        self.txtEmail.layer.borderWidth = 1.0
        self.txtFirstName.layer.borderWidth = 1.0
        self.txtLastName.layer.borderWidth = 1.0
        self.txtPassword.layer.borderWidth = 1.0
        self.txtRePassword.layer.borderWidth = 1.0
        
        self.txtUID.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        self.txtEmail.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        self.txtFirstName.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        self.txtLastName.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        self.txtPassword.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        self.txtRePassword.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        
        self.txtUID.layer.cornerRadius = 4.0
        self.txtEmail.layer.cornerRadius = 4.0
        self.txtFirstName.layer.cornerRadius = 4.0
        self.txtLastName.layer.cornerRadius = 4.0
        self.txtPassword.layer.cornerRadius = 4.0
        self.txtRePassword.layer.cornerRadius = 4.0
        

        self.waitingInd.hidden = true
        self.lblRePasswordMatchingMsg.hidden = true



        self.scrollView.contentSize = self.containerView.frame.size
      //  println(self.scrollView.contentSize)

        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        //self.imgBackground.image = backgroundImage
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        if self.isWating{
            self.lblErrorMsg.text = "please wait for response..."
        }
        else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func create(sender: AnyObject) {
        
        if isAllFilled() {
            
            if self.isWating{
                self.lblErrorMsg.text = "please wait for response..."
            }
            else {
                self.isWating = true
                self.waitingInd.hidden = false
                self.lblErrorMsg.text = "SignUping please wait..."

                
                let user = User(ref: "", uID: self.txtUID.text, email: self.txtEmail.text, firstName: self.txtFirstName.text, lastName: self.txtLastName.text, status: "1")
                
                wowref.asyncSignUpUser(user, password: self.txtPassword.text, callBack: { (error) -> Void in
                    println(error)
                    
                    
                    var errorAlert = UIAlertController(title: "Error!", message: "", preferredStyle: .Alert)
                    var errorAction: UIAlertAction!
                    
                    
                    if error != nil {
                        
                        errorAction = UIAlertAction(title: "Back", style: .Default, handler: nil)
                        
                        errorAlert.message = error
                        
                        errorAlert.addAction(errorAction)
                    }
                    else{
                        errorAlert.title = "Success!"
                        errorAlert.message = "Succefully Signup"
                        
                        errorAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                        
                        errorAlert.addAction(errorAction)
                    }
                    
                    // update UI in main thread
                    dispatch_sync(dispatch_get_main_queue()) {
                        self.presentViewController(errorAlert, animated: true, completion: nil)
                        
                        self.isWating = false
                        self.waitingInd.hidden = true
                        self.lblErrorMsg.text = ""

                    }

                    
                })
            }
            
        }
        else{
            var backAlert = UIAlertController(title: "Error!", message: "Kindly fill all fields.", preferredStyle: .Alert)

            let back = UIAlertAction(title: "Back", style: .Default, handler: nil)

            backAlert.addAction(back)
            
            presentViewController(backAlert, animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func txtFieldEditing(sender: UITextField) {
        
        var changeInYaxis : CGFloat {
            if sender.frame.origin.y > 150{
                return sender.frame.origin.y - 150.0
            }
            else{
                return 0
            }
        }
        
        UIView.transitionWithView(self.containerView, duration: 0.5, options: UIViewAnimationOptions.TransitionNone, animations: {         self.containerView.frame = CGRect(x: 0.0, y: -changeInYaxis, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)

            
            }, completion: nil)
    }


    @IBAction func rePasswordEditingComplete(sender: AnyObject) {
        if self.txtPassword.text != self.txtRePassword.text {
            self.lblRePasswordMatchingMsg.hidden = false
        }
        else{
            self.lblRePasswordMatchingMsg.hidden = true
            self.rePasswordMatch = true
        }
    }
    
    func isAllFilled() -> Bool{
        if self.txtUID.text != "" &&
        self.txtEmail.text != "" &&
        self.txtFirstName.text != "" &&
        self.txtLastName.text != "" &&
        self.txtPassword.text != "" &&
            self.txtRePassword.text != ""
        {
                return true
        }

        else{
            return false
        }
        
    }
    
    @IBAction func whenSelect(sender: UITextField) {
        sender.layer.borderColor = colorLBlue.CGColor
        // shadow on
        sender.layer.shadowRadius = 3
        sender.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        sender.layer.shadowOpacity = 0.8
        sender.layer.shadowColor = colorLBlue.CGColor
        sender.layer.masksToBounds = false
    }
    @IBAction func whenDeSelect(sender: UITextField) {
        sender.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        // shadow off
        sender.layer.masksToBounds = true
        
    }
}
