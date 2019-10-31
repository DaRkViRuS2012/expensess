//
//  Actions.swift
//  Rombeye
//
//  Created by Dania on 7/5/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import Foundation
import UIKit
/**
Repeated and generic actions to be excuted from any context of the app such as show alert
 */
class Action: NSObject {
    class func execute() {
    }
}



class ActionShowStart: Action {
    override class func execute() {
        UIApplication.appWindow().rootViewController = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: StartViewController.className)
    }
}

class ActionShowChat: Action {
    override class func execute() {
        /*let chatViewController = UIStoryboard.chatStoryboard.instantiateViewController(withIdentifier: ChatViewController.className)
        UIApplication.pushOrPresentViewController(viewController: chatViewController, animated: true)*/
        let chatNavigationController = UIStoryboard.chatStoryboard.instantiateViewController(withIdentifier: "ChatNavigationController")
        chatNavigationController.modalTransitionStyle = .crossDissolve
        UIApplication.visibleViewController()?.present(chatNavigationController, animated: true, completion: nil)
    }
}

class ActionShowProfile: Action {
    override class func execute() {
        /*let profileViewController = UIStoryboard.profileStoryboard.instantiateViewController(withIdentifier: ProfileViewController.className)
        UIApplication.pushOrPresentViewController(viewController: profileViewController, animated: true)*/
        let profileNavigationController = UIStoryboard.profileStoryboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        profileNavigationController.modalTransitionStyle = .crossDissolve
        UIApplication.visibleViewController()?.present(profileNavigationController, animated: true, completion: nil)
    }
}


class ActionShowFriendsFeed: Action {
    override class func execute() {
        /*let friendsFeedViewController = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: FriendsFeedViewController.className)
        UIApplication.pushOrPresentViewController(viewController: friendsFeedViewController, animated: true)*/
        let friendsFeedNavigationController = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "FriendsFeedNavigationController")
        friendsFeedNavigationController.modalTransitionStyle = .crossDissolve
        UIApplication.visibleViewController()?.present(friendsFeedNavigationController, animated: true, completion: { 
            NotificationCenter.default.post(name: .notificationFilterClosed, object: nil)
        })
    }
}

class ActionShowSearch: Action {
    override class func execute() {
        /*let searchViewController = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: SearchViewController.className)
        UIApplication.pushOrPresentViewController(viewController: searchViewController, animated: true)*/
        let searchNavigationController = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SearchNavigationController")
        searchNavigationController.modalTransitionStyle = .crossDissolve
        UIApplication.visibleViewController()?.present(searchNavigationController, animated: true, completion: {
            NotificationCenter.default.post(name: .notificationFilterClosed, object: nil)
        })
    }
}
