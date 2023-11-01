//
//  MapPlacesCellVC.swift
//  TravioApp
//
//  Created by web3406 on 11/1/23.
//
import UIKit
import SnapKit

class MapPlacesCellVC: UICollectionViewCell {
    
    var visitCellViewModel: VisitCellViewModel? {
        didSet {
            placeName.text = visitCellViewModel?.placeName
            cityName.text = visitCellViewModel?.city
        }
    }
    
    private lazy var cellView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var placeName: UILabel = {
        let pn = UILabel()
        pn.textColor = .blue
        pn.font = UIFont(name: "Poppins-Bold", size: 24)
        pn.text = "PlaceName"
        pn.numberOfLines = 1
        return pn
    }()
    
    lazy var cityName: UILabel = {
        let cn = UILabel()
        cn.textColor = .white
        cn.font = UIFont(name: "Poppins-Regular", size: 14)
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
        img.contentMode = .scaleToFill
        
        let tappedGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        img.addGestureRecognizer(tappedGesture)
        img.isUserInteractionEnabled = true
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
    
    @objc func imageTapped() {
        // Detay sayfası açılır
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
            make.trailing.equalToSuperview().offset(-18)
            make.leading.equalToSuperview().offset(18)
        }
         imageLocation.snp.makeConstraints { make in
            make.top.equalTo(cellView)
            make.bottom.equalTo(cellView)
            make.trailing.equalTo(cellView)
            make.leading.equalTo(cellView)
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
