//
//  CustomError.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation

enum ThemeError: Error {
    
    case noAlbumForSubtype(type: String)
    case noPotentialAssetsFor(theme: String)
    case noPotentialAssets
    case noRandomMoments
    case noThemes
    
    var localizedDescription: String {
        switch self {
        case .noAlbumForSubtype(let type): return "ThemeError No album found for subtype \(type)"
        case .noPotentialAssetsFor(let theme): return "ThemeError No Potential assests for this theme: \(theme)"
        case .noRandomMoments: return "ThemeError no random moments founded"
        case .noPotentialAssets: return "ThemeError no assets"
        case .noThemes: return "No themes founded"
        }
    }
}
