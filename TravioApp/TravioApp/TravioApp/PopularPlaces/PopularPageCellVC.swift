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

class PopularPageCellVC: UICollectionViewCell {
    
    private lazy var popularView: UIView = {
        let pv = UIView()
        pv.layer.cornerRadius = 10
        pv.backgroundColor = .green
        return pv
    }()
    
    private lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "sultanahmet")
        img.layer.cornerRadius = 16
        img.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
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
    
    public func configure(data:VisitCellViewModel){
        country.text = data.placeName
        title.text = data.city
        ImageHelper().setImage(imageURL: data.image, imageView: imageView)
    }

    func setupViews() {
        self.contentView.addSubview(popularView)
        popularView.addSubviews(imageView,title,country,icon)
        setupLayout()
    }
    
    func setupLayout() {
        
        popularView.height(89)
        popularView.width(342)
        popularView.leadingToSuperview(offset:20)
        popularView.topToSuperview(offset:20)
        
        imageView.heightToSuperview()
        imageView.width(90)
        imageView.leadingToSuperview()
        imageView.topToSuperview()
     
        title.top(to: popularView,offset: 20)
        title.leadingToTrailing(of: imageView, offset: 6)
        title.width(to: popularView)
        
        icon.height(12)
        icon.width(9)
        icon.topToBottom(of: title, offset: 3)
        icon.bottom(to: popularView, offset: -22)
        icon.leading(to: title)
        
        country.top(to: icon, offset: -3)
        country.leadingToTrailing(of: icon, offset: 6)
        country.width(to: popularView)
        
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct PopularPageCellVC_Preview: PreviewProvider {
    static var previews: some View{
         
        PopularPageCellVC().showPreview()
    }
}
#endif
