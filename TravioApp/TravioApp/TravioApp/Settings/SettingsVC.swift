//
//  SettingsVC.swift
//  TravioApp
//
//  Created by web3406 on 11/2/23.
//

import UIKit

class SettingsVC: UIViewController {
    
    let loginVM = LoginVM()
    let profileViewModel = ProfileVM()
    let editProfileVC = EditProfileVC()
    weak var editViewModel: EditProfileVM?
    
    let cellArray: [SettingsCell] = [
        SettingsCell(iconName: "profile", label: "Security Settings", iconArrow: "buttonArrow"),
        SettingsCell(iconName: "appDefault", label: "App Defaults", iconArrow: "buttonArrow"),
        SettingsCell(iconName: "myAddedPlaces", label: "My Added Places", iconArrow: "buttonArrow"),
        SettingsCell(iconName: "helpAndSupport", label: "Help&Support", iconArrow: "buttonArrow"),
        SettingsCell(iconName: "about", label: "About", iconArrow: "buttonArrow"),
        SettingsCell(iconName: "termsOfUse", label: "Terms of Use", iconArrow: "buttonArrow")
        
    ]
    let cellSpacingHeight: CGFloat = 20
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "viewBackgroundColor")
        tableView.separatorStyle = .none
        tableView.register(SettingsCollectionCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(SpaceCell.self, forCellReuseIdentifier: "SpaceCell")
        
        return tableView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogo")
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        return imageView
        // burası değişecek güncellenecek
    }()
    
    private lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textColor = UIColor(named: "settingsLabelColor")
        lbl.font = .Fonts.profileNameTitle.font
        return lbl
        // burası değişecek güncellenecek
        
    }()
    private lazy var settingsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Settings"
        lbl.textColor = .white
        lbl.font = .Fonts.pageHeader32.font
        return lbl
    }()
    
    private lazy var editProfileButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(UIColor(named: "editProfileColor"), for: .normal)
        btn.titleLabel?.font = .Fonts.descriptionLabel.font
        btn.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var logOutButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "logOut"), for: .normal)
        btn.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var contentViewBig: AppView = {
        let view = AppView()
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        initVM()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editProfileVC.viewModelProfile = profileViewModel
        editViewModel = editProfileVC.viewModel
        
        self.navigationController?.navigationBar.isHidden = true
        
        setupViews()
        initVMFirstFetch()
    }
    
    func initVM() {
        editViewModel!.profileUpdateClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.label.text = self?.profileViewModel.profile.full_name
                self?.imageView.image = self?.editViewModel!.selectedImage
                self?.editViewModel!.editProfile.pp_url = (self?.profileViewModel.profile.pp_url)!
                ImageHelper().setImage(imageURL: URL(string: (self?.editViewModel!.editProfile.pp_url)!)!, imageView: self!.imageView)
            }
        }
        self.profileViewModel.getProfileInfos(completion: {result in})
    }
    
    func initVMFirstFetch(){
        profileViewModel.profileUpdateClosure = { [weak self] profile in
            self?.label.text = profile.full_name
            guard let url = URL(string: profile.pp_url) else {return}
            guard let img = self?.imageView else {return}
            ImageHelper().setImage(imageURL: url, imageView: img)
        }
        profileViewModel.getProfileInfos(completion: {result in })
    }
    
    @objc func logOutButtonTapped() {
        //KeychainHelper.shared.delete("Travio", account: "asd")
        
        loginVM.logout { result in
            switch result {
            case .success:
                let loginVC = LoginVC()
                let navigationController = UINavigationController(rootViewController: loginVC)
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = navigationController
                }
            case .failure(let error):
                print("Logout Error: \(error)")
            }
        }
    }
    
    @objc func editProfileTapped() {
        self.present(editProfileVC, animated: true)
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.bringSubviewToFront(logOutButton)
        
        self.view.addSubviews(contentViewBig,tableView, settingsLabel, logOutButton)
        
        contentViewBig.addSubviews(imageView, label,editProfileButton)
        
        setupLayout()
    }
    
    func setupLayout() {
        
        imageView.snp.makeConstraints({ img in
            img.top.equalTo(contentViewBig).offset(24)
            img.centerX.equalToSuperview()
            img.height.width.equalTo(120)
        })
        label.snp.makeConstraints({ lbl in
            lbl.top.equalTo(imageView.snp.bottom).offset(8)
            lbl.centerX.equalTo(contentViewBig)
        })
        settingsLabel.snp.makeConstraints({ lbl in
            lbl.top.equalToSuperview().offset(60)
            lbl.leading.equalToSuperview().offset(20)
        })
        
        editProfileButton.snp.makeConstraints({ btn in
            btn.top.equalTo(label.snp.bottom)
            btn.centerX.equalTo(contentViewBig)
        })
        
        logOutButton.snp.makeConstraints({ btn in
            btn.centerY.equalTo(settingsLabel)
            btn.trailing.equalToSuperview().offset(-24)
            btn.height.equalTo(30)
            btn.width.equalTo(30)
        })
        
        contentViewBig.snp.makeConstraints ({ view in
            view.height.equalToSuperview().multipliedBy(0.8)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        })
        
        tableView.snp.makeConstraints ({ tableView in
            tableView.top.equalTo(imageView.snp.bottom).offset(74)
            tableView.leading.equalTo(view)
            tableView.trailing.equalTo(view)
            tableView.bottom.equalTo(view)
        })
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingsCollectionCell
            let cellData = cellArray[indexPath.section]
            cell.configure(data: cellData)
            cell.setupViews()
            cell.setupLayout()
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "viewBackgroundColor")
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 4)
            cell.layer.shadowRadius = 100
            cell.layer.shadowOpacity = 0.15
            cell.layer.masksToBounds = true
            
            return cell
        } else {
            let spaceCell = tableView.dequeueReusableCell(withIdentifier: "SpaceCell", for: indexPath) as! SpaceCell
            spaceCell.backgroundColor = .clear
            spaceCell.selectionStyle = .none
            return spaceCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 54
        } else {
            /// Default height for spaceCell
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSection = indexPath.section
        switch selectedSection {
        case 0:
            let vc = SecuritySettingVC()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
            //        case 1:
            //            let appDefaultsVC = AppDefaultsVC()
            //            navigationController?.pushViewController(appDefaultsVC, animated: true)
            
        case 2:
            let myAddedPlacesVC = SeeAllVC()
            myAddedPlacesVC.viewModel.allPlaceforUser()
            self.navigationController?.pushViewController(myAddedPlacesVC, animated: true)
            
            
        case 3:
            let vc = HelpAndSupportVC()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
        case 4:
            let vc = AboutUsVC()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
        case 5:
            let vc = TermsOfUseVC()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct SettingsVC_Preview: PreviewProvider {
    static var previews: some View{
        
        SettingsVC().showPreview().ignoresSafeArea(.all)
    }
}
#endif
