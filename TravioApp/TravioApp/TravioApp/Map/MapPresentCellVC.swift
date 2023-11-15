//
//  MapPresentCellVC.swift
//  TravioApp
//
//  Created by web3406 on 11/10/23.
//

import UIKit

class MapPresentCellVC: UICollectionViewCell {

    var viewModel = MapVM()
 
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 269, height: 215))
        imageView.layer.cornerRadius = 16
        imageView.image = UIImage(named: "addPhoto")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var lblAddPhoto: UILabel = {
        let lbl = UILabel()
        lbl.text = "Add Photo"
        lbl.font = .Fonts.textFieldText.font
        lbl.textColor = .systemGray
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        
        self.contentView.addSubviews(imageView, lblAddPhoto)
        
        setupLayout()
    }
    
    func setupLayout() {

        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
        }
        lblAddPhoto.snp.makeConstraints({lbl in
            lbl.top.equalTo(imageView.snp.bottom)
            lbl.centerX.equalTo(imageView)
        })
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct MapPresentCellVC_Preview: PreviewProvider {
    static var previews: some View{

        MapPresentCellVC().showPreview()
    }
}
#endif
