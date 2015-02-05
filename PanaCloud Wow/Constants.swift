//
//  Constants.swift
//  AttendanceSystem
//
//  Created by Mohsin on 02/01/2015.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//
//lite green =>rgb(220, 237, 200)
//blue => rgb(3, 169, 244)


import UIKit


var wowref = WowRef()


// firebase time
let kFirebaseServerValueTimestamp = [".sv":"timestamp"]

func fTimeStampToNSDate(timeIndervalInMSec : Double?) -> NSDate {
    
    if timeIndervalInMSec != nil {
        let timeInSeconds = timeIndervalInMSec! / 1000.0
        
        return NSDate(timeIntervalSince1970:timeInSeconds)
    }
    else {
        return  NSDate()
    }
}

let spaceLogoImg = UIImage(named: "org")
let spaceCoverImg = UIImage(named: "org")
let imgNotification = UIImage(named: "notification")


var loginUser : User?

var backgroundImage : UIImage = UIImage(named: "Background1") {
    didSet{
    backgroundImageView = UIImageView(image: backgroundImage)
    }
}
var backgroundImageView = UIImageView(image: backgroundImage)

var currentTheme = "Background2"

var shadowColor = UIColor.blackColor().CGColor

var fontColor: UIColor = UIColor.blackColor()
var colorLGreen = UIColor(red: 0.86274509, green: 0.92941176, blue: 0.7831372, alpha: 1.0)
var colorLBlue = UIColor(red: 0.01176470, green: 0.6627450, blue: 0.9568274, alpha: 1.0)

var imgLogo = UIImageView(image: UIImage(named: "WowLogo"))
var imgBarLogo = UIImageView(image: UIImage(named: "WowBarLogo"))


class WowUIViewController: UIViewController {
    var delegate: CenterViewControllerDelegate?

}

extension String  {
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
            let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            let digestLen = Int(CC_MD5_DIGEST_LENGTH)
            let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
            
            CC_MD5(str!, strLen, result)
            
            var hash = NSMutableString()
            for i in 0..<digestLen {
                hash.appendFormat("%02x", result[i])
            }
            
            result.dealloc(digestLen)
            
            return String(format: hash)
    }
}

