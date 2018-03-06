//
//  Date.swift
//  expenses
//
//  Created by Nour  on 8/3/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func getNextMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }
    
    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    
    
    func isSameDayOfYear(to date: Date) -> Bool {
        let calendar = Calendar.current
        var dateComponents1 = calendar.dateComponents([.day, .month, .year], from: self)
        var dateComponents2 = calendar.dateComponents([.day, .month, .year], from: date)
        guard let year1 = dateComponents1.year, let year2 = dateComponents2.year,
            let month1 = dateComponents1.month, let month2 = dateComponents2.month,
            let day1 = dateComponents1.day, let day2 = dateComponents2.day else {
                return false
        }
        return year1 == year2 && month1 == month2 && day1 == day2
    }
    
    func isSameMonthOfYear(to date: Date) -> Bool {
        let calendar = Calendar.current
        var dateComponents1 = calendar.dateComponents([.day, .month, .year], from: self)
        var dateComponents2 = calendar.dateComponents([.day, .month, .year], from: date)
        guard let year1 = dateComponents1.year, let year2 = dateComponents2.year,
            let month1 = dateComponents1.month, let month2 = dateComponents2.month else {
                return false
        }
        return year1 == year2 && month1 == month2
    }
    
    var tomorrow: Date? {
        var dateComponents = DateComponents()
        dateComponents.day = 1
        return Calendar.current.date(byAdding: dateComponents, to: self)
    }
    
    var firstDayOfMonth: Date? {
        return dayOfMonth(with: 1)
    }
    
    func dayOfMonth(with day: Int) -> Date? {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.day, .month, .year], from: self)
        dateComponents.day = day
        return calendar.date(from: dateComponents)
    }

}
