//
//  UIViewController.swift
//  expenses
//
//  Created by Nour  on 8/18/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{


    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.endEdit))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    
    func addKeyboardobserver(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    func keyboardHidden(){
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    
    
    func keyboardShown(notification:NSNotification){
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        view.frame = CGRect(x: 0, y: -(keyboardHeight / 3), width: view.frame.width, height: view.frame.height)
        
    }
    
    func endEdit() {
        view.endEditing(true)
    }


}



extension UIViewController{
    
    func findContentViewControllerRecursively() -> UIViewController? {
        var childViewController: UIViewController?
        if let tabBarController:UITabBarController = self as? UITabBarController{
            childViewController = tabBarController.selectedViewController
        } else if let navigationContoller :UINavigationController = self as? UINavigationController {
            childViewController = navigationContoller.topViewController
        } else if let splitViewController:UISplitViewController = self as? UISplitViewController {
            childViewController = splitViewController.viewControllers.last
        } else if self.presentedViewController != nil {
            childViewController = self.presentedViewController
        }
        // FIXME: UIAlertController is a kludge and should be removed
        let shouldContinueSearch: Bool  = (childViewController != nil) && !childViewController!.isKind(of: UIAlertController.self)
        return shouldContinueSearch ? childViewController?.findContentViewControllerRecursively() : self
    }
    
    func isPresentedModally() -> Bool {
        return self.presentingViewController?.presentedViewController == self
    }
    
    func popOrDismissViewControllerAnimated(animated: Bool){
        if (self.isPresentedModally()) {
            self.dismiss(animated: animated, completion: nil)
        } else if (self.navigationController != nil) {
            self.navigationController?.popViewController(animated: animated)
        }
    }
}
