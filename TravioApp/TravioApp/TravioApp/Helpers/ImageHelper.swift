//
//  ImageHelper.swift
//  TravioApp
//
//  Created by Aydın Erol on 12.11.2023.
//

import UIKit
import Kingfisher

class ImageHelper{
    
    // MARK: Properties
    
    static let shared = ImageHelper()
    
    let imgPlaceholder:UIImage = (UIImage(systemName: "camera.metering.none")?
        .withRenderingMode(.alwaysOriginal)
        .withTintColor(.systemGray3))!
    
    private let imgTransition: KingfisherOptionsInfoItem = .transition(.fade(0.5)) // image loading animation
    
    // MARK: KF-SetImage

    func setImage(imageURL:URL, imageView:UIImageView){
        
        let kfOptions: KingfisherOptionsInfo = [imgTransition, .cacheOriginalImage] // options for kingfisher
        
        imageView.kf.indicatorType = .activity // set indicator when waiting for image response
        
        imageView.kf.setImage(with: imageURL, placeholder: imgPlaceholder, options: kfOptions) { _ in }
    }
    
    // MARK: KF-RetrieveImage
    
    func setImageByRetrieve(imageURL:URL, imageView:UIImageView){
        
        let kfOptions:KingfisherOptionsInfo = [imgTransition]
        
        imageView.kf.indicatorType = .activity
        
        KingfisherManager.shared.retrieveImage(with: imageURL, options: kfOptions, progressBlock: nil) { result in
            
            switch result{
            case .success(let value):
                imageView.image = value.image
            case .failure(_): //let error case
                imageView.image = self.imgPlaceholder
                return
            }
        }
    }
}
