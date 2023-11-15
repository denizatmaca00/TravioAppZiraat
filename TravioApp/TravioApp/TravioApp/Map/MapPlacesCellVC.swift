//
//  MapPlacesCellVC.swift
//  TravioApp
//
//  Created by web3406 on 11/1/23.
//
import UIKit
import SnapKit



class MapPlacesCellVC: UICollectionViewCell {
    
    
    var viewModel = MapVM()
    
    var visitCellViewModel: VisitCellViewModel? {
        didSet {
            placeName.text = visitCellViewModel?.placeName
            cityName.text = visitCellViewModel?.city
            ImageHelper().setImage(imageURL: visitCellViewModel!.image, imageView: imageLocation)

        }
    }
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 16
        return view
    }()
    
      lazy var placeName: UILabel = {
        let pn = UILabel()
        pn.textColor = .white
        pn.font = .Fonts.header24.font
        pn.text = "PlaceName"
        pn.numberOfLines = 1
        return pn
    }()
    
    lazy var cityName: UILabel = {
        let cn = UILabel()
        cn.textColor = .white
        cn.font = .Fonts.label14.font
        cn.text = "CityName"
        cn.numberOfLines = 1
        return cn
    }()
    
    private lazy var iconLocation: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "location")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private lazy var imageLocation: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "sultanahmet")
        //img.contentMode = .scaleToFill
        img.isUserInteractionEnabled = true
        img.layer.cornerRadius = 16
        img.layer.masksToBounds = true
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubviews(cellView)
        cellView.addSubviews(imageLocation, placeName, iconLocation, cityName)
        
        setupLayout()
    }
    
    func setupLayout() {

        cellView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(178)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(18)
        }
         imageLocation.snp.makeConstraints { make in
             make.edges.equalTo(cellView)
        }
        
        placeName.snp.makeConstraints { make in
            make.leading.equalTo(cellView.snp.leading).inset(22)
            make.top.equalTo(cellView).offset(118)
            make.height.equalTo(24)
        }

        iconLocation.snp.makeConstraints { make in
            make.top.equalTo(placeName.snp.bottom).offset(2)
            make.leading.equalTo(placeName)
            make.height.equalTo(20)
            make.width.equalTo(15)
        }

        cityName.snp.makeConstraints { make in
            make.leading.equalTo(iconLocation.snp.trailing).offset(6)
            make.centerY.equalTo(iconLocation)
            make.height.equalTo(18)
        }
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct MapPlacesCellVC_Preview: PreviewProvider {
    static var previews: some View{

        MapPlacesCellVC().showPreview()
    }
}
#endif
