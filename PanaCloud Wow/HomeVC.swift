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
    
    var ownersList = [String: AnyObject]()
    var spaceMetaData = [SpaceMetaData]()

    var tableType = "SPACES"

    var tempNotification = [String: AnyObject]()

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ownersList.keys.array
        self.scrollView.contentSize = self.containerView.frame.size

        if loginUser == nil {
            loginUser = User(ref: "", uID: "zia", email: "ziaukhan@hotmail.com", firstName: "Zia", lastName: "Khan", status: "verified")
        }
        
        println("muhammad.mohsin.991@gmail.com".md5)
        
        //wowref.updateActiviy("pacacloud", verb: "i do", displayName: "i am doing some thing", actor: ["type" : "user"], object: ["type" : "user"], target: ["type" : "space"])
        
        loginUser?.asyncGetMemberList({ (members) -> Void in
            
            if members != nil {
                // when spaces list is loaded then acquirng for desc for spaces
//                wowref.asyncSpaceDesc(members!.keys.array, { (spacesDesc) -> Void in
//                    self.ownersList = spacesDesc
//                    
//                  //  println(spacesDesc)
//                    
//                    self.orgTableView.reloadData()
//                    
//                    // stop and hide the loading indicators
//                    self.loadingInd.stopAnimating()
//                    self.loadingLbl.hidden = true
//                
//                })
                
                var count = 0
                for member in members!.keys.array {
                    
                    let space = SpaceMetaData(spaceID: member, callBack: { (space) -> Void in
                        self.spaceMetaData.append(space)
                        count++
                        
                        if count == members!.keys.array.count{
                            // stop and hide the loading indicators
                            
                            self.loadingInd.stopAnimating()
                            self.loadingLbl.hidden = true
                            

                        }
                    })
                    space.observer({ (space) -> Void in
                        self.orgTableView.reloadData()

                    })
                }

                // when spaces list is loaded then acquirng for desc for spaces
                loginUser?.asyncGetActivityStream({ (activities) -> Void in
                    
                    self.tempNotification = activities!
                    self.orgTableView.reloadData()

                })
            }
            
        })
        


        
        
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
//            return self.ownersList.keys.array.count
            return self.spaceMetaData.count
        }
        else if self.tableType == "NOTIFICATIONS" {
            return self.tempNotification.keys.array.count
        }
        return 0
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{

        // if orgs TableView comes
        if self.tableType == "SPACES" {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as SpaceTableViewCell
            
            
            //                if self.ownersList.values.array[indexPath.row]["title"] != nil {
            //                    cell.textLabel?.text = self.ownersList.values.array[indexPath.row]["title"] as NSString
            //                }
            //                if self.ownersList.values.array[indexPath.row]["desc"] != nil {
            //                    cell.detailTextLabel?.text = self.ownersList.values.array[indexPath.row]["desc"] as NSString
            //                }
            
            
            cell.title?.text = self.spaceMetaData[indexPath.row].title
            cell.desc?.text = self.spaceMetaData[indexPath.row].desc
            cell.members_count?.text = self.spaceMetaData[indexPath.row].members_count.description
            cell.checkInCount?.text = (self.spaceMetaData[indexPath.row].members_checked_in["count"] as NSNumber).description
            cell.teams_count?.text = self.spaceMetaData[indexPath.row].teams_count.description
            cell.subteams_count?.text = self.spaceMetaData[indexPath.row].subteams_count.description
            
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
            cell.textLabel?.textColor = colorLBlue
            
            
            // for image to round shape
            //        cell.imageView?.layer.cornerRadius = 25
            //        cell.imageView?.layer.masksToBounds = true
            
            
            return cell
            
        }
        
        // if notification TableView comes
        else if self.tableType == "NOTIFICATIONS"{
           // let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle , reuseIdentifier: "cell")
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath) as NotificatioTableViewCell

            if self.tempNotification.values.array[indexPath.row]["verb"] != nil {
                cell.title.text = self.tempNotification.values.array[indexPath.row]["verb"] as NSString

            }
            if self.tempNotification.values.array[indexPath.row]["displayName"] != nil {
                cell.desc.text = self.tempNotification.values.array[indexPath.row]["displayName"] as NSString
            }
            if let date: AnyObject? = self.tempNotification.values.array[indexPath.row]["published"]{
                
                let dataAndTime = (date as NSNumber)
                cell.data.text =  fTimeStampToNSDate(dataAndTime).description

            }
            
            
            
            cell.notificationImage.image = imgNotification
            
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
            cell.textLabel?.textColor = colorLBlue
            
            
            // for image to round shape
            //        cell.imageView?.layer.cornerRadius = 25
            //        cell.imageView?.layer.masksToBounds = true
            
            
            return cell
        }
        
        return UITableViewCell()

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
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
        //            
        //        }

    }

    @IBAction func userClicked(sender: AnyObject) {
        
        performSegueWithIdentifier("userSeg", sender: self)
    }
}



class SpaceTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var members_count: UILabel!
    @IBOutlet weak var checkInCount: UILabel!
    @IBOutlet weak var teams_count: UILabel!
    @IBOutlet weak var subteams_count: UILabel!
    
    
    @IBOutlet weak var spaceImage: UIImageView!


    
}

class NotificatioTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var data: UILabel!
    
    @IBOutlet weak var notificationImage: UIImageView!
    
    
    
}
