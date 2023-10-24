//
//  UsersVC.swift
//  MvvmBir
//
//  Created by web3406 on 10/23/23.
//

import UIKit
import SnapKit

class UsersVC: UIViewController {
    
    lazy var viewModel: UserListViewModel = {
        return UserListViewModel()
    }()
    
    private lazy var txtName: UITextField = {
        let tf = UITextField()
        tf.placeholder = "İsminizi Giriniz"
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.cornerRadius = 20
        tf.layer.borderWidth = 0.5
        return tf
    }()
    
    private lazy var txtPhone: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Telefon Numaranızı Giriniz"
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.cornerRadius = 20
        tf.layer.borderWidth = 0.5
        return tf
    }()
    
    private lazy var txtEmail: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Emailinizi Giriniz"
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.cornerRadius = 20
        tf.layer.borderWidth = 0.5
        return tf
    }()
    
    private lazy var txtNote: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Notunuz Varsa Giriniz"
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.cornerRadius = 20
        tf.layer.borderWidth = 0.5
        return tf
    }()
//    private lazy var txtIdPut: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "Değiştirmek istediğinizin Idsini yazınız"
//        tf.layer.borderColor = UIColor.black.cgColor
//        tf.layer.cornerRadius = 20
//        tf.layer.borderWidth = 0.5
//        return tf
//    }()
    private lazy var btnSave:UIButton = {
        let b = UIButton()
        b.setTitle("Kaydet", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .systemCyan
        b.layer.borderColor = UIColor.black.cgColor
        b.layer.cornerRadius = 20
        b.layer.borderWidth = 0.5
        b.addTarget(self, action: #selector(btnSaveTapped), for: .touchUpInside)
        b.tintColor = .white
        return b
    }()
    private lazy var btnChange:UIButton = {
        let b = UIButton()
        b.setTitle("Verileri oku", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .systemCyan
        b.layer.borderColor = UIColor.black.cgColor
        b.layer.cornerRadius = 20
        b.layer.borderWidth = 0.5
        b.addTarget(self, action: #selector(btnGetTapped), for: .touchUpInside)
        b.tintColor = .white
        return b
    }()
    
    @objc func btnGetTapped() {
        viewModel.getDataFromAPI{_ in 
            let obj = self.viewModel.usersInfos
            let vc = ShowUsersVC()
            vc.usersInfo = obj
            self.navigationController?.pushViewController(vc, animated: true)

        }
        print("bastım")

    }
    
    private lazy var stackView:UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        sv.distribution = .fillEqually
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @objc func btnSaveTapped() {
        
        viewModel.postDataFromAPI(name: txtName.text, email: txtEmail.text, phoneNumber: txtPhone.text, note: txtNote.text)
    }
    

    
    private func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubviews(stackView, btnSave)
        stackView.addArrangedSubviews(txtName, txtEmail, txtPhone, txtNote, btnSave, btnChange)
        setupLayout()
    }
    
    private func setupLayout() {
        txtName.snp.makeConstraints({ $0.height.equalTo(50) })
        stackView.snp.makeConstraints({ stack in
            stack.leading.equalToSuperview().offset(24)
            stack.trailing.equalToSuperview().offset(-24)
            stack.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
        })
        
    }
}
