//
//  UIStoryboard.swift
//  E-MALL
//
//  Created by Nour  on 4/2/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

extension UIStoryboard {
    class func viewController(identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}
