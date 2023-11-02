//
//  SettingsCollectionCell.swift
//  TravioApp
//
//  Created by web3406 on 11/2/23.
//

import UIKit
struct SettingsCell{
    var iconName: UIImage
    var label: UILabel
}

class SettingsCollectionCell: UITableViewCell {
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.frame.size = CGSize(width: frame.width, height: frame.height)
        return view
    }()
    
    private lazy var iconView: UIImageView = {
        let icon = UIImageView()
          icon.contentMode = .scaleAspectFit
        return icon
    }()
    private lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        return lbl
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 8
        return sv
    }()
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func setupViews(){
        addSubviews(backView)
        backView.addSubviews(iconView, label, iconView)
        setupLayout()
    }
    
    func setupLayout(){
        stackView.snp.makeConstraints({sv in
            sv.centerY.equalToSuperview()
            sv.left.right.equalToSuperview().inset(16)
        })
    }
    
    
    
    
    
}
