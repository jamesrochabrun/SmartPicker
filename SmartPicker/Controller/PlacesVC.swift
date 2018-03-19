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
        let overlays = annotations.map { MKCircle(center: $0.coordinate, radius: 100) }
        mapView.addOverlays(overlays)
    }
}

extension PlacesVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            //annotationView.image = UIImage(named: "place icon")
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 2
        return renderer
    }
}






