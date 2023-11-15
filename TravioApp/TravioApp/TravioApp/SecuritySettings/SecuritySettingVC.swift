//
//  
//  SecuritySettingVCVC.swift
//  TravioApp
//
//  Created by Ece Poyraz on 3.11.2023.
//
//
import UIKit
import TinyConstraints
import SnapKit

class SecuritySettingVC: UIViewController, UIScrollViewDelegate {
    
    
var viewModel = SecuritySettingsVM()
    //background color
    private lazy var uıView: AppView = {
        let uv = AppView()
        return uv
    }()
    //background color
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "backgroundColor")
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner]
        return view
    }()

    //Security Settings
    private lazy var mainTitle:UILabel = {
        let title = UILabel()
        title.text = "Security Settings"
        title.font = .Fonts.pageHeader32.font
        title.textColor = .white
        return title
    }()
    
    private lazy var backButton:UIButton = {
        let bck = UIButton()
        bck.setImage(UIImage(named: "bckBtnSecuritySetting"), for: .normal)
        bck.addTarget(self, action: #selector(backPage), for: .touchUpInside )
        return bck
    }()
    
    private lazy var changePasswordTitle:UILabel = {
        let cptxt = UILabel()
        cptxt.text = "Change Password"
        cptxt.font = .Fonts.cityText16.font
        cptxt.textColor = UIColor(named: "backgroundColor")
        return cptxt
    }()
    private lazy var privacyTitle:UILabel = {
        let cptxt = UILabel()
        cptxt.text = "Privacy"
        cptxt.font = .Fonts.cityText16.font
        //cptxt.layer.backgroundColor = UIColor.blue.cgColor
        cptxt.textColor = UIColor(named: "backgroundColor")
       // cptxt.layer.backgroundColor = UIColor.red.cgColor
        //cptxt.textColor = .red
        return cptxt
    }()

    private lazy var passwordTextField = AppTextField(data: .placeHolderEmpty)
    private lazy var confirmPassword = AppTextField(data: .passwordConfirmEmpty)
    private lazy var camera = AppToggleSwitch(data: .camera)
    private lazy var photoLibrary = AppToggleSwitch(data: .libraryPhoto)
    private lazy var location = AppToggleSwitch(data: .Location)
    private lazy var saveButon: UIButton = {
        let s = AppButton()
            s.setTitle("Sign Up", for: .normal)
            s.isEnabled = true
        s.addTarget(self, action: #selector(updatePassword), for: .touchUpInside)
            return s
        }()
    private lazy var passwordGet = passwordTextField.getTFAsObject()
    private lazy var passwordConfirM = confirmPassword.getTFAsObject()
    //scroll view
    private lazy var scrollView:UIScrollView = {
       let sw = UIScrollView()
        sw.isScrollEnabled = true
        sw.showsVerticalScrollIndicator = true
       
        return sw
    }()
    
    //stackview1
    private lazy var stackViewPasswordChange: UIStackView = {
        let svp = UIStackView()
        svp.backgroundColor = UIColor(named: "viewBackgroundColor")
        svp.axis = .vertical
        svp.spacing = 22
        svp.alignment = .fill
        svp.distribution = .fill
        return svp
    }()
    
    //stackview2
    private lazy var stackViewPrivacy: UIStackView = {
        let sp = UIStackView()
        sp.backgroundColor = UIColor(named: "viewBackgroundColor")
        sp.axis = .vertical
        sp.spacing = 22
        sp.alignment = .fill
        sp.distribution = .fill
        return sp
    }()
    @objc func updatePassword(){
        //burada put network tetikle.
        //burada textfieldden gelen texti burada password olarak ver.
        var passwordText = passwordGet.text
        var confirmText = passwordConfirM.text
        if passwordText == confirmText {
            viewModel.putPassword(password: Password(new_password: passwordText))
        }
    }
    @objc func backPage(){
        let hvc = SettingsVC()
        navigationController?.pushViewController(hvc, animated: true)
     }

    override func viewDidLoad() {
        super.viewDidLoad()
       // viewBack.isHidden = false
       setupViews()
       
    }

    func setupViews() {
        // Add here the setup for the UI
       // self.view.backgroundColor = UIColor(named: "viewBackgroundColor")
        //self.view.addSubviews()
        self.view.addSubview(backgroundView)
        self.view.addSubview(uıView)
        self.view.addSubview(mainTitle)
        self.view.addSubview(backButton)
        self.view.addSubview(changePasswordTitle)
        
        uıView.addSubview(stackViewPasswordChange)
        stackViewPasswordChange.addArrangedSubview(passwordTextField)
        stackViewPasswordChange.addArrangedSubview(confirmPassword)
        
        
        uıView.addSubview(scrollView)
        scrollView.addSubview(privacyTitle)
        scrollView.addSubview(stackViewPrivacy)
        scrollView.addSubview(saveButon)
        stackViewPrivacy.addArrangedSubview(camera)
        stackViewPrivacy.addArrangedSubview(photoLibrary)
        stackViewPrivacy.addArrangedSubview(location)
        setupLayout()
    }
    
    func setupLayout() {
        backgroundView.edgesToSuperview()
        uıView.top(to: backgroundView, offset: 150)
        //uıView.edgesToSuperview(excluding: .bottom)
        //uıView.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        //uıView.height(800)
        uıView.leadingToSuperview()
        uıView.trailingToSuperview()
        uıView.snp.makeConstraints({ uı in
            uı.bottom.equalToSuperview()
            
        })
        //security setting
        mainTitle.topToSuperview(offset:70)
        mainTitle.height(48)
        mainTitle.trailingToSuperview()
        mainTitle.leadingToTrailing(of: backButton, offset: 24)

        //backbtn
        backButton.centerY(to: mainTitle)
        backButton.height(40)
        backButton.height(40)
        backButton.leadingToSuperview(offset:20)
        

        //changed password title
        changePasswordTitle.top(to: uıView, offset: 44)
        changePasswordTitle.height(20)
        changePasswordTitle.width(236)
        changePasswordTitle.leadingToSuperview(offset:24)
        
        
        stackViewPasswordChange.leadingToSuperview(offset:20)
        stackViewPasswordChange.trailingToSuperview(offset:20)
        stackViewPasswordChange.topToBottom(of: changePasswordTitle,offset: 20)
        stackViewPasswordChange.height(170)
        
        stackViewPasswordChange.addArrangedSubview(passwordTextField)
        stackViewPasswordChange.addArrangedSubview(confirmPassword)

        
        scrollView.leadingToSuperview()
        scrollView.trailingToSuperview()
        scrollView.topToBottom(of: stackViewPasswordChange, offset: 10)
        scrollView.bottomToSuperview()

        
        privacyTitle.height(20)
        privacyTitle.trailing(to: stackViewPrivacy)
        privacyTitle.leading(to: stackViewPrivacy)
        privacyTitle.topToSuperview(offset:20)

        stackViewPrivacy.trailing(to: stackViewPasswordChange)
        stackViewPrivacy.topToBottom(of: privacyTitle,offset: 10)
        stackViewPrivacy.height(266)
        stackViewPrivacy.leadingToSuperview(offset:20)

        saveButon.topToBottom(of: stackViewPrivacy, offset: 50)
        saveButon.height(54)
        saveButon.trailing(to: stackViewPrivacy)
        saveButon.leading(to: stackViewPrivacy)
        //saveButon.bottomToSuperview(offset: 20)
        saveButon.snp.makeConstraints({s in
            s.bottom.equalToSuperview().offset(-30)
        })
    }
  
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct SecuritySettingVC_Preview: PreviewProvider {
    static var previews: some View{
         
        SecuritySettingVC().showPreview()
    }
}
#endif


//        stackViewPrivacy.leadingToSuperview()
//        stackViewPrivacy.trailingToSuperview()
//        saveButon.snp.makeConstraints({ btn in
//            btn.top.equalTo(stackViewPrivacy.snp.bottom).offset(50)
//            btn.width.equalTo(342)
//            btn.height.equalTo(54)
//            btn.bottom.equalToSuperview().offset(-10)
//
//        })
       // saveButon.leading(to: stackViewPrivacy)
//        saveButon.trailingToSuperview(offset:24)
//        saveButon.leadingToSuperview(offset:24)
      
 
