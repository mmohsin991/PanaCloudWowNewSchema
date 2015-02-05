//
//  LoginVC.swift
//  AttendanceSystem
//
//  Created by Mohsin on 02/01/2015.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//



import UIKit


class LoginVC: UIViewController {

    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var lblErrorMsg: UILabel!
    
    @IBOutlet weak var watingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imgBackground: UIImageView!

    @IBOutlet weak var containerView: UIView!
    
    var isWating = false

    
    func setFontColor() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // example for time saving and retriving
        
        let reff = Firebase(url: "https://panacloud1.firebaseio.com/")
         reff.updateChildValues(["tempTime": kFirebaseServerValueTimestamp])
        reff.childByAppendingPath("tempTime").observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot) -> Void in
            
            let timeInMiliSeconds = snapshot.value as? Double           
        
            println(fTimeStampToNSDate(timeInMiliSeconds))

        })
        
        
        let space = SpaceMetaData(spaceID: "panacloud") { (space) -> Void in
            println(space.spaceID)
        }
        
        space.observer { (space) -> Void in
            println(space.desc)

        }
        
//        let space1 = SpaceMetaData(spaceID: "mohsinSpace", desc: "my sapce", title: "Mohsin's Spaces", owner: "mmohsin", members: nil, emailDomainRestriction : "mmohsun@com")
        

        
//        wowref.setUserMemberships("mmohsin", spaceID: "panacloud", membership_type: "1")
//        wowref.setSpaceMembers("panacloud", userID: "mmohsin", membership_type: "1")

        

        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.watingIndicator.hidden = true
        
        
        self.btnSignIn.layer.cornerRadius = 4.0
        self.btnSignUp.layer.cornerRadius = 4.0
        
        self.txtEmail.layer.borderWidth = 2.0
        self.txtPassword.layer.borderWidth = 2.0

        self.txtEmail.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        self.txtPassword.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        
        self.txtEmail.layer.cornerRadius = 4.0
        self.txtPassword.layer.cornerRadius = 4.0
        
        
        self.containerView.frame = CGRect(x: 0, y: 60, width: 320, height: 428)
        
        
        // temp work
        
        var team = Team(ref: "", orgID: "mohsinTeam", desc: "mohsin is the owner", title: "mohsin tem org", owner: "mmohsin")
//        var team1 = Team(ref: "", orgID: "mohsinTeam3", desc: "omdsoam omdsa", title: "dsafa fdsa", owner: "mmohsin", members:  ["mmohsin" : 1])
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
//
//        wowref.asynUserIsExist("mmohsin", callBack: { (isExist) -> Void in
//            if isExist {
//                println("user exist")
//            }
//            else{
//                println("user not exist")
//            }
//        })
//        
//        wowref.asyncSpaceIsExist("panacloud", callBack: { (isExist) -> Void in
//            if isExist {
//                println("space exist")
//            }
//            else{
//                println("space not exist")
//            }
//        })
        
        
//        wowref.asyncLoginUser("ziaukhan@hotmail.com", password: "123") { (error) -> Void in
//            if error != nil {
//            //    println(error)
//            }
//            else{
//                println("login successfuly")
//            }
//        }

        
    }
    
    
    override func viewWillAppear(animated: Bool) {
     //   self.imgBackground.image = backgroundImage
        
        self.lblErrorMsg.text = ""
        self.watingIndicator.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
    }
    
    @IBAction func signUP(sender: UIButton) {
                
        performSegueWithIdentifier("signupSeg", sender: nil)
        
        
//        let ref = Firebase(url: "https://sweltering-inferno-1689.firebaseio.com")
//        
//        ref.createUser(self.txtEmail.text, password: self.txtPassword.text,
//            withCompletionBlock: { error in
//                self.watingIndicator.hidden = true
//                
//                if error != nil {
//                    // There was an error creating the account
//                    self.lblErrorMsg.text = error.localizedDescription
//                    
//                } else {
//                    // We created a new user account
//                    
//                    self.performSegueWithIdentifier("singupSeg", sender: "successfuly sign up")
//                    
//                    
//                }
//        })
        
        
        
    }
    
    
    @IBAction func signIn(sender: UIButton) {
        
//        self.txtEmail.resignFirstResponder()
//        self.txtPassword.resignFirstResponder()
        
        self.view.endEditing(true)
        
        
        if (self.txtEmail.text == "" || self.txtPassword.text == "") || (self.isWating) {
            if self.isWating{
                self.lblErrorMsg.text = "please wait for response..."
            }
            else{
                self.lblErrorMsg.text = "please fill the both fields"
            }
        }
            
        else{
            self.watingIndicator.hidden = false
            self.isWating = true
            self.lblErrorMsg.text = "loging..."


            
            wowref.asyncLoginUser(self.txtEmail.text, password: self.txtPassword.text) { (error, user) -> Void in
                
                
                self.isWating = false
                if error != nil {
                    // There was an error logging in to this account
                    
                    // update UI in main thread
                    dispatch_sync(dispatch_get_main_queue()) {
                        self.watingIndicator.hidden = true
                        self.lblErrorMsg.text = error
                        self.watingIndicator.hidden = true
                    }
                    

                    
                } else {
                    // We are now logged in
                    var message = "successfuly sign in "
                    println(message)
                    
                    loginUser = user
                 //   self.dismissViewControllerAnimated(true, completion: {
                       // self.performSegueWithIdentifier("homeSeg", sender: self)
                    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                    let window = appDel.window?
                    
                    let containerViewController = ContainerViewController()
                    
                    window!.rootViewController = containerViewController
                    window!.makeKeyAndVisible()
                    
                 //   })

                }
            }

        }
        
    }
    
    
    @IBAction func passwordEditing(sender: AnyObject) {
        UIView.transitionWithView(self.view, duration: 0.5, options: UIViewAnimationOptions.TransitionNone, animations: {         self.view.frame = CGRect(x: 0, y: -60, width: 320, height: 568)
            }, completion: nil)
    }
    @IBAction func passwordEditingComplete(sender: AnyObject) {
        UIView.transitionWithView(self.view, duration: 0.3, options: UIViewAnimationOptions.TransitionNone, animations: {         self.view.frame = CGRect(x: 0, y: 0, width: 320, height: 568)
            }, completion: nil)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
