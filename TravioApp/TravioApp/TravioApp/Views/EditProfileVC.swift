//
//  EditProfileVC.swift
//  TravioApp
//
//  Created by web3406 on 11/6/23.
//
// TODO: Labellar için bir UIEelements yazılablir +
// TODO: labelheader uılabel sınıfı
// TODO: leftBarItem bir tane yazılıp her yerden çekilebilir
// TODO: contentViewBig her sayfada kullnaılıyor onu da düzenlemek lazım +
// TODO: color enumı eklenebilir
import UIKit

class EditProfileVC: UIViewController {
    
    private lazy var viewUsername = AppTextField(data: .username)
    private lazy var viewMail = AppTextField(data: .email)
    private lazy var txtUsername = viewUsername.getTFAsObject()
    private lazy var txtEmail = viewMail.getTFAsObject()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogo")
        return imageView
    }()
    private lazy var changePhotoButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Change Photo", for: .normal)
        btn.setTitleColor(UIColor(named: "editProfileColor"), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 12)
        //btn.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var labelName: UILabel = {
        let lbl = UILabel()
        lbl.text = "Bruce Wills"
        lbl.textColor = UIColor(named: "settingsLabelColor")
        lbl.font = UIFont(name: "Poppins-Medium", size: 24)
        return lbl
    }()
    
    private lazy var labelDate = AppLabel(icon: UIImage(named: "signature"), text: "30 Ağustos 2023", alignment: .left)
    private lazy var labelRole = AppLabel(icon: UIImage(named: "role"), text: "Admin", alignment: .left)

    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Edit Profile"
        lbl.textColor = .white
        lbl.font = UIFont(name: "Poppins-Medium", size: 32)
        return lbl
    }()
    private lazy var exitButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "exit"), for: .normal)
        btn.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var contentViewBig: AppView = {
            let view = AppView()
            return view
        }()
    private lazy var stackViewMain: UIStackView = {
        let stackViews = UIStackView()
        stackViews.backgroundColor = UIColor(named: "viewBackgroundColor")
        stackViews.axis = .vertical
        stackViews.spacing = 24
        return stackViews
    }()
    private lazy var saveButton: UIButton = {
        let signUpButton = AppButton()
        signUpButton.setTitle("Save", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        signUpButton.backgroundColor = UIColor(named: "backgroundColor")
        signUpButton.layer.cornerRadius = 12
        //signUpButton.addTarget(self, action: #selector(signUpUser), for: .touchUpInside)
        signUpButton.isEnabled = false
        return signUpButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    @objc func exitButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.addSubviews(contentViewBig, titleLabel, exitButton)
        contentViewBig.addSubviews(imageView, changePhotoButton, labelName,labelDate, labelRole, stackViewMain, saveButton)
        stackViewMain.addArrangedSubviews(viewUsername, viewMail)
        setupLayout()
    }
    
    func setupLayout() {
        let limits = self.view.safeAreaLayoutGuide.snp
        
        titleLabel.snp.makeConstraints({ lbl in
            lbl.top.equalToSuperview().offset(60)
            lbl.leading.equalToSuperview().offset(20)
        })
        exitButton.snp.makeConstraints({ btn in
            btn.centerY.equalTo(titleLabel)
            btn.trailing.equalToSuperview().offset(-24)
            btn.height.width.equalTo(20)
        })
        imageView.snp.makeConstraints({ img in
            img.top.equalTo(contentViewBig).offset(24)
            img.leading.equalTo(contentViewBig).offset(135)
            img.trailing.equalTo(contentViewBig).offset(-135)
            img.height.equalTo(120)
        })
        changePhotoButton.snp.makeConstraints({ btn in
            btn.top.equalTo(imageView.snp.bottom).offset(7)
            btn.centerX.equalToSuperview()
        })
        
        labelName.snp.makeConstraints({ lbl in
            lbl.top.equalTo(changePhotoButton.snp.bottom).offset(7)
            lbl.centerX.equalToSuperview()
        })
        
        labelDate.snp.makeConstraints({ lbl in
            lbl.top.equalTo(labelName.snp.bottom).offset(39)
            lbl.leading.equalToSuperview().offset(24)
        })

        labelRole.snp.makeConstraints({lbl in
            lbl.top.equalTo(labelName.snp.bottom).offset(39)
            lbl.leading.equalTo(labelDate.viewWithBorder.snp.trailing).offset(16)
        })

        contentViewBig.snp.makeConstraints ({ view in
            view.height.equalToSuperview().multipliedBy(0.8)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        })
        
        stackViewMain.snp.makeConstraints ({ stack in
            stack.leading.equalToSuperview().offset(24)
            stack.trailing.equalToSuperview().offset(-24)
            stack.top.equalTo(labelName.snp.bottom).offset(92)
        })
        saveButton.snp.makeConstraints({ btn in
            btn.bottom.equalTo(limits.bottom).offset(-23)
            btn.trailing.equalToSuperview().offset(-24)
            btn.leading.equalToSuperview().offset(24)
            btn.height.equalTo(54)
            
        })
        
    }
    
}
#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct EditProfileVC_Preview: PreviewProvider {
    static var previews: some View{
        
        EditProfileVC().showPreview().ignoresSafeArea(.all)
    }
}
#endif
