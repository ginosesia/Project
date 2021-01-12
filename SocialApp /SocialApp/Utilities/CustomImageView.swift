//
//  CustomImageView.swift
//  SocialApp
//
//  Created by Gino Sesia on 25/07/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()


class CustomImageView: UIImageView {
    
    var lastImgUrlUsedToLoadImage: String?

            
        func loadImage(with urlString: String) {
            
            //set image to nil
            self.image = nil
            
            //set last image
            lastImgUrlUsedToLoadImage = urlString
            
                //if image exists
                if let cachedImage = imageCache[urlString] {
                    self.image = cachedImage
                    return
                }
                guard let url = URL(string: urlString) else { return }
                
                //fetch contents
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("failed to load image with error: ", error.localizedDescription)
                    }
                    
                    if self.lastImgUrlUsedToLoadImage != url.absoluteString {
                        return
                    }
                 
                    //image data
                    guard let imageData = data else { return }
                    
                    //set image using image data
                    let photoImage = UIImage(data: imageData)
                    
                    //set key for image cache
                    imageCache[url.absoluteString] = photoImage
                    
                    //set image
                    DispatchQueue.main.async {
                        self.image = photoImage
                    }
                    
                }.resume()
    }
}
