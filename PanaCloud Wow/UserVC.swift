//
//  UserVC.swift
//  WowAttendance
//
//  Created by Mohsin on 24/01/2015.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit

class UserVC: UIViewController {
    
    
    var uID = ""
    var name = ""
    var email = ""

    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUID: UILabel!
    @IBOutlet weak var lblUserInfo: UILabel!
    
    
    let userRef = Firebase(url: "https://panacloud1.firebaseio.com/users/\(loginUser?.uID)")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblName.text = self.name
        self.lblUID.text = self.uID
        self.lblUserInfo.text = self.email
        
        
        var asyncObject = AsyncObject(ref: self.userRef) { (data, updateKey) -> Void in
            if data != nil {
                self.uiUpdate(data!)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func uiUpdate(data : [String : AnyObject]) {
        
        self.lblUID.text = "@\(self.userRef.key)"
        
        var fName = String()
        var lName = String()
        
        if data["firstName"] != nil {
            fName = data["firstName"] as NSString
            self.lblName.text = "\(fName) \(lName)"

        }
        if data["lastName"] != nil {
            lName = data["lastName"] as NSString
            self.lblName.text = "\(fName) \(lName)"
        }
        if data["email"] != nil {
            self.lblUserInfo.text = data["email"] as NSString

        }
    
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func back(sender: UIBarButtonItem) {
        self.userRef.removeAllObservers()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
