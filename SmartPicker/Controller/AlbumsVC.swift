//
//  AlbumsVC.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import UIKit
import Photos

// MARK: Types for managing sections, cell and segue identifiers
enum Section: Int {
    case allPhotos = 0
    case smartAlbums
    case userCollections
    static let count = 3
}

class AlbumsVC: UIViewController {
    
    // MARK: private properties
    lazy var dataSource: AlbumsVCDataSource = {
        let dSource = AlbumsVCDataSource(collectionView: albumsCollectionView)
        dSource.delegate = self
        return dSource
    }()
    
    // MARK: UI
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    
    // MARK: App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    // MARK: UI Config
    private func configureCollectionView() {
        albumsCollectionView.collectionViewLayout = TwoColumnSquareLayout()
        albumsCollectionView.registerNib(AlbumCoverCell.self)
        albumsCollectionView.registerNibHeader(AlbumSectionHeader.self)
        albumsCollectionView.registerNibHeader(AlbumCoverCell.self)
        albumsCollectionView.dataSource = self.dataSource
    }
}

// MARK: Layout Delegate
extension AlbumsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        var size = CGSize(width: self.albumsCollectionView.bounds.width, height: 0)
        switch Section(rawValue: section)! {
        case .allPhotos:
            size.height = self.albumsCollectionView.bounds.width
        case .smartAlbums, .userCollections:
            size.height = 50
        }        
        return size
    }
}

// MARK: UICollectionViewDelegate
extension AlbumsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destinationVC = AssetGridVC.nib(AssetGridVC.self)
        switch Section(rawValue: indexPath.section)! {
        case .allPhotos:
            break // handled on header
        case .smartAlbums:
            guard let collection = dataSource.getSmartAlbum(at: indexPath) else { return }
            destinationVC.fetchResult = PHAsset.fetchAssets(in: collection, options: nil)
            destinationVC.assetCollection = collection
        case .userCollections:
            guard let collection = dataSource.getUserCollection(at: indexPath) else { return }
            destinationVC.fetchResult = PHAsset.fetchAssets(in: collection, options: nil)
            destinationVC.assetCollection = collection
        }
        self.present(destinationVC, animated: true, completion: nil)
    }
}

// MARK: DataSource Delegate
extension AlbumsVC: AlbumsVCDataSourceDelegate {
    func headerTapped() {
        let destinationVC = AssetGridVC.nib(AssetGridVC.self)
        destinationVC.fetchResult = dataSource.getAllPhotos()
        self.present(destinationVC, animated: true)
    }
}


















