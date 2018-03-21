//
//  ThemePlace.swift
//  SmartPicker
//
//  Created by James Rochabrun on 3/18/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import CoreLocation
import Photos
import MapKit

struct ThemePlaceViewModel {
    
    let title: String?
    let subTitle: String?
    let coordinate: CLLocationCoordinate2D
    let assets: [PHAsset]
    let cover: PHAsset
    
    init?(theme: Theme) {
        guard let c = theme.location else { return nil }
        if theme.potentialAssets.isEmpty  { return nil }
        guard let themeCover = theme.themeCover else { return nil }
        
        self.coordinate = c.coordinate
        self.title = theme.locationTitle
        self.subTitle = theme.title
        self.assets = theme.potentialAssets
        self.cover = themeCover
        
    }
}

@objc class ThemePlace: NSObject {

    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    let placeAssets: [PHAsset]
    let annotationCover: PHAsset
    
    init(themeVM: ThemePlaceViewModel) {
        self.title = themeVM.title
        self.subtitle = themeVM.subTitle
        self.coordinate = themeVM.coordinate
        self.placeAssets = themeVM.assets
        self.annotationCover = themeVM.cover
    }
}

extension ThemePlace: MKAnnotation {}





