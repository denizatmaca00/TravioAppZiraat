//
//  AppToggleSwitch.swift
//  TravioApp
//
//  Created by Ece Poyraz on 14.11.2023.
//
import UIKit
import TinyConstraints

class AppToggleSwitch: UIView{
    enum PrivacyData {
        case camera
        case libraryPhoto
        case Location
        
        var text: String {
            switch self {
            case .camera:
                return "Camera"
            case .libraryPhoto:
                return "Photo Library"
            case .Location:
                return "Location"
            }
        }
    }
    private var dataPrivacy: PrivacyData?
    
    private lazy var titleLbl: UILabel = {
        let loginTitleLbl = UILabel()
        loginTitleLbl.text = dataPrivacy?.text
        loginTitleLbl.textColor = .black
        loginTitleLbl.font = .Fonts.textFieldTitle.font
        return loginTitleLbl
    }()

    lazy var toggleSwitch: UISwitch = {
        let sw = UISwitch()
        return sw
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.layer.cornerRadius = 16
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.layer.shadowRadius = 20
        stackView.layer.shadowOpacity = 0.15
        stackView.backgroundColor = UIColor(named: "textColorReversed")
        
        return stackView
    }()

    init(data: PrivacyData) {
        super.init(frame: .zero)
        self.dataPrivacy = data
        setupViews()
    }
    

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
 
        stackView.addArrangedSubview(titleLbl)
        stackView.addArrangedSubview(toggleSwitch)

        addSubview(stackView)
        setupLayout()
        
    }
    
    func setupLayout(){
        stackView.edgesToSuperview()
        stackView.height(74)
        
        titleLbl.height(21)
        titleLbl.leadingToSuperview(offset:10)
        
        toggleSwitch.width(61)
    }
}
