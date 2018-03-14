//
//  SmartAlbumType.swift
//  SmartPicker
//
//  Created by James Rochabrun on 3/13/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import PromiseKit
import Photos

extension ThemeFabric.SmartAlbumType: ThemeProvider {
    
    // MARK: - ThemeProvider Conformance
    var themePromise: Promise<Theme> {
        switch self {
        case .getTheme(let phassetCollectionSubType, let periodPredicate, let justFavorites, let sortDescriptors):
            return self.getAlbum(subType: phassetCollectionSubType, justFavorites: justFavorites, from: periodPredicate, sortDescriptors: sortDescriptors)
            //        default:
            //            return Promise { f, r in
            //                f(CurationTheme(title: "nothing", logString: "nothing", potentialAssets: []))
            //            }
        }
    }
    /// Use this variable for [theme]
    var themesPromise: Promise<[Theme]> {
        switch self {
        default:
            return Promise { f, r in
                f([])
            }
        }
    }
    
    internal func constructPeriodPredicate(from period: [Date]) -> NSPredicate {
        if let startDate = period.first, let endOfDate = period.last {
            return NSPredicate(format: "creationDate >= %@ AND creationDate < %@", startDate as NSDate, endOfDate as NSDate)
        } else {
            /// if dates are nil return current day, just to avoid potential crashes
            return NSPredicate(format: "creationDate >= %@ AND creationDate < %@", Date() as NSDate, Date() as NSDate)
        }
    }
    // MARK: - Want an specific album? use one of this PHAssetCollectionSubtype to get specific album
    /// It also can filter from just ones marked as favorites from a certain period
    
    /// .smartAlbumSelfPortraits = Selfies album
    /// .smartAlbumFavorites = Favorites album
    /// .smartAlbumLivePhotos = Live Photos album
    /// .smartAlbumDeptheffect = Portrait album
    /// .smartAlbumRecentlyAdded = Recently Added album
    /// .smartAlbumUserLibrary = All Smart albums available (all photos)
    /// .smartAlbumPanorama = Photos from Panorama album
    /// .smartAlbumLivePhotos = Live Photos
    
    // Keys to explore:
    
    /// .smartAlbumAllHidden = returns album with hidden images?
    /// .smartAlbumUserLibrary = opposed to assets from iCloud Shared Albums ?
    /// .albumCloudShared = An iCloud Shared Photo Stream.
    /// .albumMyPhotoStream = The user’s personal iCloud Photo Stream.
    /// .smartAlbumLongExposures
    
    private func getAlbum(subType: PHAssetCollectionSubtype, justFavorites: Bool, from period: ThemePeriodAttribute, sortDescriptors: [SortProvider]) -> Promise<Theme> {
        
        return Promise { fullfill, reject in
            
            DispatchQueue.global(qos: .background).async {
                let smartAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: subType, options: nil)
                guard let assetCollection = smartAlbum.firstObject else {
                    reject(ThemeError.noAlbumForSubtype(type: subType.themeTitle))
                    return
                }
                let options = PHFetchOptions.init()
                var predicates: [NSPredicate] = []
                let periodPredicate = self.constructPeriodPredicate(from: period.period)
                let subTypePredicate = subType.predicate
                predicates.append(periodPredicate)
                predicates.append(subTypePredicate)
                
                if justFavorites {
                    let isFavoritePredicate = NSPredicate(format: "isFavorite == %d",  1 as CVarArg)
                    predicates.append(isFavoritePredicate)
                }
                
                let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
                options.predicate = compound
                options.sortDescriptors = sortDescriptors.map { $0.sortDescriptor }
                
                let assetResult = PHAsset.fetchAssets(in: assetCollection, options: options)
                
                var assets: [PHAsset] = []
                assetResult.enumerateObjects { asset, index, stop in
                    assets.append(asset)
                }
                
                let curationTheme = Theme(title: assetCollection.localizedTitle!, locationTitle: "", potentialAssets: assets, uniqueID: (assetCollection.localizedTitle?.removingWhiteSpaces())!, location: nil)
                
                DispatchQueue.main.async {
                    if curationTheme.potentialAssets.count > 0 {
                        fullfill(curationTheme)
                    } else {
                        reject(ThemeError.noPotentialAssets)
                    }
                }
            }
        }
    }
}

