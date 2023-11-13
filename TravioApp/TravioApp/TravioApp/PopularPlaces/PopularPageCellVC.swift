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
    private lazy var PopularView: UIView = {
        let pv = UIView()
        pv.layer.cornerRadius = 10
        pv.backgroundColor = .white
        return pv
    }()
    private lazy var Image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "sultanahmet")
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
    
    public func configure(object:VisitCellViewModel){
        
        
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
        Image.leading(to: PopularView, offset: 26)
     
        
        title.height(36)
        title.width(131)
        title.top(to: PopularView,offset: 20)
        title.leadingToTrailing(of: Image, offset: 35)
        
        icon.height(10)
        icon.width(10)
        icon.top(to: title,offset: 30)
        icon.leading(to: title)
        
        country.height(20)
        country.width(46)
        country.top(to: title, offset: 25)
        country.leadingToTrailing(of: icon, offset: 5)
        
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
