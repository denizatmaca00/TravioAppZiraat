//
//  DetailPageCell.swift
//  TravioApp
//
//  Created by Ece Poyraz on 30.10.2023.
//

import UIKit
import Kingfisher

class DetailPageCell: UICollectionViewCell {
  
    private lazy var image:UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFill
        i.clipsToBounds = true
        return i
    }()
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(1.9).cgColor]
        layer.locations = [0.3, 1.0]
        return layer
    }()
    private func addGradientLayer() {
           contentView.layer.addSublayer(gradientLayer)
            gradientLayer.frame = contentView.bounds
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
      
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        contentView.addSubview(image)
        setupLayout()
        addGradientLayer()
        
    }
    func setupLayout(){
        image.topToSuperview(offset:-30)
        image.leadingToSuperview()
        image.trailingToSuperview()
        image.height(279)
    }
    
    func configure(imageURL:Image){
        if let url = URL(string: imageURL.image_url){
            image.kf.setImage(with: url)
            }
    }
    
}

