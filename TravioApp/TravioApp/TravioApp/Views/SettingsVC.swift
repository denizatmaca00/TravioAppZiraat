//
//  SettingsVC.swift
//  TravioApp
//
//  Created by web3406 on 11/2/23.
//

import UIKit

//
//  SettingsVC.swift
//  TravioApp
//
//  Created by web3406 on 11/2/23.
//

import UIKit

class SettingsVC: UIViewController {
    
    let loginVM = LoginVM()
    var profileViewModel = ProfileVM()
    
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
        return imageView
    }()
    private lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.text = "İsim Soyisim"
        lbl.textColor = UIColor(named: "settingsLabelColor")
        lbl.font = UIFont(name: "Poppins-Medium", size: 16)
        return lbl
    }()
    private lazy var settingsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Settings"
        lbl.textColor = .white
        lbl.font = UIFont(name: "Poppins-Medium", size: 32)
        return lbl
    }()
    
    private lazy var editProfileButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(UIColor(named: "editProfileColor"), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 12)
        btn.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        
        return btn
    }()
    private lazy var logOutButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "logOut"), for: .normal)
        btn.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        return btn
    }()
    
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
            //bir tane showAlert olabilir
        }
    }

    
    @objc func editProfileTapped() {
        let vc = EditProfileVC()
        self.navigationController?.pushViewController(vc, animated: true)
        print("edit")
    }
    
    private lazy var contentViewBig: AppView = {
            let view = AppView()
            return view
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // self.navigationController?.isNavigationBarHidden = true
        setupViews()
        initVM()
    }
    
    func initVM(){
        profileViewModel.profileUpdateClosure = { [weak self] profile in
                    self?.label.text = profile.full_name
                    self?.imageView.image = UIImage(named: profile.pp_url)
                }
                
        profileViewModel.getProfileInfos(completion: {result in })
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.addSubviews(contentViewBig,tableView, settingsLabel, logOutButton)
        contentViewBig.addSubviews(imageView, label,editProfileButton)
        setupLayout()
    }
    
    func setupLayout() {
        let limits = self.view.safeAreaLayoutGuide.snp
        
        imageView.snp.makeConstraints({ img in
            img.top.equalTo(contentViewBig).offset(24)
            img.leading.equalTo(contentViewBig).offset(135)
            img.trailing.equalTo(contentViewBig).offset(-135)
            img.height.equalTo(120)
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
        self.view.bringSubviewToFront(logOutButton)
        
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

//extension SettingsVC: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cellArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingsCollectionCell
//        let cellData = cellArray[indexPath.row]
//        cell.configure(data: cellData)
//        cell.setupViews()
//        cell.setupLayout()
//        cell.backgroundColor =  UIColor(named: "viewBackgroundColor")
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//           return 54
//       }
//
//}

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
            return 8 // Boşluk hücresi yükseklik
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSection = indexPath.section
    switch selectedSection {
        case 0:
            let vc = SecuritySettingVC()
            navigationController?.pushViewController(vc, animated: true)
        // diğer caseleri de burada değerlendiririm.
//        case 1:
//            let appDefaultsVC = AppDefaultsVC()
//            navigationController?.pushViewController(appDefaultsVC, animated: true)
//        case 2:
//            let myAddedPlacesVC = MyAddedPlacesVC()
//            navigationController?.pushViewController(myAddedPlacesVC, animated: true)
    case 4:
        let vc = AboutUsVC()
        navigationController?.pushViewController(vc, animated: true)
    case 5:
        let vc = TermsOfUseVC()
        navigationController?.pushViewController(vc, animated: true)
        
        default:
            break
        }
        
        // Seçilen section'ın vurgusunu kaldırır
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
