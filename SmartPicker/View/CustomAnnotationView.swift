//
//  CustomAnnotationView.swift
//  SmartPicker
//
//  Created by James Rochabrun on 3/20/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import MapKit
import Photos
import UIKit


protocol CustomAnnotationViewDelegate: class {
    func annotationTapped(_ annotation: CustomAnnotationView)
}

class CustomAnnotationView: MKAnnotationView {
    
    var placeTheme: ThemePlace?
    private let imageManager = PHCachingImageManager()
    
    static let id = "CustomAnnotationView"
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(annotationTapped))
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    let assetsCountLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.white
        l.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.1176470588, blue: 0.1568627451, alpha: 1)
        l.textAlignment = .center
        return l
    }()
    
    weak var delegate: CustomAnnotationViewDelegate?
    
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
    
    func configure(_ place: ThemePlace) {
        self.placeTheme = place
        imageManager.requestImage(for: place.annotationCover, targetSize: self.frame.size, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            self.imageView.image = image
        })
        self.assetsCountLabel.text = "\(place.placeAssets.count)"
    }
    
    @objc func annotationTapped() {
        delegate?.annotationTapped(self)
    }
}





