//
//  Constants.swift
//  Rombeye
//
//  Created by Dania on 12/25/16.
//  Copyright © 2016 . All rights reserved.
//
import UIKit


// MARK: Application configuration
struct AppConfig {
    // domain
    static let appBaseDevURL = "https://rombeye.falcon9.io/dev/"
    static let appBaseLiveURL = "https://rombeye.falcon9.io/dev/"
    static let useLiveAPI: Bool = false
    static let useCurrentLocation: Bool = true
    // social
    static let instagramClienID = "a33bd13f810c4df7ae344437c21fc926"
    static let instagramRedirectURI = "http://alpha-apps.ae"
    static let twitterConsumerKey = "eq0dVMoM1JqNcR6VJJILsdXNo"
    static let twitterConsumerSecret = "6JkdvzSijm13xjBW0fYSEG4yF2tbro8pwxz1vDx290Bj0Mw2vI"
    // validation
    static let passwordLength = 6
    // current application language
    static var currentLanguage:AppLanguage {
        let locale = NSLocale.current.languageCode
        if (locale == "ar") {
            return .arabic
        }
        return .english
    }
    /// Set navigation bar style, text and color
    static func setNavigationStyle() {
        // set text title attributes
        let attrs = [NSAttributedStringKey.foregroundColor : AppColors.grayXDark,
                     NSAttributedStringKey.font : AppFonts.xBig]
        UINavigationBar.appearance().titleTextAttributes = attrs
        // set background color
        UINavigationBar.appearance().barTintColor = AppColors.grayXLight
    }
}


// MARK: Notifications
extension Notification.Name {
    static let notificationLocationChanged = Notification.Name("NotificationLocationChanged")
    static let notificationUserChanged = Notification.Name("NotificationUserChanged")
    static let notificationFilterOpened = Notification.Name("NotificationFilterOpened")
    static let notificationFilterClosed = Notification.Name("NotificationFilterClosed")
    static let notificationRefreshStories = Notification.Name("NotificationRefreshStories")
}

// MARK: Screen size
enum ScreenSize {
    static let isSmallScreen =  UIScreen.main.bounds.height <= 568 // iphone 4/5
    static let isMidScreen =  UIScreen.main.bounds.height <= 667 // iPhone 6 & 7
    static let isBigScreen =  UIScreen.main.bounds.height >= 736 // iphone 6Plus/7Plus
    static let isIphone = UIDevice.current.userInterfaceIdiom == .phone
}

// MARK: Application language
enum AppLanguage{
    case english
    case arabic
    
    var langCode:String {
        switch self {
        case .english:
            return "en"
        case .arabic:
            return "ar"
        }
    }
}
