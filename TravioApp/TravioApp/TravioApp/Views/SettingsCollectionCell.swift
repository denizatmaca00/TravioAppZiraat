//
//  SettingsCollectionCell.swift
//  TravioApp
//
//  Created by web3406 on 11/2/23.
//


import UIKit
struct SettingsCell{
    var iconName: String
    var label: String
    var iconArrow: String
}

class SettingsCollectionCell: UITableViewCell {
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var iconView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    private lazy var iconArrow: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    private lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "settingsLabelColor")
        lbl.font = .Fonts.label14.font
        return lbl
    }()
  
    
    func configure(data: SettingsCell) {
        iconView.image = UIImage(named: data.iconName)
        label.text = data.label
        iconArrow.image = UIImage(named: data.iconArrow)
    }
    
    func setupViews() {
        addSubview(backView)
       // backView.addSubview(stackView)
        backView.addSubviews(iconView, label, iconArrow)
        setupLayout()
    }
    
    func setupLayout() {
        backView.snp.makeConstraints { (make) in
           // make.edges.equalToSuperview()
            make.height.equalTo(54)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(backView)
            make.leading.equalTo(backView).offset(8)
            make.width.height.equalTo(20)
        }
        
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(backView)
            make.leading.equalTo(iconView.snp.trailing).offset(8)
            make.trailing.equalTo(iconArrow).offset(-8)
        }
        iconArrow.snp.makeConstraints({ icon in
            icon.centerY.equalTo(iconView)
            icon.trailing.equalTo(backView).offset(-17)
            icon.width.equalTo(10.5)
            icon.height.equalTo(15.5)
        })
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct SettingsCollectionCell_Preview: PreviewProvider {
    static var previews: some View{

        SettingsCollectionCell().showPreview()
    }
}
#endif
