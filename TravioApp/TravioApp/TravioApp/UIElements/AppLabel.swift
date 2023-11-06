//
//  AppLabel.swift
//  TravioApp
//
//  Created by web3406 on 11/2/23.
//

import UIKit

import SnapKit

import UIKit
import SnapKit

enum IconAlignment {
    case left
    case right
    case none
}

class AppLabel: UIView {
     lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "settingsLabelColor")
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     lazy var viewWithBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        return view
    }()

    init(icon: UIImage?, text: String, alignment: IconAlignment) {
        super.init(frame: .zero)

        var updatedAlignment = alignment

        if let icon = icon {
            iconImageView.image = icon
        } else {
            updatedAlignment = .none
        }

        textLabel.text = text

        viewWithBorder.backgroundColor = .white
        viewWithBorder.addSubview(iconImageView)
        viewWithBorder.addSubview(textLabel)
        addSubview(viewWithBorder)

        setupConstraints(updatedAlignment)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints(_ alignment: IconAlignment) {
        viewWithBorder.snp.makeConstraints { view in
            view.leading.equalToSuperview()
            view.centerY.equalToSuperview()
            view.height.equalTo(52)
            view.width.equalTo(163)
        }

        iconImageView.snp.makeConstraints { icon in
            icon.width.equalTo(20)
            icon.height.equalTo(20)
            icon.centerY.equalToSuperview()
            icon.leading.equalTo(viewWithBorder.snp.leading).offset(8)
        }

        textLabel.snp.makeConstraints { lbl in
            switch alignment {
            case .left:
                lbl.leading.equalTo(iconImageView.snp.trailing).offset(8)
                lbl.centerY.equalToSuperview()
            case .right:
                lbl.leading.equalToSuperview().offset(8)
                lbl.centerX.equalTo(viewWithBorder)
                lbl.centerY.equalToSuperview()
            case .none:
                lbl.leading.equalToSuperview().offset(8)
                lbl.trailing.equalToSuperview().inset(8)
                lbl.centerY.equalToSuperview()
            }
        }
    }
}
