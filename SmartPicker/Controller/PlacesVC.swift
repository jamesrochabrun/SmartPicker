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
    
    // MARK: private Properties
    private let locationManager = CLLocationManager()
    private var placesDataSource: ThemesPlacesDataSource?

    // MARK: App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationAccess()
        performRequest()
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.id)
    }
    
    // MARK: Request Location authorization
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
    
    // MARK: Configure data
    private func performRequest() {
        
        ThemeFabric.MomentType.getRandomMoments(qty: 20, sortDescriptors: [.creationDate]).themesPromise.then { themes in
            self.setDataSource(with: themes)
            }.catch { error in
                print("error \(error)")
        }
    }
    
    private func setDataSource(with themes: [Theme]) {
        self.placesDataSource = ThemesPlacesDataSource(themes: themes)
        self.placesDataSource?.getPlacesModels().then { placesModels in
            // create annotations here
            self.setAnnotations(with: placesModels)
        }
    }
    
    private func setAnnotations(with viewModels: [ThemePlaceViewModel]) {
        let annotations = viewModels.map { ThemePlace(themeVM: $0) }
        mapView.delegate = self
        mapView.addAnnotations(annotations)
    }
}

extension PlacesVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.id) as! CustomAnnotationView
        annotationView.delegate = self
        let placeTheme = annotation as! ThemePlace
        let targetSize = CGSize(width: 70, height: 70)
        annotationView.updateFrame(CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        annotationView.configure(placeTheme)
        return annotationView
    }
}

extension PlacesVC: CustomAnnotationViewDelegate {
    
    func annotationTapped(_ annotation: CustomAnnotationView) {
        
        guard let placeTheme = annotation.placeTheme else { return }
        let destinationVC = AssetGridVC.nib(AssetGridVC.self)
        let localIdS = placeTheme.placeAssets.map { $0.localIdentifier }
        let fetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(withLocalIdentifiers: localIdS, options: nil)
        destinationVC.fetchResult = fetchResult
        self.present(destinationVC, animated: true, completion: nil)
    }
}

