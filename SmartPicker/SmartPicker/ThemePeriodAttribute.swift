//
//  DateAttributeManager.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation

enum ThemePeriodAttribute {
    
    /// MARK: We can add any period here like seasons periods x years ago also
    ///passing 0 as an argument for the yearsAgo returns current day, year, month
    /// Big Range Periods
    case ever
    case thisDay(yearsAgo: Int)
    case thisWeek(yearsAgo: Int)
    case thisMonth(yearsAgo: Int)
    case fullRangeOfYear(yearsAgo: Int)
    
    /// Small Range Periods
    case lastWeekend
    
    /// Holidays
    case valentines(yearsAgo: Int)
    case christmasHolidays(yearsAgo: Int)
    
    /// Enum helper for format periodThemeTitle
    private enum Time {
        case day
        case week
        case month
        case year
    }
    
    /// Enum helper for change numeric # of years in to sring representation
    enum Years: Int {
        
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case ten
        case wayDownInThePast
    }
}

extension ThemePeriodAttribute.Years {
    
    init(_ yearsAgo: Int) {
        switch yearsAgo {
        case 1: self = .one
        case 2: self = .two
        case 3: self = .three
        case 4: self = .four
        case 5: self = .five
        case 6: self = .six
        case 7: self = .seven
        case 8: self = .eight
        case 9: self = .nine
        case 10: self = .ten
        default: self = .wayDownInThePast
        }
    }
    
    var asText: String {
        switch self {
        case .one: return "One"
        case .two: return "Two"
        case .three: return "Three"
        case .four: return "Four"
        case .five: return "Five"
        case .six: return "Six"
        case .seven: return "Seven"
        case .eight: return "Eight"
        case .nine: return "Nine"
        case .ten: return "Ten"
        case .wayDownInThePast: return ""
        }
    }
}

// MARK: - Computed properties
extension ThemePeriodAttribute {
    
    var period: [Date] {
        switch self {
        case .ever: return Date().getLargeDateRange()
        case .thisDay(let yearsAgo): return Date().getThisDay(yearsAgo: yearsAgo)
        case .thisWeek(let yearsAgo): return Date().getThisWeek(yearsAgo: yearsAgo)
        case .thisMonth(let yearsAgo): return Date().getThisMonth(yearsAgo: yearsAgo)
        case .fullRangeOfYear(let yearsAgo): return Date().getRangeForFullYear(yearsAgo: yearsAgo)
        case .valentines(let yearsAgo): return Date().getValentines(yearsAgo: yearsAgo)
        case .christmasHolidays(let yearsAgo) : return Date().getChristmasHolidays(yearsAgo: yearsAgo)
        case .lastWeekend: return Date().getLastWeekend()
        }
    }
    
    var periodThemeTitle: String {
        switch self {
        case .ever: return ""
        case .thisDay(let yearsAgo): return self.periodFormatter(for: .day, yearsAgo: yearsAgo)
        case .thisWeek(let yearsAgo): return self.periodFormatter(for: .week, yearsAgo: yearsAgo)
        case .thisMonth(let yearsAgo): return self.periodFormatter(for: .month, yearsAgo: yearsAgo)
        case .fullRangeOfYear(let yearsAgo): return self.periodFormatter(for: .year, yearsAgo: yearsAgo)
        case .valentines(let yearsAgo): return "Valentines \((Date().getCurrentYear() - yearsAgo))"
        case .christmasHolidays(let yearsAgo): return "Christmas \((Date().getCurrentYear() - yearsAgo))"
        case .lastWeekend: return "Your Best Photo Last Weekend"
        }
    }
    
    private func periodFormatter(for time: Time, yearsAgo: Int) -> String {
        switch time {
        case .day:
            return yearsAgo == 0 ? "Today" : (yearsAgo == 1 ? "This Day, Last Year" : "\(ThemePeriodAttribute.Years(yearsAgo).asText) Years Ago Today")
        case .week:
            return yearsAgo == 0 ? "This Week" : (yearsAgo == 1 ? "This Week, Last Year" : "This Week, \(ThemePeriodAttribute.Years(yearsAgo).asText) Years Ago")
        case .month:
            return yearsAgo == 0 ? "This Month" : (yearsAgo == 1 ? "This Month, Last Year" : "This Month, \(ThemePeriodAttribute.Years(yearsAgo).asText) Years Ago")
        case .year:
            return yearsAgo == 0 ? "" : (yearsAgo == 1 ? "Last Year" : "\(ThemePeriodAttribute.Years(yearsAgo).asText) Years Ago")
        }
    }
}
