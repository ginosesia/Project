//
//  VideoPlayer.swift
//  SocialApp
//
//  Created by Gino Sesia on 03/03/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import UIKit

class VideoLauncher: NSObject {

    
    func showVideoPlayer() {
        
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            

            view.backgroundColor = UIColor.white
            keyWindow.addSubview(view)
            
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height

            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            
            
            view.addSubview(videoPlayerView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }, completion: { (completedAnimation) in
                UIApplication.shared.setStatusBarHidden(true, with: .fade)
            })
        }
    }
    
    func dismissVideoPlayer() {
        
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            

            view.backgroundColor = UIColor.clear
            keyWindow.addSubview(view)
            
            view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                        
        }
    }
    
}
