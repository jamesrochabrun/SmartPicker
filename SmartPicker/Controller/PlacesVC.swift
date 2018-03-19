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
import Photos
import PromiseKit

class PlacesVC: UIViewController {
    
    // MARK: UI
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    let locationManager = CLLocationManager()
    var placesDataSource: ThemesPlacesDataSource?
    
    // MARK: App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationAccess()
        performRequest()
    }
    
    private func performRequest() {
        
        ThemeFabric.MomentType.getRandomMoments(qty: 20, sortDescriptors: [.creationDate]).themesPromise.then { themes in
            self.setDataSource(with: themes)
            }.catch { error in
                print("error \(error)")
        }
    }
    
    private func setDataSource(with themes: [Theme]) {
        self.placesDataSource = ThemesPlacesDataSource(themes: themes)
        self.placesDataSource?.getPlacesModels().then { places in
            // create annotations here
            print("KMPLACES \(places.map { $0.title })")
        }
    }
    
    private func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .denied, .restricted:
            print("location access denied")
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

struct ThemesPlacesDataSource {
    
    private let themes: [Theme]
    
    init(themes: [Theme]) {
        self.themes = themes
    }

    func getPlacesModels() -> Promise<[ThemePlaceViewModel]> {
        return Promise{ f, r in
            self.themes.isEmpty ? r(ThemeError.noThemes) : f(self.themes.map { ThemePlaceViewModel(theme: $0) })
        }
    }
}

struct ThemePlaceViewModel {
    
    let title: String
    private let location: CLLocation?
    private let placeAssets: [PHAsset]
    private let annotationCover: PHAsset?
    
    init(theme: Theme) {
        self.title = theme.locationTitle
        self.location = theme.location
        self.placeAssets = theme.potentialAssets
        self.annotationCover = theme.themeCover
    }
    
}






