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
    private let imageManager = PHCachingImageManager()

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

        let placeTheme = annotation as! ThemePlace
        let targetSize = CGSize(width: 70, height: 70)
        annotationView.updateFrame(CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        
        print("count \(placeTheme.placeAssets.count)")
        imageManager.requestImage(for: placeTheme.annotationCover, targetSize: targetSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            annotationView.imageView.image = image
            annotationView.assetsCountLabel.text = "\(placeTheme.placeAssets.count)"
        })
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("anootation (view))")
    }
}

class CustomAnnotationView: MKAnnotationView {

    static let id = "CustomAnnotationView"
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let assetsCountLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.white
        l.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.1176470588, blue: 0.1568627451, alpha: 1)
        l.textAlignment = .center
        return l
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setUPViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFrame(_ frame: CGRect) {
        self.frame = frame
        /// set label frame and position
        let labelFrame = CGRect(x: 0, y: 0, width: 22, height: 22)
        self.assetsCountLabel.frame = labelFrame
        self.assetsCountLabel.center = CGPoint(x: self.frame.maxX, y: self.frame.minY)
        self.assetsCountLabel.layer.masksToBounds = true
        self.assetsCountLabel.layer.cornerRadius = labelFrame.width / 2
    }
    
    private func setUPViews() {
        self.imageView.layer.borderColor = #colorLiteral(red: 0.9568627451, green: 0.1176470588, blue: 0.1568627451, alpha: 1).cgColor
        self.imageView.layer.borderWidth = 3.0
        self.imageView.layer.cornerRadius = 10
        self.addSubview(imageView)
        self.addSubview(assetsCountLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ])
    }
}





