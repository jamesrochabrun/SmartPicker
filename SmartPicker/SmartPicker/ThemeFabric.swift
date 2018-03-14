//
//  ThemeFabric.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//
import Foundation
import Photos

// MARK: - Main Theme Builder it has 3 main cases based on PHAssetCollectionType Constants
/// https://developer.apple.com/documentation/photos/phassetcollectiontype

enum ThemeFabric {
    
    // album: an Album in the Photos App
    /// fetch assetes like custom albums, currently unused
    enum AlbumType {}
    // smartAlbum: A smart album whose contents update dynamically.
    /// fetch assets from smart albums like, selfies, favorites, live photos,
    enum SmartAlbumType {
        /// fetch asstes from smart albums like, selfies, favorites, live photos,
        case getTheme(subType: PHAssetCollectionSubtype, period: ThemePeriodAttribute, justFavorites: Bool, sortDescriptors: [SortProvider])
        
    }
    // moment: A moment in the Photos app.
    /// for now just fetch random album from moments albums
    enum MomentType {
        // moment: A moment in the Photos app.
        /// for now just fetch random album from moments albums
        case getRandomThemes(titles: [String], sortDescriptors: [SortProvider])
        case getRandomMoments(qty: Int, sortDescriptors: [SortProvider])
       // case getThemes(subType: PHAssetCollectionSubtype, period: ThemePeriodAttribute, justFavorites: Bool, sortDescriptors: [SortProvider])
    }
}







