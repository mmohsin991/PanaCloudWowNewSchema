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
    var members: [String : Int]?
    var owner: [String: [String: String]]?
    
    
    
    init(ref: String, uID: String, email: String, firstName: String, lastName: String, status: String){
        self.ref = ref
        self.uID = uID
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.status = status
        
        
       // self.asyncSetOwnerMemberList { () -> Void in }
        
    }
    
    convenience init(ref: String, uID: String, email: String, firstName: String, lastName: String, status: String, members: [String : Int], owner: [String: [String: String]]){

        self.init(ref: ref, uID: uID, email: email, firstName: firstName, lastName: lastName, status: status)
        
        self.members = members
        self.owner = owner
    }
    
    // retrive user's owner list and subcrober org list its a async method
    func asyncSetOwnerMemberList(callBack : () -> Void){
        
        let ownerRef = WowRef.ref.childByAppendingPath("users/\(self.uID)")
        
        ownerRef.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            if !(snapshot.value is NSNull) {
                self.owner = snapshot.value["owner"] as? [String : [String : String]]
                self.members = snapshot.value["member"] as? [String : Int]
                callBack()
            }
            
            else {
                callBack()
            }
        })
    }
    
    
    // retrive whole suborgs by org's ids
    func asynGetSubscriberOrgs(callBack: (orgList: [String: [NSObject : AnyObject] ]?) -> Void){
        let orgsRef = WowRef.ref.childByAppendingPath("orgs")
        var tempOrgsList = [String: [NSObject : AnyObject] ]()
        
        var countReturn = 0
        
            self.asyncSetOwnerMemberList({ () -> Void in
                
                // if no subscriber orgs user have
                if self.members == nil {
                    callBack(orgList: nil)
                    return
                }
                
                // loop to all orgs
                for x in 0..<self.members!.keys.array.count {
                    orgsRef.childByAppendingPath(self.members!.keys.array[x]).observeSingleEventOfType(.Value, withBlock: { snapshot in
                        
                        // if org exast against its org id
                        if !(snapshot.value is NSNull) {
                            tempOrgsList[self.members!.keys.array[x]] = snapshot.value as? [NSObject : AnyObject]
                            
                            countReturn++
                            // when all orgs return then callback
                            if countReturn == self.members!.keys.array.count {
                                callBack(orgList: tempOrgsList)
                                countReturn = 0
                                return
                            }
                            
                        }
                            // if org is not exast against its org id
                        else{
                            countReturn++
                            // when all orgs return then callback
                            if countReturn == self.members!.keys.array.count {
                                callBack(orgList: tempOrgsList)
                                countReturn = 0
                                return
                            }
                        }
                    })
                    
                }
                
            })
            
    }

    // retrive whole orgs by org's ids
    func asynGetOwnerOrgs(callBack: (orgList: [String: [NSObject : AnyObject] ]?) -> Void){
        let orgsRef = WowRef.ref.childByAppendingPath("orgs")
        var tempOrgsList = [String: [NSObject : AnyObject] ]()
        
        var countReturn = 0
        
            self.asyncSetOwnerMemberList({ () -> Void in
                
                // if no owner orgs user have
                if self.owner == nil {
                    callBack(orgList: nil)
                    return
                }
                
                // loop to all orgs
                for x in 0..<self.owner!.keys.array.count {
                    orgsRef.childByAppendingPath(self.owner!.keys.array[x]).observeSingleEventOfType(.Value, withBlock: { snapshot in
                        
                        // if org exast against its org id
                        if !(snapshot.value is NSNull) {
                            tempOrgsList[self.owner!.keys.array[x]] = snapshot.value as? [NSObject : AnyObject]
                            
                            countReturn++
                            // when all orgs return then callback
                            if countReturn == self.owner!.keys.array.count {
                                callBack(orgList: tempOrgsList)
                                countReturn = 0
                                return
                            }
                            
                        }
                            // if org is not exast against its org id
                        else{
                            countReturn++
                            // when all orgs return then callback
                            if countReturn == self.owner!.keys.array.count {
                                callBack(orgList: tempOrgsList)
                                countReturn = 0
                                return
                            }
                        }
                    })
                    
                }
                
            })
            
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

class Org {
    var ref: String
    var orgID: String
    var desc: String
    var title: String
    var owner: String // user uID
    var members: [String : [String: AnyObject]]? // user uID, and member 
    
    
    init(ref: String, orgID: String, desc: String, title: String, owner: String ){
        self.orgID = orgID
        self.desc = desc
        self.title = title
        self.ref = ref
        self.owner = owner
        
    }
    
    convenience init(ref: String, orgID: String, desc: String, title: String, owner: String, members: [String : [String: AnyObject]]){
        self.init(ref: ref, orgID: orgID, desc: desc, title: title, owner: owner)
        
        self.members = members
        
    }
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
            static let tempRef : Firebase = Firebase(url: "https://sweltering-inferno-1689.firebaseio.com/")
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
    
    func asyncOrgIsExist(orgID: String, callBack: (isExist : Bool) -> Void ){
        
        WowRef.ref.childByAppendingPath("orgs/\(orgID)").observeSingleEventOfType(FEventType.Value, withBlock: { snapshot in
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
            if snapshot.value["email"] != nil {
                callBack(isExist: true)
            }
            else{
                callBack(isExist: false)
            }
            
        })
    }
    
    func asyncCreateOrganization(org: Team, callBack: (errorDesc : String?, unRegMembersUIDs: [String]?) -> Void ){
        
        var storeUnRegMembersUIDs: [String]!
        
        var tempsnap = FDataSnapshot()
        
        asyncOrgIsExist(org.orgID, callBack: { (isExist) -> Void in
            // 1 - check if already exist
            if isExist {
               callBack(errorDesc: "org is already exist, plz try with diff orginization ID", unRegMembersUIDs: nil)
            }
            
            else{
                // 2 - add org to the user org's list
                if org.members?.keys.array != nil {
                    let members = org.members!.keys.array
                    
                    var countCallbackIteration = 0
                    // retrive eache member of the org
                    for x in 0..<members.count{
                        WowRef.ref.childByAppendingPath("users/\(members[x])").observeSingleEventOfType(FEventType.Value, withBlock: { snapshot in
                            // user exist
                            if snapshot.value["email"] != nil {
                                let memberType = org.members![members[x]]
                                let addMember : [String : [String : Int]] = ["member": [ org.orgID : memberType!] ]
                                snapshot.ref.updateChildValues(addMember)
                                
                                countCallbackIteration++
                            }
                            // user not exist
                            else{
                                if storeUnRegMembersUIDs == nil {
                                  storeUnRegMembersUIDs = [String]()
                                }
                                storeUnRegMembersUIDs.append(members[x])
                                println(members[x])
                                countCallbackIteration++
                            }
                            
                            // callback when all members are check whether they exist or not
                            if countCallbackIteration == members.count{
                                // MARK: retun callBack Func
                                callBack(errorDesc: nil, unRegMembersUIDs: storeUnRegMembersUIDs)

                            }
                        })
                    }
                    
                }
                
                
                // 3 - add org to user application org list
                
                if let orgMembers = org.members {
                    
                    let insertedData = [org.orgID : [
                        "desc" : org.desc,
                        "owner" : org.owner,
                        "title" : org.title,
                        // 4 - add members in orgs member list
                        "members" : orgMembers
                    ]]
                    WowRef.ref.childByAppendingPath("orgs").updateChildValues(insertedData)
                }
                else{
                    let insertedData = [org.orgID : [
                        "desc" : org.desc,
                        "owner" : org.owner,
                        "title" : org.title,
                        // 4 - no members in orgs member list

                    ]]
                    WowRef.ref.childByAppendingPath("orgs").updateChildValues(insertedData)
                }
            }
            
            // 5 - add org in members's owner list
            let orgDetail = [org.orgID : [
            "desc" : org.desc,
            "title" : org.title
                ]
            ]
            WowRef.ref.childByAppendingPath("users/\(org.owner)/owner").updateChildValues(orgDetail)
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
    
}


// MARK: New Model

class AsyncObject{
    
    private var data = [String : AnyObject]()
    let ref : Firebase
    
    init(ref: Firebase, callBack : (data : [String : AnyObject]) -> Void){
        self.ref = ref
        
        self.ref.observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
            self.data = snapshot.value as [String : AnyObject]
            callBack(data: self.data)
        })
        
    }
    
    
}



