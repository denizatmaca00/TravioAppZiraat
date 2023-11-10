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

class SecuritySettingVC: UIViewController {
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
        cptxt.textColor = UIColor(named: "backgroundColor")
        return cptxt
    }()

    private lazy var passwordTextField = AppTextField(data: .placeHolderEmpty)
    private lazy var confirmPassword = AppTextField(data: .passwordConfirmEmpty)
    private lazy var camera = SecurityLabel(data: .camera)
    private lazy var photoLibrary = SecurityLabel(data: .libraryPhoto)
    private lazy var location = SecurityLabel(data: .Location)
    private lazy var saveButon: UIButton = {
        let s = AppButton()
            s.setTitle("Sign Up", for: .normal)
            s.isEnabled = true
            return s
        }()
    lazy var switchBtnfirst: UISwitch = {
        let sw = UISwitch()
        sw.height(31)
        sw.width(51)
        return sw
    }()
    lazy var switchBtnsecond: UISwitch = {
        let sw = UISwitch()
        sw.height(31)
        sw.width(51)
        return sw
    }()
    lazy var switchBtnthird: UISwitch = {
        let sw = UISwitch()
        sw.height(31)
        sw.width(51)
        return sw
    }()

    private lazy var stackViewPasswordChange: UIStackView = {
        let svp = UIStackView()
        svp.backgroundColor = UIColor(named: "viewBackgroundColor")
        svp.axis = .vertical
        svp.spacing = 22
        svp.alignment = .fill
        svp.distribution = .fill
        return svp
    }()
    private lazy var stackViewPrivacy: UIStackView = {
        let sp = UIStackView()
        sp.backgroundColor = UIColor(named: "viewBackgroundColor")
        sp.axis = .vertical
        sp.spacing = 22
        sp.alignment = .fill
        sp.distribution = .fill
        return sp
    }()
    
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
   
        stackViewPasswordChange.addArrangedSubview(passwordTextField)
        stackViewPasswordChange.addArrangedSubview(confirmPassword)
        self.view.addSubview(stackViewPasswordChange)
        
        self.view.addSubview(privacyTitle)
        
        stackViewPrivacy.addArrangedSubview(camera)
        camera.addSubview(switchBtnfirst)
        stackViewPrivacy.addArrangedSubview(photoLibrary)
        photoLibrary.addSubview(switchBtnsecond)
        stackViewPrivacy.addArrangedSubview(location)
        location.addSubview(switchBtnthird)
        self.view.addSubview(stackViewPrivacy)
        
        self.view.addSubview(saveButon)
     
        setupLayout()
    }
    
    func setupLayout() {
        backgroundView.edgesToSuperview()
        uıView.topToSuperview(offset:125)
        uıView.edgesToSuperview(excluding: .bottom,usingSafeArea: true)
        uıView.height(800)
        //security setting
        mainTitle.topToSuperview(offset:70)
        mainTitle.height(48)
        mainTitle.width(241)
        mainTitle.centerXToSuperview()
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
        
        privacyTitle.topToBottom(of: stackViewPasswordChange, offset: 10)
        privacyTitle.height(20)
        privacyTitle.width(236)
        privacyTitle.leading(to: changePasswordTitle)
        
        stackViewPrivacy.leadingToSuperview(offset:20)
        stackViewPrivacy.trailingToSuperview(offset:20)
        stackViewPrivacy.topToBottom(of: privacyTitle,offset: 20)
        stackViewPrivacy.height(266)
        
        switchBtnfirst.topToSuperview(offset:10, usingSafeArea: true)
        switchBtnfirst.trailingToSuperview(offset:20)
        
        switchBtnsecond.topToSuperview(offset:10, usingSafeArea: true)
        switchBtnsecond.trailingToSuperview(offset:20)
        
        switchBtnthird.topToSuperview(offset:10, usingSafeArea: true)
        switchBtnthird.trailingToSuperview(offset:20)
        
        saveButon.bottomToSuperview(offset:20,usingSafeArea: true)
        saveButon.height(54)
        saveButon.trailingToSuperview(offset:24)
        saveButon.leadingToSuperview(offset:24)
 
    
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
