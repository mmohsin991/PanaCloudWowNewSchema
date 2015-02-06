//
//  Model.swift
//  AttendanceSystem
//
//  Created by Mohsin on 02/01/2015.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import Foundation


let ref = Firebase(url: "https://sweltering-inferno-1689.firebaseio.com/")


struct Model {
    
    static func addUser(#username: String, email: String, fname: String, lname: String, teams: [String : Bool]){
        
        let usersRef = ref.childByAppendingPath("users")
        
        let insertedData = [username : [
            "firstName" : fname,
            "lastName" : lname,
            "email" : email,
            "teams" : teams
        ]]
        
        usersRef.updateChildValues(insertedData)
        
        
    }
    
    static func addUser(user: WowUser){
        
        let usersRef = ref.childByAppendingPath("users")
        
        if user.teams != nil {
            let insertedData = [user.userName : [
                "email" : user.email,
                "firstName" : user.firstName,
                "lastName" : user.lastName,
                "teams" : user.teams
            ]]
            
            usersRef.updateChildValues(insertedData)
        }
        else{
            let insertedData = [user.userName : [
                "email" : user.email,
                "firstName" : user.firstName,
                "lastName" : user.lastName,
            ]]
            
            usersRef.updateChildValues(insertedData)
        }
        
        
    }
    
    
    static func addTeam(#ref: Firebase, name: String, admins: [String : Bool], members: [String : Bool], subTeams : [String : AnyObject]!){
        
        // let rootTeamRef = ref.childByAppendingPath("teams")
        var teamRef: Firebase = ref
        
        // if parent is null means this is the root team (orginization) so add at the teams node
        //        if ancestorRef == nil {
        //            teamRef = rootTeamRef
        if subTeams == nil {
            let insertedData = [name : [
                "admins" : admins,
                "members" : members,
            ]]
            teamRef.updateChildValues(insertedData)
        }
        else {
            let insertedData = [name : [
                "admins" : admins,
                "members" : members,
                "subTeams" : subTeams
            ]]
            teamRef.updateChildValues(insertedData)
        }
        //        }
        
        // if parent is not null means this is the sub team of any team and add this at the subteams array of parant team
        //        else{
        //            teamRef = rootTeamRef.childByAppendingPath("\(ancestorRef)/subTeams")
        //
        //            if subTeams == nil {
        //                let insertedData = [name : [
        //                    "admins" : admins,
        //                    "members" : members,
        //                ]]
        //                teamRef.updateChildValues(insertedData)
        //            }
        //            else {
        //                let insertedData = [name : [
        //                    "admins" : admins,
        //                    "members" : members,
        //                    "subTeams" : subTeams
        //                ]]
        //                teamRef.updateChildValues(insertedData)
        //            }
        //        }
        
    }
    
    
    static func addTeam(team : WowTeam){
        
        if team.subTeams == nil {
            let insertedData = [team.name : [
                "admins" : team.admins,
                "members" : team.members,
            ]]
            team.ref.updateChildValues(insertedData)
        }
            
        else {
            let insertedData = [team.name : [
                "admins" : team.admins,
                "members" : team.members,
            ]]
            team.ref.updateChildValues(insertedData)
            
            for x in team.subTeams{
                self.addTeam(x)
            }
        }
        
    }
    
    
    static func getUser(userName: String) {
        var email: String!
        var firstName: String!
        var lastName: String!
        var teams: [String : Bool]!
        
        
        let refUsers = ref.childByAppendingPath("users")
        
        
        refUsers.queryOrderedByKey().queryEqualToValue(userName).observeSingleEventOfType(.ChildAdded, withBlock: { snapshot in
            
            if snapshot != NSNull() {
                if let fName = snapshot.value["firstName"] as? String {
                    firstName = fName
                }
                if let lName = snapshot.value["lastName"] as? String {
                    lastName = lName
                }
                if let tempemail = snapshot.value["email"] as? String {
                    email = tempemail
                }
                if let tempteams = snapshot.value["teams"] as? [String : Bool] {
                    teams = tempteams
                }
                println(WowUser(userName: userName, email: email, firstName: firstName, lastName: lastName, teams: teams))
                
            }
            
        })
        
        
    }
    
    static func mapToWowTeams (subTeams : [String : AnyObject]!, parent : Firebase ) -> [WowTeam]!{
        var teams = [WowTeam]()
        
        
        if subTeams != nil {
            
            for team in subTeams {
                //            let tempTeam = WowTeam(ref: parent.childByAppendingPath("/subTeams/\(team.0)"), name: team.0, admins: team.1["admins"] as [String : Bool], members:team.1["members"] as [String : Bool], SubTeams: mapToWowTeams(team.1["subTeams"] as [String : AnyObject], parent: parent.childByAppendingPath("/subTeams/\(team.0)")))
                
                let tempAdmins = team.1["admins"] as [String : Bool]
                let tempMembers = team.1["members"] as [String : Bool]
                var tempSubTeams : [WowTeam]!
                if let tempTeams = mapToWowTeams(team.1["subTeams"] as? [String : AnyObject], parent: parent.childByAppendingPath("/subTeams/\(team.0)")) {
                    tempSubTeams = tempTeams
                }
                
                let tempTeam = WowTeam(ref: parent.childByAppendingPath("/subTeams/\(team.0)"), name: team.0, admins: tempAdmins, members: tempMembers, SubTeams: tempSubTeams)
                teams.append(tempTeam)
                //
                //                println( parent.childByAppendingPath("/subTeams/\(team.0)") )
                //                println(team.0)
                //                println( tempAdmins )
                //                println( tempMembers )
                //
                
                // mapToWowTeams(team.1["subTeams"] as [String : AnyObject], parent: parent.childByAppendingPath("/subTeams/\(team.0)"))
                //          teams.append(tempTeam)
            }
            
            
            
            return teams
            
        }
        else{
            return nil
        }
        
    }
    
}


class WowUser {
    var userName: String
    var email: String
    var firstName: String
    var lastName: String
    var teams: [String : Bool]!
    
    init(userName: String, email: String, firstName: String, lastName: String, teams: [String : Bool]!){
        self.userName = userName
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.teams = teams
    }
}

class WowTeam {
    var ref: Firebase
    var name: String
    var admins: [String: Bool]
    var members: [String: Bool]
    var subTeams: [WowTeam]!
    
    init(ref: Firebase, name: String, admins: [String: Bool], members: [String: Bool], SubTeams: [WowTeam]?) {
        self.ref = ref
        self.name = name
        self.admins = admins
        self.members = members
        self.subTeams = SubTeams
    }
    
    init(ref: Firebase){
        self.ref = ref
        self.name = String()
        self.admins = [String: Bool]()
        self.members = [String: Bool]()
        self.subTeams = [WowTeam]()
    }
    
}


class User{
    var ref: String
    var uID: String
    var email: String
    var firstName: String
    var lastName: String
    var status: String
    // user's member owner list
    var spaces: [String : AnyObject]?
    
    
    
    init(ref: String, uID: String, email: String, firstName: String, lastName: String, status: String){
        self.ref = ref
        self.uID = uID
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.status = status
        
        
       // self.asyncSetOwnerMemberList { () -> Void in }
        
    }
    
    convenience init(ref: String, uID: String, email: String, firstName: String, lastName: String, status: String, spaces: [String : Int], owner: [String: [String: String]]){

        self.init(ref: ref, uID: uID, email: email, firstName: firstName, lastName: lastName, status: status)
        
        self.spaces = spaces
    }
    
    // retrive user's owner list and subcrober org list its a async method
    func asyncGetMemberList(callBack : (members: [String : AnyObject]?) -> Void){
        
        let ownerRef = WowRef.ref.childByAppendingPath("user-memberships/\(self.uID)")
        
        ownerRef.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            if !(snapshot.value is NSNull) {
                self.spaces = snapshot.value as? [String : AnyObject]
                callBack(members: self.spaces)
            }
            
            else {
                callBack(members: nil)
            }
        })
    }
    
    
    func asyncGetActivityStream(callBack : (activities: [String : AnyObject]?) -> Void){
        var tempActivities = [String : AnyObject]()
        var count = 0
        
        if self.spaces != nil {
            for space in self.spaces!.keys.array {
                WowRef.ref.childByAppendingPath("space-activity-streams/\(space)").observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) -> Void in
                   tempActivities[snapshot.key] = snapshot.value

                        callBack(activities: tempActivities)
                    
                })
            }
        }
    }
 
    
 
}

class Team {
    var ref: String
    var orgID: String
    var desc: String
    var title: String
    var owner: String // user uID
    var members: [String : Int]? // user uID, members type
    
    
    init(ref: String, orgID: String, desc: String, title: String, owner: String ){
        self.orgID = orgID
        self.desc = desc
        self.title = title
        self.ref = ref
        self.owner = owner

    }
    
    convenience init(ref: String, orgID: String, desc: String, title: String, owner: String, members: [String : Int]){
        self.init(ref: ref, orgID: orgID, desc: desc, title: title, owner: owner)
        
        self.members = members
        
    }
}

class Space {
    var ref: String
    var spaceID: String
    var desc: String
    var title: String
    var owner: String // user uID
    var members: [String : AnyObject]? // user uID, and member 
    
    
    init(ref: String, spaceID: String, desc: String, title: String, owner: String ){
        self.spaceID = spaceID
        self.desc = desc
        self.title = title
        self.ref = ref
        self.owner = owner
        
    }
    
    convenience init(ref: String, spaceID: String, desc: String, title: String, owner: String, members: [String :  AnyObject]){
        self.init(ref: ref, spaceID: spaceID, desc: desc, title: title, owner: owner)
        
        self.members = members

        
        
        
    }
}

class SpaceMetaData {
    var spaceID: String
    var desc: String
    var title: String
    var cover_image = spaceCoverImg
    var logo_image = spaceLogoImg
    var members_count = 1
    var teams_count = 0
    var subteams_count = 0
    var members_checked_in = [String : AnyObject]()
    var emailDomainRestriction: String?

    var members = [String : AnyObject]() // user uID, and member
    
    init(spaceID: String, desc: String, title: String, owner: String , members: [String]?, emailDomainRestriction : String?){
        self.spaceID = spaceID
        self.desc = desc
        self.title = title
        
        // if no member is provided at the time of initialinzation
        if members == nil {
            self.members[owner] = ["membership-type" : "1","timestamp" : kFirebaseServerValueTimestamp]
        }
        // if members is provided at the time of initialinzation
        else if members != nil{
            
            // convert array to dictionary
            for member in members!{
                self.members[member] = ["membership-type" : "3","timestamp" : kFirebaseServerValueTimestamp]
                self.members_count++

            }
        
            self.members[owner] = ["membership-type" : "1","timestamp" : kFirebaseServerValueTimestamp]

        }
        if emailDomainRestriction != nil {
            self.emailDomainRestriction = emailDomainRestriction
        }
        

        
    }
    
    func upload(callBack :(errorDesc: String?) -> Void){
         wowref.asyncSpaceIsExist(self.spaceID, callBack: { (isExist) -> Void in
            
            if isExist{
                callBack(errorDesc: "Space ID already exist please use another ID")
            }
            else{
                
                // upload to space metadata
                let tempRef = WowRef.ref.childByAppendingPath("space-meta-data/\(self.spaceID)")
                var data = [String: AnyObject]()
                
                data["title"] = self.title
                data["desc"] = self.desc
                data["members-count"] = self.members_count
                data["teams-count"] = self.teams_count
                data["subteams-count"] = self.subteams_count
                
                tempRef.updateChildValues(data)
                
                // upload to space
                let tempRef1 = WowRef.ref.childByAppendingPath("spaces/\(self.spaceID)")
                
                var data1 = [String: AnyObject]()
                data1["title"] = self.title
                data1["desc"] = self.desc
                data1["timestamp"] = kFirebaseServerValueTimestamp
                if self.emailDomainRestriction != nil {
                    data1["email-domain-restriction"] = self.emailDomainRestriction
                }
                
                tempRef1.updateChildValues(data1)
                
                for (key,value) in self.members {
                    let memType = value["membership-type"] as NSString
                    wowref.setSpaceMembers(self.spaceID, userID: key, membership_type: memType)
                    wowref.setUserMemberships(key, spaceID: self.spaceID, membership_type: memType)
                }
                
                callBack(errorDesc: nil)
            }
         
         })
        
    }
    
    init(spaceID: String, callBack: (space : SpaceMetaData) -> Void){
        
        // temp initialization
        self.spaceID = spaceID
        self.desc = ""
        self.title = ""

        // when spaces list is loaded then acquirng for desc for spaces
        let tempRef = WowRef.ref.childByAppendingPath("space-meta-data/\(spaceID)")
        
        tempRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot) -> Void in
            
            
            if snapshot.value["title"] != nil {
                self.title = snapshot.value["title"] as NSString
            }
            if snapshot.value["desc"] != nil {
                self.desc = snapshot.value["desc"] as NSString
            }
            if snapshot.value["members-count"] != nil {
                self.members_count = snapshot.value["members-count"] as NSNumber
            }
            if snapshot.value["teams-count"] != nil {
                self.teams_count = snapshot.value["teams-count"] as NSNumber
            }
            if snapshot.value["subteams-count"] != nil {
                self.subteams_count = snapshot.value["subteams-count"] as NSNumber
            }
            if snapshot.value["members-checked-in"] != nil {
                self.members_checked_in = snapshot.value["members-checked-in"] as [String : AnyObject]
            }
            
            
            
            callBack(space: self)

            
        })
        
    }
    
    
    
    
    func observer(callBack: (space : SpaceMetaData) -> Void ){
        
        if self.spaceID != "" {
            
            let tempRef = WowRef.ref.childByAppendingPath("space-meta-data/\(self.spaceID)")
            tempRef.observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
                
                if snapshot.value["title"] != nil {
                    self.title = snapshot.value["title"] as NSString
                }
                if snapshot.value["desc"] != nil {
                    self.desc = snapshot.value["desc"] as NSString
                }
                if snapshot.value["members-count"] != nil {
                    self.members_count = snapshot.value["members-count"] as NSNumber
                }
                if snapshot.value["teams-count"] != nil {
                    self.teams_count = snapshot.value["teams-count"] as NSNumber
                }
                if snapshot.value["subteams-count"] != nil {
                    self.subteams_count = snapshot.value["subteams-count"] as NSNumber
                }
                if snapshot.value["members-checked-in"] != nil {
                    self.members_checked_in = snapshot.value["members-checked-in"] as [String : AnyObject]
                }
                
                callBack(space: self)

                
            })
        }
    }
    
    
    
//    convenience init(ref: String, spaceID: String, desc: String, title: String, owner: String, members: [String :  AnyObject]){
//        self.init(spaceID: spaceID, desc: desc, title: title, owner: owner)
//        
//        self.members = members
//        
//    }
}



class WowRef {
    
    
    private var isLogin : Bool = false
    
    var isUserLogin: Bool {
        get{
            return isLogin
        }
    }
    
    private class var ref : Firebase {
        struct Static {
            static let tempRef : Firebase = Firebase(url: "https://panacloud1.firebaseio.com/")
        }
        return Static.tempRef
    }
    
    class var sharedInstance : WowRef {
        struct Static {
            static let instance : WowRef = WowRef()
        }
        return Static.instance
    }
    
    
    
    
    init() {
        // need to implement some code here
        WowRef.ref.observeAuthEventWithBlock { (authData) -> Void in
            // MARK: tokenExpired handler 
            //(redirect to login page)
            
        }
    }
    
    
    func asyncLoginUser(email: String, password: String, callBack: (error: String?, user: User?) -> Void){
        let url = "https://panacloudapi.herokuapp.com/api/signin"
        
        var userLocal : User!
        
        var request = NSMutableURLRequest(URL: NSURL(string: url))
        var session = NSURLSession.sharedSession()
        var err: NSError?
        
        request.HTTPMethod = "POST"
        
        var params = ["email": email, "password": password] as Dictionary
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            println("Response: \(response)")
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            println("Body: \(strData)\n\n")
            
            var err: NSError?
            
            // if response is not found nil
            if response != nil{
                
                var json : NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
                
                
                let statusCode = json["statusCode"] as? Int
                let statusDesc = json["statusDesc"] as? String
                
                let user : [String : String]! = json["user"] as? [String : String]
                
//                println(" Status Code: \(statusCode!) \n Status Desc: \(statusDesc!)")
//                for (key , value) in user!{
//                    println("\(key) : \(value)")
//                    
//                }
                
                if((err) != nil) {
                    
//                    println(err!.localizedDescription)
                    callBack(error: err!.localizedDescription, user: nil)
                    
                }
                // if user sussefuly get token or login to node js server
                if user != nil && statusCode == 1 {
                    if user["userID"] != nil && user["token"] != nil {
                        let userr =  user["userID"]
                        let token = user["token"]
                        
                        userLocal = User(ref: "", uID: user["userID"]!, email: user["email"]!, firstName: user["firstName"]!, lastName: user["lastName"]!, status: user["status"]!)
                        
                        println("mohsin: \(userr) \n \(token)")
                       
                        // conform from firebase userID have appropriate token
                        self.asyncLogin(user["userID"]!, token: user["token"]!, callBack: { (errorDesc) -> Void in
                            if errorDesc == nil {
                                callBack(error: nil, user: userLocal)
                            }
                            else{
                                callBack(error: errorDesc, user: nil)

                            }
                        })
                    }
                }
                
                // if any error occuerd by our node.js server 
                else if statusCode != 1 {
                    callBack(error: statusDesc, user: nil)

                }

            }
                
                // if response is not found nil
            else if response == nil {
                callBack(error: "respnse is nil", user: nil)
            }

            
        })
        
        task.resume()
    }
    
    // if successfuly login trn errorDesc will be nil
    // conform from firebase userID have appropriate token
    func asyncLogin(uID: String, token: String, callBack: (errorDesc : String?) -> Void ){
        
        // use wow app refrence here
        // use this ref b/c node.js server use this ref to create token and we verify this token against same ref
        let sirRef = Firebase(url: "https://luminous-torch-4640.firebaseio.com/")
        sirRef.authWithCustomToken(token , withCompletionBlock: { error, authData in
            
            // some error occured
            if error != nil {
                println("Login failed! \(error.localizedDescription)")
                self.isLogin = false
                
                callBack(errorDesc: error.localizedDescription)
            }
                
            else {
                // login successfully
                if authData.uid == uID {
                    println("Login succeeded! \(authData.uid)")
                    self.isLogin = true
                    
                    callBack(errorDesc: nil)
                    
                }
                // invalid uID provided, diff b/t provided uID and authData.uid
                else{
                    println("Login failed: invalid uID provided")
                    self.isLogin = false
                    
                    callBack(errorDesc: "Login failed: invalid uID provided")

                }

            }
        })
    }
    
    func asyncSpaceIsExist(spaceID: String, callBack: (isExist : Bool) -> Void ){
        
        WowRef.ref.childByAppendingPath("space-meta-data/\(spaceID)").observeSingleEventOfType(FEventType.Value, withBlock: { snapshot in
            if snapshot.value["desc"] != nil {
                callBack(isExist: true)
            }
            else{
                callBack(isExist: false)
            }
            
        })
        
    }
    
    func asynUserIsExist(uID: String, callBack: (isExist : Bool) -> Void ){
        
        WowRef.ref.childByAppendingPath("users/\(uID)").observeSingleEventOfType(FEventType.Value, withBlock: { snapshot in
            if !(snapshot.value is NSNull) {
                callBack(isExist: true)
            }
            else{
                callBack(isExist: false)
            }
            
        })
    }
  
    
    func asyncSignUpUser(user: User, password: String, callBack : (error: String?) -> Void){
        
        let url = "https://panacloudapi.herokuapp.com/api/signup"
        
        var userLocal : User!
        
        var request = NSMutableURLRequest(URL: NSURL(string: url))
        var session = NSURLSession.sharedSession()
        var err: NSError?
        
        request.HTTPMethod = "POST"
        
        var params = ["email": user.email, "firstName": user.firstName, "lastName": user.lastName, "password": password, "userID": user.uID] as Dictionary
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            println("Response: \(response)")
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            println("Body: \(strData)\n\n")
            
            var err: NSError?
            
            // if response is not found nil
            if response != nil{
                
                var json : NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
                
                
                let statusCode = json["statusCode"] as? Int
                let statusDesc = json["statusDesc"] as? String
                
                if((err) != nil) {
                    
                    //                    println(err!.localizedDescription)
                    callBack(error: err!.localizedDescription)
                    
                }
                // if user sussefuly signup to node js server
                if statusCode == 1 {
                    callBack(error: nil)
                    }
                    
                    // if any error occuerd by our node.js server
                else if statusCode != 1 {
                    callBack(error: statusDesc)
                }
            }
                
                // if response is not found nil
            else if response == nil {
                callBack(error: "respnse is nil")
            }
        })
        
        task.resume()
        
    }
    
    // retrive user's owner list and subcrober org list
    func asyncGetUsesOwnerMemberOrgsList(uID: String, callBack : (ownersList: [String: [String: String]]?, memberList: [String : Int]? ) -> Void) {
        
        let ownerRef = WowRef.ref.childByAppendingPath("users/\(uID)")
        
        ownerRef.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            if !(snapshot.value is NSNull) {
                callBack(ownersList: snapshot.value["owner"] as [String : [String : String]]?, memberList : snapshot.value["member"] as? [String : Int])
            }
            else{
                callBack(ownersList: nil, memberList: nil)
            }
            }, withCancelBlock: { error in
                println(error.description)
                callBack(ownersList: nil, memberList: nil)
        })
    }
    

    // retrive whole orgs by org's ids
    func asynGetOrgById(orgIdList: String, callBack: (orgList: [String: [NSObject : AnyObject] ]?, observerHandle : UInt?, orgRef: Firebase) -> Void){
        
        let orgRef = WowRef.ref.childByAppendingPath("orgs/\(orgIdList)")
        var tempOrgsList = [String: [NSObject : AnyObject] ]()
        var handel = UInt()
        
        handel = orgRef.observeEventType(.Value, withBlock: { snapshot in
                
                // if org exast against its org id
                if !(snapshot.value is NSNull) {
                    tempOrgsList[orgIdList] = snapshot.value as? [NSObject : AnyObject]
                  
                    callBack(orgList: tempOrgsList, observerHandle: handel, orgRef: orgRef)
                    
                }
                    // if no org exast against its org id
                else{

                        callBack(orgList: nil, observerHandle: nil, orgRef: orgRef)
                    }
                
            })
        
    }
    
    // provide space metadata against spaceid
     func asyncSpaceDesc(spaceIDs: [String],  callBack: (spaceDesc: [String : AnyObject]) -> Void ){
        
        var localSpacesDesc = [String : AnyObject]()
        var count = 0
        
        for spaceID in spaceIDs {
            let tempRef = WowRef.ref.childByAppendingPath("space-meta-data/\(spaceID)")
            
            tempRef.observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
                
                localSpacesDesc[snapshot.key] = snapshot.value
                println(snapshot.value)
                count++
                // when all org desc data arived
                if count >= spaceIDs.count {
                    callBack(spaceDesc: localSpacesDesc)
                }
            })
        }
    }
    
    
    func setUserMemberships(userID: String, spaceID: String, membership_type: String){
        let tempRef = WowRef.ref.childByAppendingPath("user-memberships/\(userID)")

        tempRef.updateChildValues([spaceID:["membership-type": membership_type,"timestamp" : kFirebaseServerValueTimestamp]])
    }
    
    func setSpaceMembers(spaceID: String, userID: String, membership_type: String){
        let tempRef = WowRef.ref.childByAppendingPath("space-members/\(spaceID)")
        
        tempRef.updateChildValues([userID:["membership-type": membership_type,"timestamp" : kFirebaseServerValueTimestamp]])
    }
    
    
    func updateActiviy(spaceID:String, verb:String, displayName: String, actor: [String: AnyObject], object: [String: AnyObject],target :[String : AnyObject]){
        let newActivityRef = WowRef.ref.childByAppendingPath("space-activity-streams/\(spaceID)").childByAutoId()
        
        var newActiviy = [String: AnyObject]()
        
        newActiviy["language"] = "en"
        newActiviy["verb"] = verb
        newActiviy["published"] = kFirebaseServerValueTimestamp
        newActiviy["displayName"] = verb
        newActiviy["actor"] = actor
        newActiviy["object"] = object
        newActiviy["target"] = target
        
        
        newActivityRef.updateChildValues(newActiviy)
        
        
    }
    
}


class AsyncObject{
    
    private var data = [String : AnyObject]()
    let ref : Firebase
    
    init(ref: Firebase, callBack : (data : [String : AnyObject]?, updateKey : String?) -> Void){
        self.ref = ref
        
        // use Value Event type
//        self.ref.observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
//            self.data = snapshot.value as [String : AnyObject]
//            callBack(data: self.data)
//        })
        
        // if child added
        self.ref.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) -> Void in
            if !(snapshot.value is NSNull) {
            self.data[snapshot.key] = snapshot.value as AnyObject
            callBack(data: self.data, updateKey: snapshot.key)
            }
            else {
                callBack(data: nil, updateKey: nil)
            }
        })
        
        // if child value changed
        self.ref.observeEventType(FEventType.ChildChanged, withBlock: { (snapshot) -> Void in
            if !(snapshot.value is NSNull) {
            self.data[snapshot.key] = snapshot.value as AnyObject
            callBack(data: self.data, updateKey: snapshot.key)
            }
            else {
                callBack(data: nil, updateKey: nil)
            }
        })
        
        // if child deleted
        self.ref.observeEventType(FEventType.ChildRemoved, withBlock: { (snapshot) -> Void in
            if !(snapshot.value is NSNull) {
            self.data.removeValueForKey(snapshot.key)
            callBack(data: self.data, updateKey: snapshot.key)
            }
            else {
                callBack(data: nil, updateKey: nil)
            }
        })
    }
    
}




class AsyncArray {
    
    private var data = [String : AnyObject]()
    unowned let ref : Firebase
    
    init(ref: Firebase, callBack : (dataArray : [AnyObject]?) -> Void){
        self.ref = ref
        
        // use Value Event type
        //        self.ref.observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
        //            self.data = snapshot.value as [String : AnyObject]
        //            callBack(data: self.data)
        //        })
        
        // if child added
        self.ref.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) -> Void in
            
            if !(snapshot.value is NSNull) {
                self.data[snapshot.key] = snapshot.value as AnyObject
                callBack(dataArray: self.data.values.array)
            }
            else {
                callBack(dataArray: nil)
            }

        })
        
        // if child value changed
        self.ref.observeEventType(FEventType.ChildChanged, withBlock: { (snapshot) -> Void in
        if !(snapshot.value is NSNull) {
            self.data[snapshot.key] = snapshot.value as AnyObject
            callBack(dataArray: self.data.values.array)
            }
        else {
            callBack(dataArray: nil)
            }
        })
        
        
        // if child deleted
        self.ref.observeEventType(FEventType.ChildRemoved, withBlock: { (snapshot) -> Void in
        if !(snapshot.value is NSNull) {
            self.data.removeValueForKey(snapshot.key)
            callBack(dataArray: self.data.values.array)
            
            }
        else {
            callBack(dataArray: nil)
            }
        })
    }
    
    
    

    
    

    
    
}

