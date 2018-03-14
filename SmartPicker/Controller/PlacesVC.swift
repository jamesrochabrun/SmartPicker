//
//  PlacesVC.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PlacesVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeFabric.MomentType.getRandomMoments(qty: 20, sortDescriptors: [.creationDate]).themesPromise.then { themes in
            themes.map { self.printTheme($0) }
            }.catch { error in
                print("error \(error)")
        }
    }
    
    func printTheme(_ theme: Theme) {
        
        print("title: \(theme.title), \n location \(theme.location), \n location title \(theme.locationTitle), count \(theme.potentialAssets.count)")
    }
}
