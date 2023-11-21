//
//  
//  PopularPageCellVC.swift
//  TravioApp
//
//  Created by Ece Poyraz on 2.11.2023.
//
//
import UIKit
import TinyConstraints
import SnapKit
import Kingfisher

class SeeAllCellVC: UICollectionViewCell {
    private lazy var PopularView: UIView = {
        let pv = UIView()
        pv.layer.cornerRadius = 10
        pv.backgroundColor = .white
        return pv
    }()
    private lazy var Image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.layer.cornerRadius = 10
        img.image = UIImage(named: "sultanahmet")
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        return img
    }()
    private lazy var title:UILabel = {
        let t = UILabel()
        t.text = "Colleseum"
        t.font = .Fonts.header24.font
        return t
    }()
    private lazy var country: UILabel = {
        let c = UILabel()
        c.font = .Fonts.label14.font
        c.text = "Rome"
        return c
    }()
    private lazy var icon:UIImageView = {
        let i = UIImageView(image: UIImage(named: "popularpin"))
        return i
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(object:Place){
        title.text = object.title
        country.text = object.place
        if let url = URL(string: object.cover_image_url){
            Image.kf.setImage(with: url)
            }
    }
    

    func setupViews() {
        PopularView.addSubviews(Image,title,country,icon)
        self.contentView.addSubview(PopularView)
        setupLayout()
    }
    
    func setupLayout() {
        
        PopularView.height(100)
        PopularView.width(342)
        PopularView.leadingToSuperview(offset:20)
        PopularView.topToSuperview(offset:20)
        
        Image.heightToSuperview()
        Image.width(90)
        Image.topToSuperview()
        Image.leadingToSuperview()
     
        
        title.height(36)
        title.width(160)
        title.top(to: PopularView,offset: 20)
        title.leadingToTrailing(of: Image, offset: 35)
        
        icon.height(12)
        icon.width(9)
        icon.topToBottom(of: title, offset: 3)
        icon.leading(to: title)
        
        country.height(20)
        country.width(70)
        country.centerY(to: icon)
        country.leadingToTrailing(of: icon, offset: 5)
        
    }
  
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct PopularPageCellVC_Preview: PreviewProvider {
    static var previews: some View{
         
        SeeAllCellVC().showPreview()
    }
}
#endif
