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
    private lazy var location = AppToggleSwitch(data: .Location)
    @objc private func switchValueChanged() {
        if camera.toggleSwitch.isOn {
               // Switch açık durumda
               print("Switch is ON")
            //daha önce edilmişse bunu
               redirectToAppSettings()
            //autorized edilmemişse bunu
               //requestCameraPermission()
           } else {
               // Switch kapalı durumda
               print("Switch is OFF")
               redirectToAppSettings()
               //requestCameraPermission()
           }
       }
    //eğer toggle switch on ise kamera settinge gitmesini istedim, telefondan kapatacağım
     func redirectToAppSettings() {
            let alertController = UIAlertController(
                title: "Camera Access Required",
                message: "To enable camera access, please go to Settings and turn on Camera for this app.",
                preferredStyle: .alert
            )
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(settingsURL) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                }
            }
            alertController.addAction(openSettingsAction)
            present(alertController, animated: true, completion: nil)
        }
    //ilk erişim izini autorized edilmemişse
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                //kamera erişim izni
                print(" kamera erişim izni ")
                //self.camera.toggleSwitch.isOn = true
                self.redirectToAppSettings()
            } else {
                // Kullanıcı kamera erişim iznini reddetti.
                print("Kullanıcı kamera erişim iznini reddetti.")
            }
        }
    }
    //sayfa açıldığında kontrol eder camera izin statusunu
    func cameraPermission(){
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            self.camera.toggleSwitch.isOn = true
        print("zaten izin verilmiş.")
        case .notDetermined:
        print("not")
            self.camera.toggleSwitch.isOn = false
        default:
            self.camera.toggleSwitch.isOn = false
        }
    }
    
    @objc private func switchLibrary(){
        if photoLibrary.toggleSwitch.isOn {
            print("photo library on")
            //fonk çağır
            photoLibraryToAppSettings()
        }else {
            print("photo library off")
            //func çağır.
            photoLibraryToAppSettings()
        }
    }
    //photo library
    func photoLibraryToAppSettings(){
        let alert = UIAlertController(
            title: "Photo Library Required", message: "To enable Photo Library access, please go to Settings and turn on Photo Library for this app.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let openSetting = UIAlertAction(title: "open settings", style: .default){ dene in
            if let settingUrl = URL(string: UIApplication.openSettingsURLString){
                if UIApplication.shared.canOpenURL(settingUrl){
                    UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
                }
            }
        }
        alert.addAction(openSetting)
        present(alert, animated: true, completion: nil)
    }
    // photolibrary permission
    func photoLibraryPermission(){
        PHPhotoLibrary.requestAuthorization{ status in
            switch status {
            case .authorized:
                self.photoLibrary.toggleSwitch.isOn = true
                print("izin verildi.")
            case .notDetermined:
                self.photoLibrary.toggleSwitch.isOn = true
                print("zaten izin verilmiş")
            default:
                self.photoLibrary.toggleSwitch.isOn = false
            }
        }
    }
    func requestPhotoLibraryPermission(){
        AVCaptureDevice.requestAccess(for: .audio){ granted in
            if granted {
                print("library izni")
                self.photoLibraryToAppSettings()
            }else {
                print("kullanıcı library erişim iznini reddetti.")
            }
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

    
    @objc func backPage(){
        navigationController?.popViewController(animated: true)
     }

    override func viewDidLoad() {
        super.viewDidLoad()
       // viewBack.isHidden = false
       cameraPermission()
       photoLibraryPermission()
       setupViews()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
       }
    func setupViews() {
        // Add here the setup for the UI
       // self.view.backgroundColor = UIColor(named: "viewBackgroundColor")
        //self.view.addSubviews()
        self.view.addSubview(backgroundView)
        self.view.addSubview(uıView)
        self.view.addSubview(mainTitle)
        self.view.addSubview(backButton)
        //self.view.addSubview(changePasswordTitle)
        
        //uıView.addSubview(stackViewPasswordChange)
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
        


        
        scrollView.leadingToSuperview(offset:10)
       // scrollView.trailingToSuperview(offset:1600)
        scrollView.topToSuperview(offset:10)
        scrollView.snp.makeConstraints({s in
            s.trailing.equalToSuperview().offset(-2)
        })
//        scrollView.topToBottom(of: stackViewPasswordChange, offset: 10)
        scrollView.bottomToSuperview()
        //scrollView.edgesToSuperview()

        
        //changed password title
        changePasswordTitle.top(to: scrollView, offset: 10)
       // changePasswordTitle.topToSuperview(offset:20)
        changePasswordTitle.height(20)
        //changePasswordTitle.width(236)
        changePasswordTitle.width(346)
        changePasswordTitle.leadingToSuperview(offset:20)
        
        
        stackViewPasswordChange.leadingToSuperview(offset:20)
        //stackViewPasswordChange.trailingToSuperview(offset:20)
//        stackViewPasswordChange.snp.makeConstraints({s in
//            s.trailing.equalToSuperview().offset(-70)
//        })
        stackViewPasswordChange.trailing(to: changePasswordTitle)
        stackViewPasswordChange.topToBottom(of: changePasswordTitle,offset: 20)
        stackViewPasswordChange.height(170)
        
//        stackViewPasswordChange.addArrangedSubview(passwordTextField)
//        stackViewPasswordChange.addArrangedSubview(confirmPassword)
//
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
//        stackViewPrivacy.snp.makeConstraints({s in
//            s.trailing.equalToSuperview().offset(-70)
//        })

        signupButton.topToBottom(of: stackViewPrivacy, offset: 50)
        signupButton.height(54)
        signupButton.trailing(to: stackViewPrivacy)
        signupButton.leading(to: stackViewPrivacy)
        //saveButon.bottomToSuperview(offset: 20)
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
      
 
