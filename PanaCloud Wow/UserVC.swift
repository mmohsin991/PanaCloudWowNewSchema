//
//  UserVC.swift
//  WowAttendance
//
//  Created by Mohsin on 24/01/2015.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit

class UserVC: UIViewController {
    
    
    var uID = "@mmohsin"
    var name = "Muhammad Mohsin"
    var desc = "I am going good"

    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUID: UILabel!
    @IBOutlet weak var lblUserInfo: UILabel!
    
    
    let userRef = Firebase(url: "https://panacloud1.firebaseio.com/users/mmohsin")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblName.text = self.name
        self.lblUID.text = self.uID
        self.lblUserInfo.text = self.desc
        
        
        var asyncObject = AsyncObject(ref: userRef) { (data) -> Void in
            println(data)
            self.uiUpdate(data)

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func uiUpdate(data : [String : AnyObject]) {
        
        self.lblUID.text = "@\(self.userRef.key)"
        
        
        let fName = data["firstName"] as NSString
        let lName = data["lastName"] as NSString
    
        self.lblName.text = "\(fName) \(lName)"
        self.lblUserInfo.text = data["email"] as NSString
        
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
