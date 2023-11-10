//
//
//  CustomVisitCellVC.swift
//  TravioApp
//
//  Created by Ece Poyraz on 26.10.2023.
//
//
import UIKit
import TinyConstraints

class CustomVisitCellVC: UITableViewCell {
    
    static let reuseIdentifier: String = "visitCell"
    
    var visitCellViewModel : VisitCellViewModel?{
        didSet{
            placeName.text = visitCellViewModel?.placeName
            cityName.text = visitCellViewModel?.city
        }
    }
    
    lazy var placeName:UILabel = {
        let pn = UILabel()
        pn.textColor = .blue
        pn.font = .Fonts.title30.font
        pn.text = "PlaceName"
        pn.textColor = .white
        pn.numberOfLines = 1
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
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // used to adjust distance between cells
    private lazy var viewSeperator:UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 16))
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    @objc func imageTapped(){
    //     //detail page opens
    //        let vc = DetailPageVC()
    //
    //    }
    func configure(data:VisitCellViewModel){
        placeName.text = data.placeName
        cityName.text = data.city
        setImage(imageURL: data.image)
        //        imageLocation.kf.setImage(with: data.image) // old code to set image
    }
    
    func setImage(imageURL:URL){
        KingfisherManager.shared.retrieveImage(with: imageURL, options: nil, progressBlock: nil) { result in
            
            switch result{
            case .success(let value):
                self.imageLocation.image = value.image
            case .failure(_): //let error case
                print("image not found on: \(imageURL)")
                self.imageLocation.image = UIImage(systemName: "camera.metering.none")?
                    .withRenderingMode(.alwaysOriginal)
                    .withTintColor(.systemGray3)
                return
            }
        }
    }
    
    func setupViews() {
        
        self.contentView.addSubviews(imageLocation, placeName,iconLocation,cityName)
        setupLayout()
    }
    
    func setupLayout() {
        
        imageLocation.snp.makeConstraints({ img in
            img.top.equalToSuperview()
            img.leading.equalToSuperview().offset(24)
            img.trailing.equalToSuperview().inset(24)
            
        })
        
        // add seperator view between cells
        self.contentView.addSubview(viewSeperator)
        viewSeperator.snp.makeConstraints({ view in
            view.top.equalTo(imageLocation.snp.bottom)
            view.bottom.equalToSuperview()
            view.leading.equalTo(imageLocation)
            view.trailing.equalTo(imageLocation)
            view.height.equalTo(self.viewSeperator.frame.height)
            
        })
        
        placeName.leading(to: imageLocation, offset: 8)
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
    
    //    func setUserText(userPlaceText: String, userCountryText: String, img:String ) {
    //        placeName.text = userPlaceText
    //        cityName.text = userCountryText
    //        imageLocation.image = UIImage(systemName: img)
    //    }
    
}

#if DEBUG
import SwiftUI
import Kingfisher

@available(iOS 13, *)
struct CustomVisitCellVC_Preview: PreviewProvider {
    static var previews: some View{
        
        CustomVisitCellVC().showPreview()
    }
}
#endif
