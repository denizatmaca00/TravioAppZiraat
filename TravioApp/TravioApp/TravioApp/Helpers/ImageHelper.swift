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
    
}

extension ImageHelper {
    func setImage(imageURL:URL, imageView:UIImageView){
        KingfisherManager.shared.retrieveImage(with: imageURL, options: nil, progressBlock: nil) { result in
            
            switch result{
            case .success(let value):
                imageView.image = value.image
            case .failure(_): //let error case
                print("image not found on: \(imageURL)")
                // null image placeholder:
                imageView.image = UIImage(systemName: "camera.metering.none")?
                    .withRenderingMode(.alwaysOriginal)
                    .withTintColor(.systemGray3)
                return
            }
        }
    }
}
