//
//  ThemesPlacesDataSource.swift
//  SmartPicker
//
//  Created by James Rochabrun on 3/18/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import PromiseKit
import Photos
import CoreLocation

struct ThemesPlacesDataSource {
    
    private let themes: [Theme]
    
    init(themes: [Theme]) {
        self.themes = themes
    }
    
    func getPlacesModels() -> Promise<[ThemePlaceViewModel]> {
        return Promise{ f, r in
            self.themes.isEmpty ? r(ThemeError.noThemes) : f(self.themes.flatMap { ThemePlaceViewModel(theme: $0) })
        }
    }
}


