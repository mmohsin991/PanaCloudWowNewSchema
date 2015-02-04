//
//  AddOrgVC.swift
//  WowAttendance
//
//  Created by Mohsin on 23/01/2015.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit

class AddOrgVC: UIViewController, UIScrollViewDelegate {
    
    
    var msg: String!
    var status: String!
    var rePasswordMatch = false
    var isWating = false
    
    @IBOutlet weak var txtOrgID: UITextField!
    @IBOutlet weak var txtOrgTitle: UITextField!
    @IBOutlet weak var txtOrgDesc: UITextField!
    @IBOutlet weak var txtOrgMembers: UITextField!
    
    
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
        
        
        self.txtOrgID.layer.borderWidth = 1.0
        self.txtOrgTitle.layer.borderWidth = 1.0
        self.txtOrgDesc.layer.borderWidth = 1.0
        self.txtOrgMembers.layer.borderWidth = 1.0

        
        self.txtOrgID.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        self.txtOrgTitle.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        self.txtOrgDesc.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        self.txtOrgMembers.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor

        
        self.txtOrgID.layer.cornerRadius = 4.0
        self.txtOrgTitle.layer.cornerRadius = 4.0
        self.txtOrgDesc.layer.cornerRadius = 4.0
        self.txtOrgMembers.layer.cornerRadius = 4.0

        
        
        self.waitingInd.hidden = true
        
        
        self.scrollView.contentSize = self.containerView.frame.size
        //  println(self.scrollView.contentSize)
        
        
//        var team1 = Team(ref: "", orgID: "mohsinTeam4", desc: "omdsoam omdsa", title: "dsafa fdsa", owner: "mmohsin", members:  ["mmohsin" : 1])
//        
//        wowref.asyncCreateOrganization(team1, callBack: { (errorDesc, unRegMembersUIDs) -> Void in
//            if errorDesc == nil {
//                println("org crated")
//                println(unRegMembersUIDs)
//            }
//                
//            else{
//                println(errorDesc)
//            }
//        })
        
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
        
        
        UIView.transitionWithView(self.containerView, duration: 0.5, options: UIViewAnimationOptions.TransitionNone, animations: {         self.containerView.frame = CGRect(x: 0.0, y: 0.0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            
            
            }, completion: nil)
        
        if isAllFilled() {
            
            if self.isWating{
                self.lblErrorMsg.text = "please wait for response..."
            }
            else {
                self.isWating = true
                self.waitingInd.hidden = false
                self.lblErrorMsg.text = "Org is Creating please wait..."
                
                let user = User(ref: "", uID: self.txtOrgID.text, email: self.txtOrgTitle.text, firstName: self.txtOrgDesc.text, lastName: self.txtOrgMembers.text, status: "1")
                
                let org = Team(ref: "", orgID: self.txtOrgID.text, desc: self.txtOrgDesc.text, title: self.txtOrgTitle.text, owner: loginUser!.uID, members: self.stringToDic(self.txtOrgMembers.text))

                wowref.asyncCreateOrganization(org, callBack: { (errorDesc, unRegMembersUIDs) -> Void in
                    var errorAlert = UIAlertController(title: "Error!", message: "", preferredStyle: .Alert)
                    var errorAction: UIAlertAction!
                    
                    
                    if errorDesc != nil {
                        
                        errorAction = UIAlertAction(title: "Back", style: .Default, handler: nil)
                        
                        errorAlert.message = errorDesc!
                        
                        errorAlert.addAction(errorAction)
                        
                        println(errorDesc)
                    }
                    else{
                        errorAlert.title = "Success!"
                        if unRegMembersUIDs == nil {
                            errorAlert.message = "Succefully Org Created"

                        }
                        else if unRegMembersUIDs != nil{
                            errorAlert.message = "Succefully Org Create \n Note: These member(s) not exist\(unRegMembersUIDs!)"
                        }
                        
                        errorAction = UIAlertAction(title: "Ok", style: .Default, handler: { _ in
                        self.dismissViewControllerAnimated(true, completion: nil)
                        })
                        
                        
                        errorAlert.addAction(errorAction)
                        
                        println("Succefully Org Created")

                    }
                    
                    // update UI in main thread
                    dispatch_async(dispatch_get_main_queue()) {
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

    
    func isAllFilled() -> Bool{
        if self.txtOrgID.text != "" &&
            self.txtOrgTitle.text != "" &&
            self.txtOrgDesc.text != ""
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
    
    func stringToDic(string: String)-> [String : Int]{
        
        var tempArr = [String : Int]()
        
        tempArr[string] = 1
        
        return tempArr
    }
}
