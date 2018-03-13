//
//  ThemeProvider.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation

// MARK: - protocol, used on nested enums
protocol ThemeProvider {
    var themeCompletion: (Theme) -> () { get }
    var themesCompletion: ([Theme]) -> () { get }
    func constructPeriodPredicate(from period: [Date]) -> NSPredicate
}
