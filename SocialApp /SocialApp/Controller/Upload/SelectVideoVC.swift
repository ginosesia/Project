//
//  SelectVideoVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 12/12/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit
import Photos
import AVKit

class SelectVideoVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var videos = [UIImage]()
    var assets = [PHAsset]()
    var selectedVideo: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select Video"
        navigationController?.navigationBar.isTranslucent = false
        configureNavigationButton()
        fetchVideosFromDeviceLibary()
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
        //let uploadVC = UploadPostVC()
        //uploadVC.selectedImage = header?.photoImageView.image
        //uploadVC.editMode = false
        //navigationController?.pushViewController(uploadVC, animated: true)
     }

    @objc func handleCameraTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func fetchVideosFromDeviceLibary() {
        
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
                        self.videos.append(image)
                        self.assets.append(asset)
                        if self.selectedVideo == nil {
                            self.selectedVideo = image
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
        let options = PHFetchOptions()
        options.fetchLimit = 50
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]
        return options
    }

}
