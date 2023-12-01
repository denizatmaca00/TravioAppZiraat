//
//  CustomTextField.swift
//  TravioApp
//
//  Created by web3406 on 11/28/23.
//
import UIKit
import TinyConstraints

class AppTextField: UIView {

    enum IconPosition {
        case left
        case right
        case none
    }

    private var isPasswordVisible = false

    private var title: String?
    private var placeholder: String?
    private var icon: UIImage?
    private var iconPosition: IconPosition

    private lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = title
        lbl.textColor = .black
        lbl.font = .Fonts.textFieldTitle.font
        return lbl
    }()

    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.font = .Fonts.textFieldText.font
        tf.textColor = UIColor(named: "textColor")
        tf.placeholder = placeholder
        tf.leftViewMode = .always
        tf.rightViewMode = .always
        tf.layer.cornerRadius = 16
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.shadowRadius = 20
        tf.layer.shadowOpacity = 0.15
        return tf
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = icon
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(iconTapped)))
        return imageView
        }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.layer.cornerRadius = 16
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.layer.shadowRadius = 20
        stackView.layer.shadowOpacity = 0.15
        stackView.backgroundColor = .white
        return stackView
    }()

    @objc private func iconTapped() {
        if iconPosition != .none && (icon == UIImage(systemName: "eye.fill") || icon == UIImage(systemName: "eye.slash.fill")) {
            isPasswordVisible.toggle()
            textField.isSecureTextEntry = !isPasswordVisible
            icon = isPasswordVisible ? UIImage(systemName: "eye.fill") : UIImage(systemName: "eye.slash.fill")
            iconImageView.image = icon
        }
    }

    
    init(title: String?, placeholder: String?, icon: UIImage?, iconPosition: IconPosition) {
        self.title = title
        self.placeholder = placeholder
        self.icon = icon
        self.iconPosition = iconPosition
        super.init(frame: .zero)
        setupViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        if iconPosition != .none {
            if iconPosition == .left {
                textField.leftView = iconImageView
            } else {
                textField.rightView = iconImageView
            }
        }

        stackView.addArrangedSubviews(titleLbl, textField)
        addSubview(stackView)
        setupLayout()
    }

    func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(74)
        }

        titleLbl.snp.makeConstraints { lbl in
            lbl.top.equalTo(stackView).offset(8)
            lbl.leading.equalToSuperview().offset(12)
        }

        textField.snp.makeConstraints { tf in
            tf.top.equalTo(titleLbl.snp.bottom).offset(2)
            tf.trailing.equalToSuperview().inset(10)
        }

        if iconPosition != .none {
            iconImageView.snp.makeConstraints { iv in
                iv.width.equalTo(20)
                iv.height.equalTo(20)
            }
        }
    }
}
