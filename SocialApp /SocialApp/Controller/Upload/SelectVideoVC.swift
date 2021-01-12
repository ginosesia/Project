//
//  SelectVideoVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 12/12/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Foundation
import UIKit

class SelectVideoVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select Video"
        navigationController?.navigationBar.isTranslucent = false
        configureNavigationButton()
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
}
