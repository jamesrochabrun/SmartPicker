//
//  Date-Extensions.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation

extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
    
    var startOfMonth: Date? {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))
    }
    
    var endOfMonth: Date? {
        guard let startOfMonth = self.startOfMonth else { return nil }
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)
    }
    
    var startOfYear: Date? {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self)))
    }
    
    var endOfYear: Date? {
        guard let startOfMonth = self.startOfMonth else { return nil }
        return Calendar.current.date(byAdding: DateComponents(year: 1, month: -1, hour: -8, second: -1), to: startOfMonth)
    }
    
    func getCurrentYear() -> Int {
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        //Now asking the calendar what year are we in today’s date:
        let currentYearInt = (calendar?.component(NSCalendar.Unit.year, from: Date())) ?? 1
        return currentYearInt
    }
    
    func getCurrentMonth() -> Int {
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        //Now asking the calendar what month are we in today’s date:
        let currentMonthInt = (calendar?.component(NSCalendar.Unit.month, from: Date())) ?? 1
        return currentMonthInt
    }
    
    static func from(year: Int, month: Int, day: Int) -> Date? {
        
        guard let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian) else {
            return nil
        }
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return gregorianCalendar.date(from: dateComponents)
    }
    
    static func parse(_ string: String, format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
    
    ///use this to get a range from two dates, helper for holidays or special days
    func getRangeForDates(startDate: Date, endDate: Date, yearsAgo: Int) -> [Date] {
        var components = DateComponents()
        components.year = -yearsAgo
        guard let sD = Calendar.current.date(byAdding: components, to: startDate) else {
            return []
        }
        guard let eD = Calendar.current.date(byAdding: components, to: endDate) else {
            return []
        }
        return [sD, eD]
    }
    
    // MARK: - Period functions
    func getLargeDateRange() -> [Date] {
        let beginTime = Date.distantPast
        let endTime = Date()
        return [beginTime, endTime]
    }
    
    func getThisDay(yearsAgo: Int) -> [Date] {
        let currentDate = Calendar.current.startOfDay(for: Date())
        
        let beginTime : Date = {
            var components = DateComponents()
            components.year = -yearsAgo
            return Calendar.current.date(byAdding: components, to: currentDate)!
        }()
        
        let endTime : Date = {
            var components = DateComponents()
            components.day = 1
            components.second = -1
            components.year = -yearsAgo
            return Calendar.current.date(byAdding: components, to: currentDate)!
        }()
        
        return [beginTime,endTime]
    }
    
    func getThisWeek(yearsAgo: Int) -> [Date] {
        var currentDate = Calendar.current.startOfDay(for: Date())
        
        let beginTime : Date = {
            var components = DateComponents()
            components.year = -yearsAgo
            currentDate = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
            return Calendar.current.date(byAdding: components, to: currentDate)!
        }()
        
        let endTime : Date = {
            var components = DateComponents()
            components.day = 7
            components.second = -1
            return Calendar.current.date(byAdding: components, to: beginTime)!
        }()
        
        return [beginTime,endTime]
    }
    
    func getThisMonth(yearsAgo: Int) -> [Date] {
        var currentDate = Calendar.current.startOfDay(for: Date())
        let beginTime : Date = {
            var components = DateComponents()
            components.year = -yearsAgo
            currentDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!
            return Calendar.current.date(byAdding: components, to: currentDate)!
        }()
        let endTime : Date = {
            var components = DateComponents()
            components.month = 1
            components.day = -1
            components.second = -1
            return Calendar.current.date(byAdding: components, to: beginTime)!
        }()
        return [beginTime,endTime]
    }
    
    func getRangeForFullYear(yearsAgo: Int) -> [Date] {
        
        var components = DateComponents()
        components.year = -yearsAgo
        guard let startDate = Calendar.current.date(byAdding: components, to: Date().startOfYear!) else {
            return []
        }
        guard let endOfYear = Date().endOfYear,
            let endDate = Calendar.current.date(byAdding: components, to: endOfYear) else {
                return []
        }
        return [startDate, endDate]
    }
    
    func getLastWeekend() -> [Date] {
        let today = Date()
        var components = DateComponents()
        components.day = -9
        guard let startingDate = Calendar.current.date(byAdding: components,  to: today) else { return [] }
        if #available(iOS 10.0, *) {
            if let weekendInterval = Calendar.current.nextWeekend(startingAfter: startingDate, direction: .forward) {
                var components = DateComponents()
                components.day = -1
                guard let startDate = Calendar.current.date(byAdding: components, to: weekendInterval.start) else {
                    return []
                }
                debugPrint("kmdate startDate: \(startDate), endDate: \(weekendInterval.end)")
                return [startDate, weekendInterval.end]
            } else { return [] }
        } else {
            return []
        }
    }
    
    func getValentines(yearsAgo: Int) -> [Date] {
        
        let userCalendar = Calendar.current
        var startDateComponents = DateComponents()
        startDateComponents.year = Date().getCurrentYear()
        startDateComponents.month = 2
        startDateComponents.day = 14
        startDateComponents.hour = 00
        startDateComponents.timeZone = TimeZone(abbreviation: "PST")
        guard let startDate = userCalendar.date(from: startDateComponents) else { return [] }
        
        var endDateComponents = DateComponents()
        endDateComponents.year = Date().getCurrentYear()
        endDateComponents.month = 2
        endDateComponents.day = 15
        endDateComponents.hour = 00
        endDateComponents.timeZone = TimeZone(abbreviation: "PST")
        guard let endDate = userCalendar.date(from: endDateComponents) else { return [] }
        
        return self.getRangeForDates(startDate: startDate, endDate: endDate, yearsAgo: yearsAgo)
    }
    
    func getChristmasHolidays(yearsAgo: Int) -> [Date]  {
        
        let userCalendar = Calendar.current
        var startDateComponents = DateComponents()
        startDateComponents.year = Date().getCurrentYear()
        startDateComponents.month = 12
        startDateComponents.day = 14
        startDateComponents.hour = 00
        startDateComponents.timeZone = TimeZone(abbreviation: "PST")
        guard let startDate = userCalendar.date(from: startDateComponents) else { return [] }
        
        var endDateComponents = DateComponents()
        endDateComponents.year = Date().getCurrentYear()
        endDateComponents.month = 12
        endDateComponents.day = 31
        endDateComponents.hour = 00
        endDateComponents.timeZone = TimeZone(abbreviation: "PST")
        guard let endDate = userCalendar.date(from: endDateComponents) else { return [] }
        
        return self.getRangeForDates(startDate: startDate, endDate: endDate, yearsAgo: yearsAgo)
    }
}
