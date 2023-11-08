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
    
    private lazy var backgroundColor: UIView = {
        let bgc = UIView()
        bgc.backgroundColor = UIColor(named: "backgroundColor")
        //bgc.clipsToBounds = true
        view.layer.cornerRadius = 80
        bgc.layer.maskedCorners = [.layerMinXMinYCorner]
        return bgc
    }()
    private lazy var viewBack: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "viewBackgroundColor")
        v.layer.cornerRadius = 50
        v.layer.maskedCorners = [.layerMinXMinYCorner]
        return v
    }()
    //Security Settings
    private lazy var mainTitle:UILabel = {
        let title = UILabel()
        title.text = "Security Settings"
        title.font = .Fonts.pageHeader32.font
        title.textColor = .white
        return title
    }()
    private lazy var bckButton: UIButton = {
       let bb = UIButton()
        bb.setImage(UIImage(named: "bckBtnSecuritySetting"), for: .normal)
        bb.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
       return bb
    }()
    private lazy var changePasswordTitle:UILabel = {
        let cptxt = UILabel()
        cptxt.text = "Change Password"
        cptxt.font = .Fonts.cityText16.font
        cptxt.textColor = UIColor(named: "backgroundColor")
        return cptxt
    }()
    private lazy var passwordTextField: UITextField = {
       let ptxt = UITextField()
        ptxt.placeholder = "New Password"
        ptxt.tintColor = .black
        ptxt.layer.borderColor = UIColor.gray.cgColor
        ptxt.layer.borderWidth = 2
        ptxt.backgroundColor = .white
        ptxt.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
        ptxt.layer.cornerRadius = 15
        return ptxt
    }()
    
    private lazy var pasconfirmTextField: UITextField = {
       let ptxt = UITextField()
        ptxt.placeholder = "New Password Confirm"
        ptxt.tintColor = .black
        ptxt.layer.borderColor = UIColor.gray.cgColor
        ptxt.backgroundColor = .white
        ptxt.layer.borderWidth = 2
        ptxt.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
        ptxt.layer.cornerRadius = 15
        //ptxt.layer.shadowOpacity = 0.5
        return ptxt
    }()
    private lazy var stackViewPopular: UIStackView = {
        let svp = UIStackView()
       // svp.backgroundColor = .white
        svp.axis = .vertical
        svp.spacing = 24
        return svp
    }()
//privacy
   // private lazy var deneme: SecurityLabel
    private lazy var stackViewPrivacy: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 24
        return s
    }()
    private lazy var privacyTextField:UILabel = {
        let ptxt = UILabel()
        ptxt.text = "Privacy"
        ptxt.font = .Fonts.cityText16.font
        ptxt.textColor = UIColor(named: "backgroundColor")
        return ptxt
    }()
    private lazy var viewCamera:UIView = {
        let v = UIView()
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor.gray.cgColor
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
        v.layer.cornerRadius = 15
        return v
    }()
    private lazy var textCamera:UILabel = {
        let t = UILabel()
        t.text =  "Camera"
        t.textColor = .black
        return t
    }()
    private lazy var switchCamera: UISwitch = {
       let s = UISwitch()
       return s
    }()
    //photolibrary
    private lazy var viewPhotoLibrary:UIView = {
        let v = UIView()
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor.gray.cgColor
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
        v.layer.cornerRadius = 15
        return v
    }()
    private lazy var textPhotoLibrary:UILabel = {
        let t = UILabel()
        t.text =  "Photo Library"
        t.textColor = .black
        return t
    }()
    private lazy var switchPhotoLibrary: UISwitch = {
       let s = UISwitch()
       return s
    }()
    //Location
    private lazy var viewLocation:UIView = {
        let v = UIView()
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor.gray.cgColor
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
        v.layer.cornerRadius = 15
        return v
    }()
    private lazy var textLocation:UILabel = {
        let t = UILabel()
        t.text =  "Location"
        t.textColor = .black
        return t
    }()
    private lazy var switchLocation: UISwitch = {
       let s = UISwitch()
       return s
    }()
    //SAVE BUTON
    private lazy var saveButton: UIButton = {
        let savebtn = AppButton()
        savebtn.setTitle("Save", for: .normal)
        return savebtn
    }()
    
    @objc func backBtnTapped(){
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.isHidden = false
       setupViews()
       
    }

    func setupViews() {
        // Add here the setup for the UI
       // self.view.backgroundColor = UIColor(named: "viewBackgroundColor")
        self.view.addSubviews()
        self.view.addSubview(backgroundColor)
        self.view.addSubview(viewBack)
        self.view.addSubview(bckButton)
        self.view.addSubview(mainTitle)
        viewBack.addSubviews(changePasswordTitle, stackViewPopular,stackViewPrivacy)
        stackViewPopular.addArrangedSubviews(passwordTextField,pasconfirmTextField)
        self.view.addSubview(privacyTextField)
     
        
        //stackview2
        stackViewPrivacy.addArrangedSubviews(viewCamera,viewPhotoLibrary,viewLocation)
        self.view.addSubview(viewCamera)
        viewCamera.addSubviews(textCamera,switchCamera)
        viewPhotoLibrary.addSubviews(textPhotoLibrary,switchPhotoLibrary)
        viewLocation.addSubviews(textLocation,switchLocation)
        self.view.addSubview(saveButton)
        
        
      
        
        setupLayout()
    }
    
    func setupLayout() {
        // Add here the setup for layout
        bckButton.height(40)
        bckButton.width(40)
        //bckButton.centerY(to: mainTitle)
        bckButton.topToSuperview(offset:60)
        
        mainTitle.height(40)
        mainTitle.width(275)
        mainTitle.leadingToSuperview(offset:72)
        mainTitle.centerY(to: bckButton)
    
        viewBack.topToSuperview(offset:150)
        viewBack.edgesToSuperview(excluding: .bottom,usingSafeArea: true)
        viewBack.height(800)
        
        backgroundColor.edgesToSuperview()
     //changed password
        changePasswordTitle.topToSuperview(offset:44)
        changePasswordTitle.height(40)
        changePasswordTitle.width(200)
        changePasswordTitle.leadingToSuperview(offset:24)
        
        passwordTextField.topToBottom(of: changePasswordTitle,offset: 8)
        passwordTextField.leading(to: changePasswordTitle)
        passwordTextField.height(74)
      
        pasconfirmTextField.height(74)
       
        stackViewPopular.topToSuperview(offset: 24)
        stackViewPopular.leadingToSuperview(offset: 24)
        stackViewPopular.trailingToSuperview(offset:24)
       //privacy
        privacyTextField.height(40)
        privacyTextField.topToBottom(of: stackViewPopular, offset: 24)
        privacyTextField.width(200)
        privacyTextField.leading(to: changePasswordTitle)
    
       /////Camera
        viewCamera.height(74)
        viewCamera.trailing(to: stackViewPopular)
        viewCamera.topToBottom(of: privacyTextField,offset: 8)
        viewCamera.leading(to: stackViewPopular)
        
        textCamera.height(30)
        textCamera.width(60)
        textCamera.topToSuperview(offset:5)
        textCamera.leadingToSuperview(offset:5)
        textCamera.centerY(to: viewCamera)
        
        switchCamera.height(20)
        switchCamera.width(50)
        switchCamera.trailingToSuperview(offset:10)
        switchCamera.centerY(to: textCamera)
        //photolibrary
        textPhotoLibrary.height(30)
        textPhotoLibrary.width(150)
        textPhotoLibrary.topToSuperview(offset:5)
        textPhotoLibrary.centerY(to: viewPhotoLibrary)
    
        viewPhotoLibrary.height(74)
        viewPhotoLibrary.trailing(to: stackViewPrivacy)
        viewPhotoLibrary.leading(to: stackViewPrivacy)
       // viewPhotoLibrary.topToBottom(of: stackViewPrivacy,offset:150)

        switchPhotoLibrary.height(20)
        switchPhotoLibrary.width(50)
        switchPhotoLibrary.trailingToSuperview(offset:10)
        switchPhotoLibrary.centerY(to: textPhotoLibrary)
        //Location
        textLocation.height(30)
        textLocation.width(150)
        textLocation.topToSuperview(offset:5)
        textLocation.centerY(to: viewLocation)
        
        viewLocation.height(74)
        viewLocation.trailing(to: stackViewPrivacy)
        viewLocation.leading(to: stackViewPrivacy)
        
        switchLocation.height(20)
        switchLocation.width(50)
        switchLocation.trailingToSuperview(offset:10)
        switchLocation.centerY(to: textLocation)
        
        
        
        //stack2
        stackViewPrivacy.topToBottom(of: viewCamera, offset: 20)
        stackViewPrivacy.leading(to: stackViewPopular)
        stackViewPrivacy.trailing(to: stackViewPopular)
        
        saveButton.height(54)
        saveButton.width(342)
        saveButton.leading(to: viewPhotoLibrary)
        saveButton.trailing(to: viewPhotoLibrary)
        saveButton.bottomToSuperview(offset:-10,usingSafeArea: true)
        //saveButton.top(to: stackViewPrivacy)
    
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
