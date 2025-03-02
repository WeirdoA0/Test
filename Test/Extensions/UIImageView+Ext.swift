//
//  UIImageView+Ext.swift
//  Test
//
//  Created by Руслан Усманов on 01.03.2025.
//

import UIKit

extension UIImageView {
    
    /// Позволяет использовать UIImageView похожим образом как и AsyncImage из SwiftUI
    func loadAsyncImage(stringURL: String, failedPicture: UIImage) {
        var activityIndicator: UIActivityIndicatorView? = UIActivityIndicatorView(style: .medium)
        self.addSubview(activityIndicator ?? UIView())
        activityIndicator?.frame = self.frame
        activityIndicator?.startAnimating()
        
        ImageLoader.shared.loadImage(stringURL: stringURL, completion: { [weak self] image in
            DispatchQueue.main.async(execute: {
                activityIndicator?.removeFromSuperview()
                activityIndicator = nil
                if let image {
                    self?.image = image
                } else {
                    self?.image = failedPicture
                }
            })
        })
    }
    
    
}
