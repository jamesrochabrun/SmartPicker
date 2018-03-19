//
//  Moment.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import PromiseKit
import Photos

extension ThemeFabric.MomentType: ThemeProvider {
    
    var themePromise: Promise<Theme> {
        switch self {
        default:
            return Promise { f, r in
                f(Theme(themeCover: nil, title: "nothing you call the wrong promise", locationTitle: "text", potentialAssets: [], uniqueID: "", location: nil))
            }
        }
    }
    
    var themesPromise: Promise<[Theme]> {
        switch self {
        case .getRandomMoments(let qty, let sortDescriptors):
            return self.randomMoments(qty: qty, sortDescriptors: sortDescriptors)
        case .getRandomThemes(let titles, let sortDescriptors):
            return self.randomMomentThemes(titles: titles, sortDescriptors: sortDescriptors)
        default:
            return Promise { f, r in
                f([Theme(themeCover: nil, title: "nothing you call the wrong promise", locationTitle: "nil", potentialAssets: [], uniqueID: "", location: nil)])
            }
        }
    }
    
    // MARK: main helper functions - private
    /// remember Moments predicate works by startDate and EndDate, once you have the collection you can fetch assets from that collection based on the creationDate (no needed for now)
    internal func constructPeriodPredicate(from period: [Date]) -> NSPredicate {
        if let startDate = period.first, let endOfDate = period.last {
            return NSPredicate(format: "startDate >= %@ AND endDate < %@", startDate as NSDate, endOfDate as NSDate)
        } else {
            /// if dates are nil return current day, just to avoid potential crashes
            return NSPredicate(format: "startDate >= %@ AND endDate < %@", Date() as NSDate, Date() as NSDate)
        }
    }
    
    /// - Helper for title construction
    private func constructLocationTitle(_ text: String) -> String {
        var prefix = ""
        if let stringComponents = text.components(separatedBy: "-").first {
            prefix = stringComponents
        }
        if !prefix.isEmpty {
            if let commaPrefix = prefix.components(separatedBy: ",").first {
                prefix = commaPrefix
            }
        } else {
            if let commaPrefix = prefix.components(separatedBy: ",").first {
                prefix = commaPrefix
            }
            prefix = text
        }
        return prefix
    }
    
    /// - Helper for assets fetch options
    private func getOptionsForAssetsFetch(sortDescriptors: [SortProvider]) -> PHFetchOptions {
        let options = PHFetchOptions.init()
        options.sortDescriptors = sortDescriptors.map { $0.sortDescriptor }
        return options
    }
    
    /// - Helper for collectionFetch options
    private func getOptionsForCollectionFetch(period: ThemePeriodAttribute) -> PHFetchOptions {
        let options = PHFetchOptions.init()
        options.predicate = self.constructPeriodPredicate(from: period.period)
        return options
    }
    
    /// - Helper for enumerate assets from a collection and return them in an array
    private func getAssetsIn(collection: PHAssetCollection, with options: PHFetchOptions) -> [PHAsset] {
        let assetResult = PHAsset.fetchAssets(in: collection, options: options)
        var assets: [PHAsset] = []
        assetResult.enumerateObjects { asset, index, stop in
            assets.append(asset)
        }
        return assets
    }
    
    /// - Helper function to return random collections
    private func getRandomCollections(qty: Int) -> [PHAssetCollection] {
        let momentsAlbumsResults: PHFetchResult<PHAssetCollection> =  PHAssetCollection.fetchAssetCollections(with: .moment, subtype: .albumRegular, options: nil)
        var collections: [PHAssetCollection] = []
        momentsAlbumsResults.enumerateObjects { collection, index, stop in
            // TODO: aassetestimated count 'average' or how many the user tends to take for any moment
            /// check if moments has a title also it has more than one asset to work with
            if let title = collection.localizedTitle, !title.isEmpty,
                collection.estimatedAssetCount > 0 {
                collections.append(collection)
            }
        }
        let randomCollection = collections.shuffled.choose(qty)
        return randomCollection
    }
    
    private func getRandomAssetForCover(in assets: [PHAsset]) -> PHAsset? {
        return assets.shuffled.choose(1).first
    }
}

// MARK: for set of themes based in randomization ...
extension ThemeFabric.MomentType {
    
    // MARK: - Want a X number of Random Moments with a custom name?
    private func randomMomentThemes(titles: [String], sortDescriptors: [SortProvider]) -> Promise<[Theme]> {
        
        return Promise { fullfill, reject in
            
            DispatchQueue.global(qos: .background).async {
                let collections = self.getRandomCollections(qty: titles.count)
                var momentsThemes: [Theme] = []
                // options to pass to the assets fetch
                let options = self.getOptionsForAssetsFetch(sortDescriptors: sortDescriptors)
                
                for (index, collection) in collections.enumerated() {
                    //Creating the Album theme title
                    //for this call just pass the collection.localIdentifier as period, later when we add a period parameter on this call will change that.
                    let localizedTitle = collection.localizedTitle ?? ""
                    /// assign title to theme at index, an array of keys has been passed
                    let themeTitleKey = titles[index]
                    let assets = self.getAssetsIn(collection: collection, with: options)
                    /// this will fix uniqueness
                    let uniqueID = themeTitleKey.removingWhiteSpaces()
                    /// this will help with the location subtitle
                    let locationTitle = self.constructLocationTitle(localizedTitle)
                    /// location
                    let aproxLocation = collection.approximateLocation
                    /// cover
                    let randomCover = self.getRandomAssetForCover(in: assets)
                    let curationTheme = Theme(themeCover: randomCover, title: themeTitleKey, locationTitle: locationTitle, potentialAssets: assets, uniqueID: uniqueID, location: aproxLocation)
                    momentsThemes.append(curationTheme)
                }
                DispatchQueue.main.async {
                    momentsThemes.count > 0 ? fullfill(momentsThemes) : reject(ThemeError.noRandomMoments)
                }
            }
        }
    }
    
    private func randomMoments(qty: Int, sortDescriptors: [SortProvider]) -> Promise<[Theme]> {
        
        return Promise { fullfill, reject in
            
            DispatchQueue.global(qos: .background).async {
                let collections = self.getRandomCollections(qty: qty)
                var momentsThemes: [Theme] = []
                // options to pass to the assets fetch
                let options = self.getOptionsForAssetsFetch(sortDescriptors: sortDescriptors)
                
                for collection in collections {
                    //for this call just pass the collection.localIdentifier as period, later when we add a period parameter on this call will change that.
                    let localizedTitle = collection.localizedTitle ?? ""
                    /// assign title to theme at index, an array of keys has been passed
                    let startDateTitle = "\(collection.startDate!)"
                    let assets = self.getAssetsIn(collection: collection, with: options)
                    /// this will fix uniqueness
                    let uniqueID = startDateTitle.removingWhiteSpaces()
                    /// this will help with the location subtitle
                    let locationTitle = self.constructLocationTitle(localizedTitle)
                    // coordinates
                    let approxLocation = collection.approximateLocation
                    /// cover
                    let randomCover = self.getRandomAssetForCover(in: assets)

                    let curationTheme = Theme(themeCover: randomCover, title: startDateTitle, locationTitle: locationTitle, potentialAssets: assets, uniqueID: uniqueID, location: approxLocation)
                    momentsThemes.append(curationTheme)
                }
                DispatchQueue.main.async {
                    momentsThemes.count > 0 ? fullfill(momentsThemes) : reject(ThemeError.noRandomMoments)
                }
            }
        }
    }
}

