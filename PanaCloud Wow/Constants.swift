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
