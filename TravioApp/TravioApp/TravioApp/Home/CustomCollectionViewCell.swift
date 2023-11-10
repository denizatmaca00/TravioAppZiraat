//
//  CustomCollectionViewCell.swift
//  TravioApp
//
//  Created by Aydın Erol on 30.10.2023.
//

import UIKit
import SnapKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    var visitCellViewModel : VisitCellViewModel? {
        didSet{
            lblPlace.text = visitCellViewModel?.placeName
            lblCity.text = visitCellViewModel?.city
        }
    }
    
    private lazy var imgPlace:UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "sultanahmet")
        img.contentMode = .scaleToFill
     
        let tappedGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        img.addGestureRecognizer(tappedGesture)
        img.isUserInteractionEnabled = true
        return img
    }()
    
    lazy var lblPlace:UILabel = {
       let pn = UILabel()
        pn.textColor = .blue
        pn.font = .Fonts.header24.font
        pn.text = "PlaceName"
        pn.textColor = .white
        pn.numberOfLines = 1
        return pn
    }()
    
    lazy var lblCity:UILabel = {
       let cn = UILabel()
        cn.textColor = .white
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
    
    @objc func imageTapped(){
     //detail page opens
        print("tappedByGesture")
    }

    func configure(object:Place){
        imgPlace.image = UIImage(named: "sultanahmet")
        lblPlace.text = object.title
        lblCity.text = object.place
    }
    
    func setupViews() {
        
        self.isUserInteractionEnabled = true
        self.contentView.addSubviews(imgPlace, lblPlace, imgPinIcon, lblCity)

        setupLayout()
    }
    
    func setupLayout() {
        
        imgPlace.snp.makeConstraints({img in
            img.center.equalToSuperview()
            img.height.equalTo(178)
            img.width.equalTo(278)
            
        })
        
        lblPlace.snp.makeConstraints({ lbl in
            lbl.leading.equalTo(imgPlace.snp.leading).offset(16)
            lbl.bottom.equalTo(imgPlace.snp.bottom).offset(-26)
            
        })
        
        imgPinIcon.snp.makeConstraints({img in
            img.leading.equalTo(lblPlace.snp.leading)
            img.top.equalTo(lblPlace.snp.bottom).offset(3)
            img.bottom.equalTo(imgPlace.snp.bottom).offset(-11)
            
        })
        
        lblCity.snp.makeConstraints({ lbl in
            lbl.leading.equalTo(imgPlace.snp.leading).offset(31)
            lbl.top.equalTo(lblPlace.snp.bottom)
            lbl.bottom.equalTo(imgPlace.snp.bottom).offset(-5)
            
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
