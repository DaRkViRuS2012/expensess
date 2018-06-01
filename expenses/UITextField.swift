//
//  UITextField.swift
//  Rombeye
//
//  Created by Molham Mahmoud on 6/20/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func appStyle() {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let padding = CGFloat(16.0)
        let border = CALayer()
        let height = CGFloat(1.0)
        border.borderColor = AppColors.grayXDark.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - height, width:  screenWidth - 2 * padding, height: height)
        border.borderWidth = height
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.clear
        self.font = AppFonts.xSmall
        self.textAlignment = .left
        if (AppConfig.currentLanguage == .arabic) {
            self.textAlignment = .right
        }
    }

    func appStyle(padding: Int) {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let border = CALayer()
        let height = CGFloat(1.0)
        border.borderColor = AppColors.grayXDark.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - height, width:  screenWidth - 2 * CGFloat(padding), height: height)
        border.borderWidth = height
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.clear
        self.font = AppFonts.xSmall
        self.textAlignment = .left
        if (AppConfig.currentLanguage == .arabic) {
            self.textAlignment = .right
        }
    }
}


extension UITextField: UITextFieldDelegate{
    
    func addToolBar(){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        
        let doneButton = UIBarButtonItem(image: #imageLiteral(resourceName: "down_arrow"), style: .done, target: self, action: #selector(UITextField.cancelPressed))
        //let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UITextField.cancelPressed))
        // let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        self.delegate = self
        self.inputAccessoryView = toolBar
    }
    func donePressed(){
        self.superview?.endEditing(true)
    }
    func cancelPressed(){
        self.superview?.endEditing(true)
    }
    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        addToolBar()
    }
}
