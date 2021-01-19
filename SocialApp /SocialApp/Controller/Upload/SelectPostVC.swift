//
//  SelectPostVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 06/07/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Photos


private let reuseIdentifier = "SelectPostCell"
private let headerIdentifier = "SelectPostHeader"


class SelectPostVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Properties
    let cellId = "cellId"
    var picture = false
    var video = false
    var text = false
    var header: SelectPostHeader?
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage: UIImage?
    var imagePicker: UIImagePickerController!
    var image = UIImage()


    //MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select Picture"
        navigationController?.navigationBar.isTranslucent = false
        configureNavigationButton()
        setUpCollectionView()
        fetchPhotosFromDeviceLibary()
    }
 
    func setUpCollectionView() {
        collectionView?.register(SelectPostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(SelectPostHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)

    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(row: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SelectPostHeader
        self.header = header
        
        if let selectedImage = self.selectedImage {
            //index of image
            if let index = self.images.firstIndex(of: selectedImage) {
                let selectedAsset = self.assets[index]
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                    header.photoImageView.image = image
                }
            }
        }
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SelectPostCell
        cell.photoImageView.image = images[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.row]
        self.collectionView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = view.frame.width
        width = (width-3)/4
        return CGSize(width: width, height: width)
    }
    
    func configureNavigationButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleBackTapped))
        let next =  UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNextTapped))
        let takePicture = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleCameraTapped))
        navigationItem.rightBarButtonItems = [next, takePicture]
    }
    
    @objc func handleBackTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func handleNextTapped() {
        let uploadVC = UploadPostVC()
        uploadVC.selectedImage = header?.photoImageView.image
        uploadVC.editMode = false
        navigationController?.pushViewController(uploadVC, animated: true)
     }

    @objc func handleCameraTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func fetchPhotosFromDeviceLibary() {
        
        let allPhotos = PHAsset.fetchAssets(with: .video, options: getAssetFetchOptions())
        DispatchQueue.global(qos: .background).async {
            //Enumerate objects
            allPhotos.enumerateObjects({ (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: {
                    (image, info) in
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                        if count == allPhotos.count - 1 {
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                })
            })
        }
    }
    
    func getAssetFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
             fetchOptions.predicate = NSPredicate(format: "mediaType == %d",  PHAssetMediaType.video.rawValue)
        return fetchOptions
    }
}
