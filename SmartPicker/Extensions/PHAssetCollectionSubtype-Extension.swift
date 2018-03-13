//
//  PHAssetCollectionSubtype-Extension.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//
import Photos
import Foundation

// MARK: PHAssetCollectionSubtype Extension for ThemeProvider conformance
/// Available Subtypes
extension PHAssetCollectionSubtype {
    
    /// For now just the most used albums in our curation request
    var themeTitle: String {
        switch self {
        case .albumRegular: return ""
        case .smartAlbumSelfPortraits: return "Your Best Selfies"
        case .smartAlbumLivePhotos: return "Your Live Photos"
        case .smartAlbumDepthEffect: return "Your Picture Perfect Memories"
        case .smartAlbumRecentlyAdded: return "Recently added"
        case .smartAlbumFavorites: return "Your Favorites"
        case .smartAlbumPanoramas: return "Your Panoramas"
        case .smartAlbumUserLibrary: return ""
        default:
            return ""
        }
    }
    
    //PHAsset available keys for predicates
    /*
     SELF, localIdentifier, creationDate, modificationDate, mediaType, mediaSubtypes, duration, pixelWidth, pixelHeight, isFavorite (or isFavorite), isHidden (or isHidden), burstIdentifier
     */
    var predicate: NSPredicate {
        return NSPredicate(format: "!((mediaSubtype & %d) == %d) AND isHidden != %d", PHAssetMediaSubtype.photoScreenshot.rawValue, PHAssetMediaSubtype.photoScreenshot.rawValue,  1 as CVarArg)
    }
}
