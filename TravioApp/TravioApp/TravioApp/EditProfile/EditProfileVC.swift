//
//  EditProfileVC.swift
//  TravioApp
//
//  Created by web3406 on 11/6/23.
//

import UIKit
import Kingfisher
import Photos
import AVFoundation

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate {
    
    var viewModel = EditProfileVM()
    var viewModelProfile: ProfileVM?
    
    
    private lazy var fullNameTextField = AppTextField(title: "Full Name", placeholder: "bilge_adam", icon: nil, iconPosition: .none)
    private lazy var emailTextField = AppTextField(title: "Email", placeholder: "bilgeadam@gmail.com", icon: nil, iconPosition: .none)
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogo")
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    func initPicker() {
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [self] _ in
            requestCameraPermission { granted in
               DispatchQueue.main.async {
                    if granted {
                        self.presentImagePicker(sourceType: .camera)
                    } else {
                        self.showAlert(title: "Camera Permission", message: "Not Allowed", completion: {
                            self.dismiss(animated: true)
                        })
                    }
                }
            }
            
        }

        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { [self] _ in
           
            requestPhotoLibraryPermission { granted in
                      DispatchQueue.main.async {
                          if granted {
                              self.presentImagePicker(sourceType: .photoLibrary)
                          } else {
                              self.showAlert(title: "Photo Library Permission", message: "Not Allowed", completion: {
                                  self.dismiss(animated: true)
                              })
                          }
                      }
                  }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        self.addActionSheet(title: "Added Photo", message: "Choose Your Way", actions: [cameraAction, galleryAction, cancelAction])

    }

    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = sourceType
            present(picker, animated: true, completion: nil)
        } else {
            showAlert(title: "Error", message: "Selected source type is not available.", completion: {})
        }
    }

    
    private lazy var changePhotoButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Change Photo", for: .normal)
        btn.setTitleColor(UIColor(named: "editProfileColor"), for: .normal)
        btn.titleLabel?.font = .Fonts.textFieldText.font
        btn.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var labelName: UILabel = {
        let lbl = UILabel()
        lbl.text = "bruce wills"
        lbl.textColor = UIColor(named: "settingsLabelColor")
        lbl.font = .Fonts.header24.font
        return lbl
    }()
    
    lazy var labelDate = AppLabel(icon: UIImage(named: "signature"), text: viewModelProfile?.profile.created_at ?? "", alignment: .left)
    lazy var labelRole = AppLabel(icon: UIImage(named: "role"), text: viewModelProfile?.profile.role ?? "", alignment: .left)
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Edit Profile"
        lbl.textColor = .white
        lbl.font = .Fonts.pageHeader32.font
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
    private lazy var stackLabel: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 180
        sv.axis = .horizontal
        sv.backgroundColor = .red
//        sv.backgroundColor = UIColor(named: "viewBackgroundColor")
        return sv
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
        signUpButton.addTarget(self, action: #selector(saveEditProfile), for: .touchUpInside)
        return signUpButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.textField.autocapitalizationType = .none
        
        // Define closures
        viewModel.indicatorUpdateClosure = { [weak self] isLoading, message in
            self?.toggleActivityIndicator(isLoading, message: message)
        }
        
        viewModel.showAlertClosure = { [weak self] title, message in
            self?.showAlert(title: title, message: message, completion: {
                self?.dismiss(animated: true)
            })
        }
        
        setupViews()
        initVM()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(true)
        initVM()
    }
    
    @objc func changePhotoTapped() {
        self.initPicker()
    }
    
    func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
                /// Case that allows photo library access
            case .authorized:
                completion(true)
                /// Case that restricts  photo library access when user did not give permission
            case .denied, .restricted:
                completion(false)
                /// Case for undetermined permission
            case .notDetermined:
                completion(false)
            default:
                break
            }
        }
    }
    
    //camera permission
    func requestCameraPermission(completion: @escaping (Bool)->Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func initVM(){
        viewModelProfile?.profileUpdateClosure = { [weak self] updatedProfile in
            self?.labelName.text = updatedProfile.full_name
            self?.labelDate.textLabel.text = updatedProfile.created_at.formatDate()
            self?.labelRole.textLabel.text = updatedProfile.role
            self?.fullNameTextField.textField.text = updatedProfile.full_name
            self?.emailTextField.textField.text = updatedProfile.email
            guard let url = URL(string: updatedProfile.pp_url) else {return}
            ImageHelper().setImage(imageURL: url, imageView: self!.imageView)
            self?.viewModel.profile = updatedProfile
        }
        viewModelProfile?.getProfileInfos()
    }
    
    @objc func exitButtonTapped(){
        dismiss(animated: true)
    }
    
    @objc func saveEditProfile() {
        guard let email = emailTextField.textField.text,
              let full_name = fullNameTextField.textField.text,
              let imageURL = viewModel.editProfile.pp_url as? String
        else { return }
        viewModel.editProfile = EditProfile(full_name: full_name, email: email, pp_url: imageURL)
        
        guard let image = imageView.image else { return }
        viewModel.selectedImage = image
        
        syncTasks()
    }
    
    /// Contains funcions that posts new profile data
    private func syncTasks() {
        DispatchQueue.main.async {
            self.viewModelProfile?.getProfileInfos()
        }
        self.viewModel.postData()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.addSubviews(contentViewBig, titleLabel, exitButton)
        contentViewBig.addSubviews(imageView, changePhotoButton, labelName,stackLabel, stackViewMain, saveButton)
        stackViewMain.addArrangedSubviews(fullNameTextField, emailTextField)
        stackLabel.addArrangedSubviews(labelDate, labelRole)
        setupLayout()
    }
    
    func setupLayout() {
        let limits = self.view.safeAreaLayoutGuide.snp
        
        titleLabel.snp.makeConstraints({ lbl in
            lbl.top.equalToSuperview().offset(30)
            lbl.leading.equalToSuperview().offset(20)
        })
        
        exitButton.snp.makeConstraints({ btn in
            btn.centerY.equalTo(titleLabel)
            btn.trailing.equalToSuperview().offset(-24)
            btn.height.width.equalTo(20)
        })
        
        imageView.snp.makeConstraints({ img in
            img.top.equalTo(contentViewBig).offset(24)
            img.centerX.equalToSuperview()
            img.height.width.equalTo(120)
        })
        
        changePhotoButton.snp.makeConstraints({ btn in
            btn.top.equalTo(imageView.snp.bottom).offset(7)
            btn.centerX.equalToSuperview()
        })
        
        labelName.snp.makeConstraints({ lbl in
            lbl.top.equalTo(changePhotoButton.snp.bottom).offset(7)
            lbl.centerX.equalToSuperview()
        })
        
        stackLabel.snp.makeConstraints({ lbl in
            lbl.top.equalTo(labelName.snp.bottom).offset(39)
            lbl.leading.equalToSuperview().offset(24)
            lbl.trailing.equalToSuperview().offset(-24)
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
extension EditProfileVC : UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage{
            imageView.image = selectedImage
            viewModel.selectedImage = selectedImage
            viewModel.doUploadWork = true
            dismiss(animated: true, completion: nil)
        }
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
