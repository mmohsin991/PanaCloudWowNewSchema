//
//  HomeVC.swift
//  AttendanceSystem
//
//  Created by Mohsin on 02/01/2015.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit



@objc
protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class HomeVC: WowUIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITabBarDelegate {

    @IBOutlet weak var imgBackground: UIImageView!
    

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var orgTableView: UITableView!
    @IBOutlet weak var loadingInd: UIActivityIndicatorView!
    @IBOutlet weak var loadingLbl: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    var ownersList = [String: [NSObject : AnyObject] ]()
    var subscriberList = [String: [NSObject : AnyObject] ]()

    var tableType = "SPACES"
    var tempNotification = [String: [NSObject : AnyObject] ]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.contentSize = self.containerView.frame.size

        
        // temp loaded data
        self.tempNotification = [
            "Not1" : ["title":"Notification1", "desc":"do some thing 1"],
            "Not2" : ["title":"Notification2", "desc":"do some thing 2"],
            "Not3" : ["title":"Notification3", "desc":"do some thing 3"],
            "Not4" : ["title":"Notification4", "desc":"do some thing 4"],
            "Not5" : ["title":"Notification5", "desc":"do some thing 5"],
            "Not6" : ["title":"Notification6", "desc":"do some thing 6"],
            "Not7" : ["title":"Notification7", "desc":"do some thing 7"],
            "Not8" : ["title":"Notification8", "desc":"do some thing 8"],
            "Not9" : ["title":"Notification9", "desc":"do some thing 9"],
            "Not10" : ["title":"Notification10", "desc":"do some thing 10"],
            "Not11" : ["title":"Notification11", "desc":"do some thing 11"]]
        

        self.ownersList = [
            "Not1" : ["title":"Orginization1", "desc":"do some thing 1"],
            "Not2" : ["title":"Orginization2", "desc":"do some thing 2"],
        ]
        
        
        self.subscriberList = [
            "Not1" : ["title":"Orginization1", "desc":"do some thing 1"],
            "Not2" : ["title":"Orginization2", "desc":"do some thing 2"],
            "Not3" : ["title":"Orginization3", "desc":"do some thing 3"],
        ]
        
        
        // table view configurations
        self.orgTableView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        self.orgTableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        
        //self.navigationController?.navigationBar.backgroundColor = UIColor.greenColor()
        self.navigationItem.titleView = imgBarLogo
        
//        // made user image in round shape
//        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
//        self.imgUser.layer.masksToBounds = true
        
        self.btnAdd.layer.cornerRadius = self.btnAdd.frame.size.width/2
//        self.btnAdd.layer.shadowRadius = 1
//        self.btnAdd.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        self.btnAdd.layer.shadowOpacity = 0.8
//        self.btnAdd.layer.shadowColor = UIColor.darkGrayColor().CGColor
//        self.btnAdd.layer.masksToBounds = false
        
      //  delegate?.collapseSidePanels!()
        
//        // load the orgs list
//         wowref.asyncGetUsesOwnerMemberOrgsList("zia", callBack: { (ownersList, memberList) -> Void in
//            if ownersList != nil {
//                self.ownersList = ownersList!
//                self.tableView.reloadData()
//                
//                println(memberList)
//                
//                // stop and hide the loading indicators
//                self.loadingInd.stopAnimating()
//                self.loadingLbl.hidden = true
//                
//            }
//
//         })
        
    
        if loginUser == nil {
            loginUser = User(ref: "", uID: "shezi", email: "shahzadscs@gmail.com", firstName: "Shahzad", lastName: "Soomro", status: "pending")
        }
//        
//            loginUser?.asynGetSubscriberOrgs({ (orgList) -> Void in
//                if orgList != nil {
//                    
//                    self.subscriberList = orgList!
//                    self.orgTableView.reloadData()
//                    
//                    
//                    // stop and hide the loading indicators
//                    self.loadingInd.stopAnimating()
//                    self.loadingLbl.hidden = true
//                }
//                
//            })
//            
//            loginUser?.asynGetOwnerOrgs({ (orgList) -> Void in
//                
//                if orgList != nil {
//                    self.ownersList = orgList!
//                    self.orgTableView.reloadData()
//                    
//                    
//                    // stop and hide the loading indicators
//                    self.loadingInd.stopAnimating()
//                    self.loadingLbl.hidden = true
//                    
//                }
//                
//            })

    
//        if loginUser != nil{
//            lblUID.text = "@\(loginUser!.uID)"
//            lblName.text = "\(loginUser!.firstName) \(loginUser!.lastName)"
//            lblEmail.text = loginUser!.email
//        }
        
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.tableType == "SPACES" {
            return self.ownersList.keys.array.count + self.subscriberList.keys.array.count
        }
        else if self.tableType == "NOTIFICATIONS" {
            return self.tempNotification.keys.array.count
        }
        return 0
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        // if orgs TableView comes
        if self.tableType == "SPACES" {
            if indexPath.row < self.ownersList.keys.array.count {
                cell.textLabel?.text = self.ownersList.values.array[indexPath.row]["title"] as NSString
                cell.detailTextLabel?.text = self.ownersList.values.array[indexPath.row]["desc"] as NSString
            }
            else {
                let tempIndexRow = indexPath.row - self.ownersList.keys.array.count
                
                cell.textLabel?.text = self.subscriberList.values.array[tempIndexRow]["title"] as NSString
                cell.detailTextLabel?.text = self.subscriberList.values.array[tempIndexRow]["desc"] as NSString
            }
            
             cell.imageView?.image = UIImage(named: "org")
            
        }
        
        // if notification TableView comes
        else if self.tableType == "NOTIFICATIONS"{
            
                cell.textLabel?.text = self.tempNotification.values.array[indexPath.row]["title"] as NSString
                cell.detailTextLabel?.text = self.tempNotification.values.array[indexPath.row]["desc"] as NSString
            
            
            cell.imageView?.image = UIImage(named: "notification")

            
        }
            
        cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        cell.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        cell.textLabel?.textColor = colorLBlue

        
        // for image to round shape
//        cell.imageView?.layer.cornerRadius = 25
//        cell.imageView?.layer.masksToBounds = true
        

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "teamSeg" {
//            
//            let desVC = segue.destinationViewController as TeamVC
//            
//            desVC.selectedOrgId = sender as String
//            desVC.memberTypeWithOrg = self.segmentControl.selectedSegmentIndex
//            desVC.delegate = self.delegate
//        }
        
        
    }
    
    
    
    func subscribeOrg() {
        var subscribeAlert = UIAlertController(title: "Subscribe Org", message: "Write Org Id Below", preferredStyle: .Alert)
        
        subscribeAlert.addTextFieldWithConfigurationHandler { (txtOrgId) -> Void in
            txtOrgId.placeholder = "Org Id"
            
            //            txtOrgId.layer.borderWidth = 2.0
            //            txtOrgId.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
            //            txtOrgId.layer.cornerRadius = 4.0
            //
            //
            //            // shadow on
            //            txtOrgId.layer.shadowRadius = 3
            //            txtOrgId.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            //            txtOrgId.layer.shadowOpacity = 0.8
            //            txtOrgId.layer.shadowColor = colorLBlue.CGColor
            //            txtOrgId.layer.masksToBounds = false
        }
        
        let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { _ in
            
            let txtOrgId = subscribeAlert.textFields![0] as UITextField
            
            println(txtOrgId.text)
            // add subscribe function here
            
            
        })
        let no = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil)
        subscribeAlert.addAction(no)
        subscribeAlert.addAction(yes)
        
        presentViewController(subscribeAlert, animated: true, completion: nil)
    }
    
    // tab bar delegate function for selection teh item
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        self.tableType = item.title!
        self.lblTitle.text = "  \(item.title!)"

        self.orgTableView.reloadData()

        println(item.title!)
    }

    @IBAction func rightMenu(sender: AnyObject) {
        delegate?.toggleRightPanel!()
    }
    
    
    @IBAction func addOrg(sender: AnyObject) {
        
            performSegueWithIdentifier("addOrgSeg", sender: self)

    }
    
    @IBAction func subcOrg(sender: AnyObject) {
        
        // func to subscribe org
        subscribeOrg()
    }
    
    @IBAction func userCheckIn(sender: AnyObject) {
        self.performSegueWithIdentifier("userCheckInSeg", sender: self)
    }

    @IBAction func scrollNotification(sender: UIButton) {
        
        // move up side
        if sender.imageView?.image == UIImage(named: "up") {
            UIView.transitionWithView(self.containerView, duration: 0.5, options: UIViewAnimationOptions.CurveEaseOut,
                animations: {
                    self.containerView.frame = CGRect(x: 0, y: -275, width: 320, height: 843)
                },
                completion: {(bool) -> Void in
                    sender.setImage(UIImage(named: "down"), forState: UIControlState.Normal)
            })
        }
            // move downward
            else if sender.imageView?.image == UIImage(named: "down") {
                UIView.transitionWithView(self.containerView, duration: 0.5, options: UIViewAnimationOptions.CurveEaseOut,
                    animations: {
                        self.containerView.frame = CGRect(x: 0, y: 0, width: 320, height: 843)
                    },
                    completion: {(bool) -> Void in
                        sender.setImage(UIImage(named: "up"), forState: UIControlState.Normal)
                })
            }
        
        //        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
        //            containerView.layer.transform = CGAffineTransformMakeRotation(M_PI)
        //        }) { (Bool) -> Void in
        //            <#code#>
        //        }

    }

    @IBAction func userClicked(sender: AnyObject) {
        
        performSegueWithIdentifier("userSeg", sender: self)
    }
}
