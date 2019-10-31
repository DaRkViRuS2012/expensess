//
//  CalendarView.swift
//  expenses
//
//  Created by Nour  on 11/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import FSCalendar

protocol CalendarViewDelegate {
    func changeDate(date:Date)
}

struct Colors {
    static let selectedText = UIColor.white
    static let text = UIColor.black
    static let textDisabled = UIColor.gray
    static let selectionBackground = UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1.0)
    static let sundayText = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
    static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
    static let sundaySelectionBackground = sundayText
}


class CalendarView: UIView ,FSCalendarDataSource, FSCalendarDelegate{

     var calendar: FSCalendar!
    var delegate:CalendarViewDelegate?
    override init(frame: CGRect) {
        // CVCalendarMenuView initialization with frame
        super.init(frame: frame)
        
        let calendar = FSCalendar(frame:frame)
        calendar.dataSource = self
        calendar.delegate = self
        self.addSubview(calendar)
        self.calendar = calendar
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        calendar.delegate = self
        calendar.dataSource = self
       
    }
    
    
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale =   Locale(identifier: "en_US")//   NSLocale(localeIdentifier: "en_US") as Locale!
        return formatter
    }()
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        self.calendarHeightConstraint.constant = bounds.height
//        self.view.layoutIfNeeded()
//    }
//    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        delegate?.changeDate(date: date)
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    

    
 

}
