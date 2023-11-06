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
    
    var visitCellViewModel : VisitCellViewModel?{
        didSet{
            placeName.text = visitCellViewModel?.placeName
            cityName.text = visitCellViewModel?.city
        }
    }
    
    lazy var placeName:UILabel = {
       let pn = UILabel()
        pn.textColor = .blue
        pn.font = UIFont(name: "Poppins-Bold", size: 30)
        pn.text = "PlaceName"
        pn.textColor = .white
        pn.numberOfLines = 1
        return pn
    }()
    
    lazy var cityName:UILabel = {
       let cn = UILabel()
        cn.textColor = .white
        cn.font = UIFont(name: "Poppins-Regular", size: 16)
        cn.text = "CityName"
        cn.textColor = .white
        cn.numberOfLines = 1
        return cn
    }()
    
    private lazy var iconLocation:UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "location")
        img.contentMode = .scaleAspectFit
       return img
    }()
    
    private lazy var imageLocation:UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "sultanahmet")
        img.contentMode = .scaleToFill
        return img
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
        imageLocation.image = data.image
    }
    func setupViews() {

        self.contentView.addSubviews(imageLocation,placeName,iconLocation,cityName)
        setupLayout()
    }
    
    func setupLayout() {
        
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

@available(iOS 13, *)
struct CustomVisitCellVC_Preview: PreviewProvider {
    static var previews: some View{

        CustomVisitCellVC().showPreview()
    }
}
#endif
