//
//  DetailPageCell.swift
//  TravioApp
//
//  Created by Ece Poyraz on 30.10.2023.
//

import UIKit
import TinyConstraints
import SnapKit

class DetailPageCell: UICollectionViewCell {
  
    private lazy var image:UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFill
        return i
    }()
    
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
        
    }
    func setupLayout(){
        image.edgesToSuperview()
    }
    
    func configure(imageURL:URL){
        self.image.imageFrom(url: imageURL)
    }
    
}
