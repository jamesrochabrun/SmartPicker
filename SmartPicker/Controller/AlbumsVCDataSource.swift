//
//  AlbumsVCDataSource.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import Photos

protocol AlbumsVCDataSourceDelegate: class {
    func headerTapped()
}

class AlbumsVCDataSource: NSObject, UICollectionViewDataSource {
    
    init(collectionView: UICollectionView) {
        // Create a PHFetchResult object for each section in the table view.
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        self.collectionView = collectionView
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    // MARK: Properties
    weak var delegate: AlbumsVCDataSourceDelegate?
    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!
    let sectionLocalizedTitles = ["All Photos", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]
    private let collectionView: UICollectionView
    private let imageManager = PHCachingImageManager()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch Section(rawValue: indexPath.section)! {
        case .allPhotos:
            return UICollectionViewCell()
        case .smartAlbums:
            let cell: AlbumCoverCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            let collection = smartAlbums.object(at: indexPath.row)
            cell.albumImageView.isUserInteractionEnabled = false
            let assets = PHAsset.fetchAssets(in: collection, options: nil)
            let asset = assets.firstObject
            let vm = AlbumCoverViewModel(cover: asset, title: collection.localizedTitle, size: cell.frame.size)
            cell.configure(viewModel: vm)
            return cell
        case .userCollections:
            let cell: AlbumCoverCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.albumImageView.isUserInteractionEnabled = false
            let collection = userCollections.object(at: indexPath.row) as! PHAssetCollection
            let assets = PHAsset.fetchAssets(in: collection, options: nil)
            let asset = assets.firstObject
            let vm = AlbumCoverViewModel(cover: asset, title: collection.localizedTitle, size: cell.frame.size)
            cell.configure(viewModel: vm)
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .allPhotos: return 0 // the header represents all photos
        case .smartAlbums: return smartAlbums.count
        case .userCollections: return userCollections.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch Section(rawValue: indexPath.section)! {
        case .allPhotos:
            let header: AlbumCoverCell = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
            header.delegate = self
            let coverAsset = allPhotos.firstObject
            let vm = AlbumCoverViewModel(cover: coverAsset, title: sectionLocalizedTitles[indexPath.section], size: header.frame.size)
            header.configure(viewModel: vm)
            return header
        case .smartAlbums, .userCollections:
            let header: AlbumSectionHeader = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
            let vm = AlbumSectionHeaderViewModel(title: sectionLocalizedTitles[indexPath.section])
            header.configure(viewModel: vm)
            return header
        }
    }
    
    
    // MARK: getters
    func getAllPhotos() -> PHFetchResult<PHAsset> {
        return self.allPhotos
    }
    
    func getSmartAlbum(at indexPath: IndexPath) -> PHAssetCollection? {
        return smartAlbums.object(at: indexPath.item)
    }
    
    func getUserCollection(at indexPath: IndexPath) -> PHAssetCollection? {
        return userCollections.object(at: indexPath.item) as? PHAssetCollection
    }
}

extension AlbumsVCDataSource: AlbumCoverCellDelegate {
    
    func tapped() {
        delegate?.headerTapped()
    }
}


extension AlbumsVCDataSource: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        //        DispatchQueue.main.sync {
        //            // Check each of the three top-level fetches for changes.
        //
        //            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
        //                // Update the cached fetch result.
        //                allPhotos = changeDetails.fetchResultAfterChanges
        //                // (The table row for this one doesn't need updating, it always says "All Photos".)
        //            }
        //
        //            // Update the cached fetch results, and reload the table sections to match.
        //            if let changeDetails = changeInstance.changeDetails(for: smartAlbums) {
        //                smartAlbums = changeDetails.fetchResultAfterChanges
        //                tableView.reloadSections(IndexSet(integer: Section.smartAlbums.rawValue), with: .automatic)
        //            }
        //            if let changeDetails = changeInstance.changeDetails(for: userCollections) {
        //                userCollections = changeDetails.fetchResultAfterChanges
        //                tableView.reloadSections(IndexSet(integer: Section.userCollections.rawValue), with: .automatic)
        //            }
        //
        //        }
    }
}

