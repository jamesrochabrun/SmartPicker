//
//  Theme.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import Photos
import CoreLocation

struct Theme {
    let title: String
    let locationTitle: String
    let potentialAssets: [PHAsset]
    let uniqueID: String
    let location: CLLocation?
}
