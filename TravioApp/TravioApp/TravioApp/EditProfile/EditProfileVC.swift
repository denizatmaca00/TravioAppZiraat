//
//  EditProfileVC.swift
//  TravioApp
//
//  Created by web3406 on 11/6/23.
//
// TODO: Labellar için bir UIEelements yazılablir +
// TODO: contentViewBig her sayfada kullnaılıyor onu da düzenlemek lazım +
// TODO: profile networking +
// TODO: delegate silinsin eğer kullanılmıyorsa +
// TODO: signUp çıkan başarılı alertten sonra direkt logine aktar +
// TODO: fontlar enumdan beslensin --> signup font size +
// TODO: classları sayfa sayfa ayırın +
// TODO: homevc uılar get tamamlansın +
// TODO: map upload scrrolview +
// TODO: map post networking+
// TODO: map addPlaceden sonra reload+
// TODO: editPrpfile put networking +
// TODO: homevc uılar paddingler +
// TODO: signup loading +
// TODO: klavye +
// TODO: signUp mvvme göre düzenle +
// TODO: populervc uı backbutton, font, üst üste gelmesi +


// proje nasıl daha iyi hale gelir fikirleri
// TODO: labelheader uılabel sınıfı
// TODO: leftBarItem bir tane yazılıp her yerden çekilebilir
// TODO: color enumı eklenebilir
// TODO: stackview eklenmeli cardların içine

//Deniz
// TODO: map upload
// TODO: map ftoğraflar için collectionciewi sağa sol ypmak gereliyor o
// TODO: mapte kalkmıyor pin
// TODO: editPrpfile label networking
// TODO: editPrpfile changePhoto networking

//Aydın
// TODO: logoutta tokenı sil scene delegatte token kontrolü yap varsa tabbar yoksa login(aslında bunlara benzer şeyler var ama tam çalışmıyor.)
//TODO: HomeSettingsVC
//TODO: Homeda detaya gidelicek

//Ece
//TODO: Popular 3 tane
//TODO: Popularya da3 yandeden de detaya gidelicek
//TODO: Popularya da3 yandeden de detaya gidelicek
//TODO: detay sayfasında scrrol static ayarlanacak
//TODO: detay sayfasında scrrol static ayarlanacak
//TODO: detay sayfasında shadow ekleecek
//TODO: security settings UI

//TODO: tabbarın hangis sayfada olup olmaması
//TODO: App DEfaults ne yapacak ?


import UIKit

class EditProfileVC: UIViewController {
    
    var viewModel = EditProfileVM()
    var viewModelProfile = ProfileVM()
    
    private lazy var viewUsername = AppTextField(data: .fullname)
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
        btn.titleLabel?.font = .Fonts.textFieldText.font
        //btn.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var labelName: UILabel = {
        let lbl = UILabel()
//        lbl.text = viewModelProfile.profile.full_name
        lbl.text = "bruce wills"
        lbl.textColor = UIColor(named: "settingsLabelColor")
        lbl.font = .Fonts.header24.font
        return lbl
    }()
    
     lazy var labelDate = AppLabel(icon: UIImage(named: "signature"), text: viewModelProfile.profile.created_at, alignment: .left)
     lazy var labelRole = AppLabel(icon: UIImage(named: "role"), text: viewModelProfile.profile.role, alignment: .left)
    
    
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
        
        setupViews()
        
        viewModelProfile.profileUpdateClosure = { [weak self] updatedProfile in
                   // Update UI with the new profile data
                   self?.labelName.text = updatedProfile.full_name
            self?.labelDate.textLabel.text = updatedProfile.created_at
                   self?.labelRole.textLabel.text = updatedProfile.role
               }
    }
    
    @objc func exitButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveEditProfile() {
        guard let email = txtEmail.text,
              let full_name = txtUsername.text,
              let pp_url = imageView.image else { return }
        
        viewModel.putEditProfileInfos(profile: EditProfile(full_name: full_name, email: email, pp_url: pp_url.description))
        labelName.text = full_name
        viewModelProfile.profile.full_name = full_name
        
        
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
