//
//  ImageHelper.swift
//  TravioApp
//
//  Created by Aydın Erol on 12.11.2023.
//

import Foundation
import Kingfisher
import UIKit

class ImageHelper{
    
    // MARK: Properties
    
    let imgPlaceholder:UIImage = (UIImage(systemName: "camera.metering.none")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemGray3))!
    
    // Processors
    //private let imgProcessor: KingfisherOptionsInfoItem = .processor(RoundCornerImageProcessor(cornerRadius: 16)) // round image corners
    //private let blurProcessor: KingfisherOptionsInfoItem = .processor(BlurImageProcessor(blurRadius: 4)) // blur image
    
    private let imgTransition: KingfisherOptionsInfoItem = .transition(.fade(0.5)) // image loading animation
    
    
    // MARK: KF-SetImage
    
    func setImage(imageURL:URL, imageView:UIImageView){
        let imgDownsampler: KingfisherOptionsInfoItem = .processor(DownsamplingImageProcessor(size: imageView.bounds.size))
        let kfOptions: KingfisherOptionsInfo = [imgDownsampler, imgTransition, .cacheOriginalImage]
        
        imageView.kf.indicatorType = .activity

        imageView.kf.setImage(with: imageURL, placeholder: imgPlaceholder, options: kfOptions) { result in
            switch result{
            case .success(_):
                return
            case .failure(_):
                return
            }
        }
    }
    
    
    // MARK: KF-RetrieveImage
    
    func setImageCustom(imageURL:URL, imageView:UIImageView){
        
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

extension ImageHelper{
    
}
