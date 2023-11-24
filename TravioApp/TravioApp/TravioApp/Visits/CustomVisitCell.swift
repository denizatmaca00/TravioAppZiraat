//
//
//  CustomVisitCell.swift
//  TravioApp
//
//  Created by Ece Poyraz on 26.10.2023.
//
//

import UIKit
import TinyConstraints

class CustomVisitCell: UITableViewCell {
    
    static let reuseIdentifier: String = "visitCell"
    
    var visitCellViewModel : VisitCellViewModel?{
        didSet{
            placeName.text = visitCellViewModel?.placeName
            cityName.text = visitCellViewModel?.city
        }
    }
    
    lazy var placeName:UILabel = {
        let pn = UILabel()
        pn.textColor = .white
        pn.font = .Fonts.title30.font
        pn.text = "PlaceName"
        pn.textColor = .white
        pn.numberOfLines = 1
        pn.lineBreakMode = .byTruncatingTail

        return pn
    }()
    
    lazy var cityName:UILabel = {
        let cn = UILabel()
        cn.textColor = .white
        cn.font = .Fonts.cityText16.font
        cn.text = "CityName"
        cn.textColor = .white
        cn.numberOfLines = 1
        return cn
    }()
    
    private lazy var iconLocation:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "location")
        return img
    }()
    
    private lazy var imageLocation:UIImageView = {
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 344, height: 219))
        imageView.image = UIImage(named: "sultanahmet")
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data:VisitCellViewModel){
        placeName.text = data.placeName
        cityName.text = data.city
        ImageHelper().setImage(imageURL: data.image, imageView: imageLocation)
        
    }
    
    func setupViews() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.15
        
        self.contentView.addSubviews(imageLocation, placeName,iconLocation,cityName)
        setupLayout()
    }
    
    func setupLayout() {
        
        imageLocation.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(16)
            img.bottom.equalToSuperview()
            img.leading.equalToSuperview().offset(24)
            img.trailing.equalToSuperview().inset(24)
            
        })
        
        placeName.leading(to: imageLocation, offset: 8)
        placeName.trailing(to: imageLocation, offset: -5)
        placeName.topToSuperview(offset:142)
        placeName.height(45)
        
        iconLocation.topToBottom(of: placeName, offset:2)
        iconLocation.leading(to: placeName)
        iconLocation.height(20)
        iconLocation.width(15)
        
        cityName.leadingToTrailing(of: iconLocation,offset:6)
        cityName.centerY(to: iconLocation)
        cityName.height(24)
        
        imageLocation.centerXToSuperview()
        
    }
}

#if DEBUG
import SwiftUI
import Kingfisher

@available(iOS 13, *)
struct CustomVisitCellVC_Preview: PreviewProvider {
    static var previews: some View{
        
        CustomVisitCell().showPreview()
    }
}
#endif
