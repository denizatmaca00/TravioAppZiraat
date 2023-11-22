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
        didSet {DispatchQueue.main.async { [self] in
            self.placeName.text = visitCellViewModel?.placeName
            self.cityName.text = visitCellViewModel?.city
            ImageHelper().setImage(imageURL: visitCellViewModel!.image, imageView: imageLocation)
        }
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
        pn.lineBreakMode = .byTruncatingTail
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
        
        cellView.snp.makeConstraints ({ make in
            make.centerX.equalToSuperview()
            make.height.equalTo(178)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(18)
        })
        imageLocation.snp.makeConstraints ({ make in
            make.edges.equalTo(cellView)
        })
        
        placeName.snp.makeConstraints ({ lbl in
            lbl.leading.equalTo(cellView.snp.leading).inset(22)
            lbl.trailing.equalTo(cellView.snp.trailing).offset(-5)
            lbl.top.equalTo(cellView).offset(118)
            lbl.height.equalTo(24)
            
        })
        
        iconLocation.snp.makeConstraints ({ icon in
            icon.top.equalTo(placeName.snp.bottom).offset(2)
            icon.leading.equalTo(placeName)
            icon.height.equalTo(20)
            icon.width.equalTo(15)
        })
        
        cityName.snp.makeConstraints ({ cn in
            cn.leading.equalTo(iconLocation.snp.trailing).offset(6)
            cn.trailing.equalTo(cellView).offset(-1)
            cn.centerY.equalTo(iconLocation)
            cn.height.equalTo(18)
        })
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
