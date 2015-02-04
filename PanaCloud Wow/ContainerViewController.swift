//
//  ContainerViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
  case BothCollapsed
  case LeftPanelExpanded
  case RightPanelExpanded
}

class ContainerViewController: UIViewController, CenterViewControllerDelegate, SidePanelViewControllerDelegate, LogoutDelegate, UIGestureRecognizerDelegate {
  var centerNavigationController: UINavigationController!
  var centerViewController: WowUIViewController?

    // represent the current state of secondary view
  var currentState: SlideOutState = .BothCollapsed {
    didSet {
      let shouldShowShadow = currentState != .BothCollapsed
      showShadowForCenterViewController(shouldShowShadow)
    }
  }

  var leftViewController: SidePanelViewController?
  var rightViewController: SidePanelViewController?

  let centerPanelExpandedOffset: CGFloat = 60
    
    
    
    // delegate function that call when ever row selected in side panel VC
    func VClSelected(#VC: WowUIViewController) {
        
        self.centerNavigationController.viewControllers[0] = VC
        
        // move to root VC if its not already at root VC
        self.centerNavigationController.popToRootViewControllerAnimated(true)
        
        self.centerViewController = VC
        
        centerViewController?.delegate = self

        self.collapseSidePanels()
        
        
    }

  override func viewDidLoad() {
    super.viewDidLoad()

    if centerViewController == nil {
        centerViewController = UIStoryboard.homeVC()
 
    }

    centerViewController?.delegate = self
    

    // wrap the centerViewController in a navigation controller, so we can push views to it
    // and display bar button items in the navigation bar
    centerNavigationController = UINavigationController(rootViewController: centerViewController!)
    view.addSubview(centerNavigationController.view)
    addChildViewController(centerNavigationController)

    centerNavigationController.didMoveToParentViewController(self)

    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
    centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    
  }

  // MARK: CenterViewController delegate methods

//  func toggleLeftPanel() {
//    let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
//
//    if notAlreadyExpanded {
//      addLeftPanelViewController()
//    }
//
//    animateLeftPanel(shouldExpand: notAlreadyExpanded)
//  }

  func toggleRightPanel() {
    let notAlreadyExpanded = (currentState != .RightPanelExpanded)

    if notAlreadyExpanded {
      addRightPanelViewController()
    }

    animateRightPanel(shouldExpand: notAlreadyExpanded)
  }

    func collapseSidePanels() {
        
 //   self.centerViewController = VC
        
    switch (currentState) {
    case .RightPanelExpanded:
      toggleRightPanel()
 //   case .LeftPanelExpanded:
        //  toggleLeftPanel()
    default:
      break
    }
  }

//  func addLeftPanelViewController() {
//    if (leftViewController == nil) {
//      leftViewController = UIStoryboard.leftViewController()
//      leftViewController!.animals = Animal.allCats()
//
//      addChildSidePanelController(leftViewController!)
//    }
//  }

  func addRightPanelViewController() {
    if (rightViewController == nil) {
      rightViewController = UIStoryboard.rightViewController()

        rightViewController?.delegate = self
        rightViewController?.logoutDelegate = self
        
      addChildSidePanelController(rightViewController!)
    }
  }

  func addChildSidePanelController(sidePanelController: SidePanelViewController) {
 //   sidePanelController.delegate = centerViewController

    view.insertSubview(sidePanelController.view, atIndex: 0)

    addChildViewController(sidePanelController)
    sidePanelController.didMoveToParentViewController(self)
  }

  func animateLeftPanel(#shouldExpand: Bool) {
    if (shouldExpand) {
      currentState = .LeftPanelExpanded

     // animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
        animateCenterPanelXPosition(targetPosition: 260, completion: nil)

    } else {
      animateCenterPanelXPosition(targetPosition: 0) { finished in
        self.currentState = .BothCollapsed

        self.leftViewController!.view.removeFromSuperview()
        self.leftViewController = nil;
      }
    }
  }

  func animateRightPanel(#shouldExpand: Bool) {
    if (shouldExpand) {
      currentState = .RightPanelExpanded

   //   animateCenterPanelXPosition(targetPosition: -CGRectGetWidth(centerNavigationController.view.frame) + centerPanelExpandedOffset)
        animateCenterPanelXPosition(targetPosition: -260, completion: nil)

    } else {
      animateCenterPanelXPosition(targetPosition: 0) { _ in
        self.currentState = .BothCollapsed
        
        self.rightViewController!.view.removeFromSuperview()
        self.rightViewController = nil;
      }
    }
  }

  func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
    
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
        // set the distance of right VC from X-Axis
        let centerCVWidth = self.centerNavigationController.view.frame.width
        if self.rightViewController != nil {
            self.rightViewController?.view.frame.origin.x = targetPosition + centerCVWidth
        }
        self.centerNavigationController.view.frame.origin.x = targetPosition

      }, completion: completion)
  }

  func showShadowForCenterViewController(shouldShowShadow: Bool) {
    if (shouldShowShadow) {
        centerNavigationController.view.layer.shadowColor = shadowColor
        centerNavigationController.view.layer.shadowOpacity = 0.8
//        centerNavigationController.view.layer.shadowOffset = CGSize(width: 3, height: 0)
//        centerNavigationController.view.layer.shadowRadius = 10.0
        
    } else {
      centerNavigationController.view.layer.shadowOpacity = 0.0
    }
  }

  // MARK: Gesture recognizer

  func handlePanGesture(recognizer: UIPanGestureRecognizer) {
    // we can determine whether the user is revealing the left or right
    // panel by looking at the velocity of the gesture
    let gestureIsDraggingFromRighttoLeft = (recognizer.velocityInView(view).x < 0)

    switch(recognizer.state) {
    case .Began:
      if (currentState == .BothCollapsed) {
        // If the user starts panning, and neither panel is visible
        // then show the correct panel based on the pan direction

        if (gestureIsDraggingFromRighttoLeft) {
            addRightPanelViewController()
        }
        else {
//          addLeftPanelViewController()

        }

        showShadowForCenterViewController(true)
      }
    case .Changed:
      // If the user is already panning, translate the center view controller's
      // view by the amount that the user has panned
        
        if gestureIsDraggingFromRighttoLeft {
            if (currentState == .BothCollapsed) {
                recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
                recognizer.setTranslation(CGPointZero, inView: view)
            }

        }
        // if right menu collapsed
        else if self.centerNavigationController.view.frame.origin.x < 0.0 {
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
            recognizer.setTranslation(CGPointZero, inView: view)
        }

    case .Ended:
      // When the pan ends, check whether the left or right view controller is visible
      if (leftViewController != nil) {
        // animate the side panel open or closed based on whether the view has moved more or less than halfway
        let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
        animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
      }
      else if (rightViewController != nil) {
        let hasMovedGreaterThanHalfway = recognizer.view!.center.x < 0
        animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
      }
    default:
      break
    }
  }
    
    
    func Logout() {
////         self.dismissViewControllerAnimated(true, completion: nil)
//  
//        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        let window = appDel.window?
//        
//        //let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("loginVCID") as LoginVC
//        
//        //let loginVC = LoginVC()
//        
//        window!.rootViewController = UIStoryboard.loginVC()
//        window!.makeKeyAndVisible()
        
        
    }
}
