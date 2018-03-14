//
//  ThemeProvider.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import PromiseKit

// MARK: - protocol, used on nested enums
protocol ThemeProvider {
    
    var themePromise: Promise<Theme> { get }
    var themesPromise: Promise<[Theme]> { get }
    func constructPeriodPredicate(from period: [Date]) -> NSPredicate
}
