//
//  AppTextField.swift
//  TravioApp
//
//  Created by web3406 on 10/25/23.
//

import UIKit

class SecurityLabel: UIView{
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
}

class AppTextField: UIView {

    enum UserData {
        case email
        case password
        case username
        case passwordConfirm
        case presentMapTitle
        case presentMapDescription
        case presentMapLocation
        case fullname
        
        var title: String {
            switch self {
            case .email:
                return "Email"
            case .password:
                return "Password"
            case .username:
                return "Username"
            case .passwordConfirm:
                return "Password Confirm"
            case .presentMapTitle:
                return "Place Name"
            case .presentMapDescription:
                return "Visit Description"
            case .presentMapLocation:
                return "Country, City"
            case .fullname:
                return "Full Name"
            }
        }
        
        var placeholder: String {
            switch self {
            case .email:
                return "bilgeadam@gmail.com"
            case .password:
                return "*******"
            case .username:
                return "bilge_adam"
            case .passwordConfirm:
                return "*******"
            case .presentMapTitle:
                return "Plase write a place name"
            case .presentMapDescription:
                return "Lorem ipsum..."
            case .presentMapLocation:
                return "Location"
            case .fullname:
                return "Bilge Adam"
            }
        }
    }
    
    private var data: UserData?

    private lazy var titleLbl: UILabel = {
        let loginTitleLbl = UILabel()
        loginTitleLbl.text = data?.title
        loginTitleLbl.textColor = .black
        loginTitleLbl.font = UIFont(name: "Poppins-Medium", size: 14)
        return loginTitleLbl
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "Poppins-Regular", size: 12)
        textField.placeholder = data?.placeholder
        return textField
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.layer.cornerRadius = 16
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.layer.shadowRadius = 20
        stackView.layer.shadowOpacity = 0.15
        stackView.backgroundColor = UIColor(named: "textColorReversed")
        return stackView
    }()

//    public func getLoginTextFieldText() -> String? {
//        return loginTextField.text
//   }
    public func getTFAsObject()->UITextField{
        return textField
    }

    init(data: UserData) {
        super.init(frame: .zero)
        self.data = data
        setupViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
 
        stackView.addArrangedSubview(titleLbl)
        stackView.addArrangedSubview(textField)
        
        addSubview(stackView)
        setupLayout()
        
    }
    
    func setupLayout(){
        stackView.snp.makeConstraints ({ stack in
            stack.edges.equalToSuperview()
            stack.height.equalTo(74)
        })
        titleLbl.snp.makeConstraints({ lbl in
            lbl.top.equalTo(stackView).offset(8)
            lbl.leading.equalToSuperview().offset(12)
        })
        textField.snp.makeConstraints({tf in
            tf.top.equalTo(titleLbl.snp.bottom).offset(8)
        })
    }
}
