//
//  CustomCollectionViewCell.swift
//  TravioApp
//
//  Created by Aydın Erol on 30.10.2023.
//

import UIKit
import SnapKit
import Kingfisher

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "placeCell"
    
    var visitCellViewModel : VisitCellViewModel? {
        didSet{
            lblPlace.text = visitCellViewModel?.placeName
            lblCity.text = visitCellViewModel?.city
        }
    }
    
     lazy var imgPlace:UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "sultanahmet")
        /// round corners of the image
        imageView.layer.cornerRadius = 16
        /// apply shadow
        imageView.layer.shadowRadius = 16
        imageView.layer.shadowOpacity = 0.15
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var lblPlace:UILabel = {
       let pn = UILabel()
        pn.font = .Fonts.header24.font
        pn.text = "PlaceName"
        pn.textColor = .white
        pn.numberOfLines = 1
        pn.lineBreakMode = .byTruncatingTail
        return pn
    }()
    
    lazy var lblCity:UILabel = {
       let cn = UILabel()
        cn.font = .Fonts.label14.font
        cn.text = "CityName"
        cn.textColor = .white
        cn.numberOfLines = 1
        return cn
    }()
    
    private lazy var imgPinIcon:UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "location")
        img.contentMode = .scaleAspectFit
       return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(object:Place){
        let imageURL = URL(string: object.cover_image_url)!
        ImageHelper.shared.setImage(imageURL: imageURL, imageView: imgPlace)
        lblPlace.text = object.title
        lblCity.text = object.place
    }
    
    func setupViews() {
        
        self.backgroundColor = .clear
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        
        self.contentView.addSubviews(imgPlace, lblPlace, imgPinIcon, lblCity)

        setupLayout()
    }
    
    func setupLayout() {
        
        imgPlace.snp.makeConstraints({ img in
            img.center.equalToSuperview()
            img.height.equalTo(178)
            img.width.equalTo(278)
            
        })
        
        lblPlace.snp.makeConstraints({ lbl in
            lbl.bottom.equalTo(imgPlace.snp.bottom).inset(26)
            lbl.leading.equalTo(imgPlace.snp.leading).offset(16)
            lbl.trailing.equalTo(imgPlace.snp.trailing).inset(5)
            
        })
        
        imgPinIcon.snp.makeConstraints({ img in
            img.top.equalTo(lblPlace.snp.bottom)
            img.leading.equalTo(lblPlace.snp.leading)
            img.height.equalTo(12)
            img.width.equalTo(9)
            
        })
        
        lblCity.snp.makeConstraints({ lbl in
            lbl.leading.equalTo(imgPinIcon.snp.trailing).offset(6)
            lbl.bottom.equalTo(imgPinIcon.snp.bottom).offset(5.7)
            
        })
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct CustomCollectionViewCell_Preview: PreviewProvider {
    static var previews: some View{

        CustomCollectionViewCell().showPreview()
    }
}
#endif
