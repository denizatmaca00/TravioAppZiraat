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
    //Alert
    enum SwitchType {
        case camera, photoLibrary, location
    }
    
       
    var viewModel = SecuritySettingsVM()
    let locationManager = CLLocationManager()
    var presentClosure: ((UIAlertController) -> Void)?
    var checkPermissionStatus: Bool?
    var checkPermissionLocationStatus: Bool?
    var checkPermissionLibraryStatus: Bool?

    private lazy var contentBigView: AppView = {
        let uv = AppView()
        return uv
    }()
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "backgroundColor")
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner]
        return view
    }()
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
        cptxt.font = .Fonts.mainButton.font
        cptxt.textColor = UIColor(named: "backgroundColor")
        return cptxt
    }()
    private lazy var privacyTitle:UILabel = {
        let cptxt = UILabel()
        cptxt.text = "Privacy"
        cptxt.font = .Fonts.mainButton.font
        cptxt.textColor = UIColor(named: "backgroundColor")
        return cptxt
    }()
    
    
    private lazy var passwordTextField = AppTextField(title: "New Password", placeholder: "", icon: UIImage(systemName: "eye.slash.fill"), iconPosition: .right)
    
    private lazy var confirmPassword = AppTextField(title: "New Password Confirm", placeholder: "", icon: UIImage(systemName: "eye.slash.fill"), iconPosition: .right)
    
    private lazy var camera: AppToggleSwitch = {
        let toggleSwitch = AppToggleSwitch(data: "Camera")
        toggleSwitch.toggleSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return toggleSwitch
        
    }()
    private lazy var photoLibrary: AppToggleSwitch = {
        let ts = AppToggleSwitch(data: "Photo Library")
        ts.toggleSwitch.addTarget(self, action: #selector(switchLibrary), for: .valueChanged)
        return ts
    }()
    private lazy var location: AppToggleSwitch = {
        let ts = AppToggleSwitch(data: "Location")
        ts.toggleSwitch.addTarget(self, action: #selector(switchLocation), for: .valueChanged)
        return ts
    }()
    
    private lazy var signupButton: AppButton = {
        let s = AppButton()
        s.setTitle("Save", for: .normal)
        s.isEnabled = true
        s.addTarget(self, action: #selector(updatePassword), for: .touchUpInside)
        return s
    }()
    
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
        let passwordText = passwordTextField.textField.text
        let confirmText = confirmPassword.textField.text
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
    
    @objc private func switchValueChanged() {
        if camera.toggleSwitch.isOn {
            self.alertSettings(getTitle: "Camera Access Required", getmessage:  "To enable Camera access, please go to Settings and turn on Camera for this app.")
        } else {
            self.alertSettings(getTitle: "Camera Access Required", getmessage:  "To enable Camera access, please go to Settings and turn on Camera for this app.")
        }
    }
    @objc private func switchLibrary(){
        if photoLibrary.toggleSwitch.isOn {
            //fonk çağır
            self.alertSettings(getTitle: "Photo Library Access Required", getmessage:  "To enable Photo Library access, please go to Settings and turn on Camera for this app.")
        }else {
            self.alertSettings(getTitle: "Photo Library Access Required", getmessage:  "To enable Photo Library access, please go to Settings and turn on Camera for this app.")
        }
    }
    //location
    @objc private func switchLocation(){
        if location.toggleSwitch.isOn {
            alertSettings(getTitle: "Location Access Required", getmessage: "To enable Location access, please go to Settings and turn on Camera for this app.")
        }
        else {
            alertSettings(getTitle: "Location Access Required", getmessage: "To enable Location access, please go to Settings and turn on Camera for this app.")
            
        }
    }
    func getSwitchTypeFromAlert(title: String) -> SwitchType? {
        switch title {
        case "Camera Access Required":
            return .camera
        case "Photo Library Access Required":
            return .photoLibrary
        case "Location Access Required":
            return .location
        default:
            return nil
        }
    }
    
    func showAlert(title:String,message:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    
    
    @objc func backPage(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.textField.isSecureTextEntry = true
        confirmPassword.textField.isSecureTextEntry = true
        
        addNotificationObserver()
        refreshSettings()
        setupViews()
    }
    func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(refreshSettings), name: Notification.Name("appActive"), object: nil)
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                self.checkPermissionStatus = true
            } else {
                self.checkPermissionStatus = false
            }
        }
    }
    //photo library
    func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.checkPermissionLibraryStatus = true
            case .denied, .restricted:
                self.checkPermissionLibraryStatus = false
            case .notDetermined:
                self.checkPermissionLibraryStatus = false
            default:
                self.checkPermissionLibraryStatus = false
            }
        }
    }
    func alertSettings(getTitle: String, getmessage: String) {
        let alertController = UIAlertController(
            title: getTitle,
            message: getmessage,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            if let switchType = self.getSwitchTypeFromAlert(title: getTitle) {
                switch switchType {
                case .camera:
                    self.camera.toggleSwitch.isOn = !self.camera.toggleSwitch.isOn
                case .photoLibrary:
                    self.photoLibrary.toggleSwitch.isOn = !self.photoLibrary.toggleSwitch.isOn
                case .location:
                    self.location.toggleSwitch.isOn = !self.location.toggleSwitch.isOn
                }
            }
        }
        alertController.addAction(cancelAction)
        
        let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
        }
        alertController.addAction(openSettingsAction)
        presentClosure?(alertController)
    }
    
    func requestLocationPermission(){
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            self.checkPermissionLocationStatus = true
        default:
            self.checkPermissionLocationStatus = false
            locationPermission()
        }
    }
    // first photolibrary permission
    func locationPermission() {
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshSettings()
    }
    
    @objc func refreshSettings(){
        requestLocationPermission()
        locationPermission()
        requestCameraPermission()
        requestPhotoLibraryPermission()
        
        presentClosure = { [weak self] alertController in
            self?.present(alertController, animated: true, completion: nil)
        }
        if checkPermissionStatus == true {
            self.camera.toggleSwitch.isOn = true
        }else {
            self.camera.toggleSwitch.isOn = false
        }
        //photo library
        if checkPermissionLibraryStatus == true {
            self.photoLibrary.toggleSwitch.isOn = true
        }else {
            self.photoLibrary.toggleSwitch.isOn = false
        }
        //location
        if checkPermissionLocationStatus == true {
            self.location.toggleSwitch.isOn = true
        }else {
            self.location.toggleSwitch.isOn = false
        }
        
    }
    func setupViews() {
        self.view.addSubview(backgroundView)
        self.view.addSubview(contentBigView)
        self.view.addSubview(mainTitle)
        self.view.addSubview(backButton)
        
        contentBigView.addSubview(scrollView)
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
        contentBigView.top(to: backgroundView, offset: 150)
        contentBigView.leadingToSuperview()
        contentBigView.trailingToSuperview()
        contentBigView.snp.makeConstraints({ uı in
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
        changePasswordTitle.top(to: scrollView, offset: 25)
        changePasswordTitle.height(20)
        changePasswordTitle.trailing(to: mainTitle, offset:-20)
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
        
        stackViewPrivacy.topToBottom(of: privacyTitle,offset: 10)
        stackViewPrivacy.height(266)
        stackViewPrivacy.leadingToSuperview(offset:20)
        stackViewPrivacy.trailing(to: changePasswordTitle)
        
        signupButton.topToBottom(of: stackViewPrivacy, offset: 50)
        signupButton.height(54)
        signupButton.trailing(to: stackViewPrivacy)
        signupButton.leading(to: stackViewPrivacy)
        signupButton.snp.makeConstraints({s in
            s.bottom.equalToSuperview().offset(-60)
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("appActive"), object: nil)
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


