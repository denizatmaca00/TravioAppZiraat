//
//  
//  SecuritySettingVCVC.swift
//  TravioApp
//
//  Created by Ece Poyraz on 3.11.2023.
//
//Constrait ciddi refactor edilecektir. :)
import UIKit
import TinyConstraints
import SnapKit
import AVFoundation
import Photos
import CoreLocation


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
    private lazy var camera: AppToggleSwitch = {
        let toggleSwitch = AppToggleSwitch(data: .camera)
        toggleSwitch.toggleSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return toggleSwitch
    }()
    private lazy var photoLibrary: AppToggleSwitch = {
        let ts = AppToggleSwitch(data: .libraryPhoto)
        ts.toggleSwitch.addTarget(self, action: #selector(switchLibrary), for: .valueChanged)
        return ts
    }()
    private lazy var location : AppToggleSwitch = {
        let ts = AppToggleSwitch(data: .Location)
        ts.toggleSwitch.addTarget(self, action: #selector(switchLocation), for: .valueChanged)
        return ts
    }()
    @objc private func switchLibrary(){
        if photoLibrary.toggleSwitch.isOn {
            print("photo library on")
            //fonk çağır
            viewModel.photoLibraryToAppSettings()
        }else {
            print("photo library off")
            //func çağır.
            viewModel.photoLibraryToAppSettings()
        }
    }
   //location
    @objc private func switchLocation(){
        if location.toggleSwitch.isOn {
            viewModel.locationToAppSettings()
        }else {
            viewModel.locationToAppSettings()
        }
    }

 //signup button
    private lazy var signupButton: AppButton = {
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
        //sw.layer.backgroundColor = UIColor.red.cgColor
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
        let passwordText = passwordGet.text
        let confirmText = passwordConfirM.text
        if passwordText == confirmText {
            viewModel.putPassword(password: Password(new_password: passwordText))
            viewModel.passwordChangeAlertClosure = {title, message in
                self.showAlert(title: title, message: message)
            }
        }else {
            viewModel.putPassword(password: Password(new_password: passwordText))
            viewModel.passwordChangeAlertClosure = {title, message in
                self.showAlert(title: "Error", message: "Password Not Matching")
            }
        }
    }
    func showAlert(title:String,message:String){

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK", style: .default)
         alertController.addAction(okAction)
         present(alertController, animated: true)
    }
    
    @objc private func switchValueChanged() {
        if camera.toggleSwitch.isOn {
               print("Switch is ON")
            viewModel.redirectToAppSettings()
           } else {
               print("Switch is OFF")
               viewModel.redirectToAppSettings()
           }
       }

    @objc func backPage(){
        navigationController?.popViewController(animated: true)
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        // viewBack.isHidden = false
        viewModel.locationPermission()
        viewModel.requestCameraPermission()
        viewModel.requestPhotoLibraryPermission()
        setupViews()
        //alert
        viewModel.presentClosure = { [weak self] alertController in
            self?.present(alertController, animated: true, completion: nil)
        }
        viewModel.checkPermission = {[weak self] () in
            self?.camera.toggleSwitch.isOn = true
        }
        viewModel.checkPermissionLibrary = {[weak self] () in
            self?.photoLibrary.toggleSwitch.isOn = true
        }
        viewModel.checkPermissionLocation = {[weak self] () in
            self?.location.toggleSwitch.isOn = true
        }
    }
  
    override func viewWillAppear(_ animated: Bool) {
        refreshSettings()
       }
    
    func refreshSettings(){

        if viewModel.checkPermissionStatus == true {
            viewModel.checkPermission?()
        }else {
            self.photoLibrary.toggleSwitch.isOn = false
        }
        //photo library
        if viewModel.checkPermissionLibraryStatus == true {
            viewModel.checkPermissionLibrary?()
        }else {
            self.photoLibrary.toggleSwitch.isOn = false
        }
        //location
        if viewModel.checkPermissionLocationStatus == true {
            viewModel.checkPermissionLocation?()
        }else {
            self.location.toggleSwitch.isOn = false
        }
        
    }
    func setupViews() {
        self.view.addSubview(backgroundView)
        self.view.addSubview(uıView)
        self.view.addSubview(mainTitle)
        self.view.addSubview(backButton)
        
        uıView.addSubview(scrollView)
        scrollView.addSubview(changePasswordTitle)
        scrollView.addSubview(stackViewPasswordChange)
        scrollView.addSubview(privacyTitle)
        scrollView.addSubview(stackViewPrivacy)
        scrollView.addSubview(signupButton)
        
        stackViewPasswordChange.addArrangedSubview(passwordTextField)
        stackViewPasswordChange.addArrangedSubview(confirmPassword)
      
        stackViewPrivacy.addArrangedSubview(camera)
        stackViewPrivacy.addArrangedSubview(photoLibrary)
        stackViewPrivacy.addArrangedSubview(location)
        setupLayout()
    }
    
    func setupLayout() {
        backgroundView.edgesToSuperview()
        uıView.top(to: backgroundView, offset: 150)
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
    
        scrollView.leadingToSuperview(offset:10)
        scrollView.topToSuperview(offset:10)
        scrollView.snp.makeConstraints({s in
            s.trailing.equalToSuperview().offset(-2)
        })
        scrollView.bottomToSuperview()
        //changed password title
        changePasswordTitle.top(to: scrollView, offset: 10)
        changePasswordTitle.height(20)
        changePasswordTitle.width(346)
        changePasswordTitle.leadingToSuperview(offset:20)
        
        
        stackViewPasswordChange.leadingToSuperview(offset:20)
        stackViewPasswordChange.trailing(to: changePasswordTitle)
        stackViewPasswordChange.topToBottom(of: changePasswordTitle,offset: 20)
        stackViewPasswordChange.height(170)
        
        //privacy
        privacyTitle.height(20)
        privacyTitle.trailing(to: stackViewPrivacy)
        privacyTitle.leading(to: stackViewPrivacy)
        privacyTitle.topToBottom(of: stackViewPasswordChange,offset: 10)

        //stackViewPrivacy.trailing(to: stackViewPasswordChange)
        stackViewPrivacy.topToBottom(of: privacyTitle,offset: 10)
        stackViewPrivacy.height(266)
        stackViewPrivacy.leadingToSuperview(offset:20)
        stackViewPrivacy.trailing(to: changePasswordTitle)

        signupButton.topToBottom(of: stackViewPrivacy, offset: 50)
        signupButton.height(54)
        signupButton.trailing(to: stackViewPrivacy)
        signupButton.leading(to: stackViewPrivacy)
        signupButton.snp.makeConstraints({s in
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
 
 
