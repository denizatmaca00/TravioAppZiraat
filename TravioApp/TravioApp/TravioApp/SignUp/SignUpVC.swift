//
//  SignUpVC.swift
//  TravioIki
//
//  Created by web3406 on 10/25/23.
//

//

import UIKit

class SignUpVC: UIViewController {
    
    var signUpData: User = User(full_name: "", email: "", password: "", id: "")
    
    var viewModel = SignUpVM()
    
    //var userDelegator:UserDataDelegator?
    
    private lazy var viewUsername = AppTextField(data: .username)
    private lazy var viewMail = AppTextField(data: .email)
    private lazy var viewPass = AppTextField(data: .password)
    private lazy var viewPassConfirm = AppTextField(data: .passwordConfirm)
    
    private lazy var txtUsername = viewUsername.getTFAsObject()
    private lazy var txtEmail = viewMail.getTFAsObject()
    private lazy var txtPassword = viewPass.getTFAsObject()
    private lazy var txtPasswordConfirm = viewPassConfirm.getTFAsObject()
    
    private lazy var signUpLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign Up"
        lbl.textColor = .white
        lbl.font = .Fonts.pageHeader36.font
        return lbl
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
    
    private lazy var signUpButton: UIButton = {
        let signUpButton = AppButton()
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpUser), for: .touchUpInside)
        signUpButton.isEnabled = false
        return signUpButton
    }()
    private lazy var leftBarButton: UIButton = {
        let leftBarButton = UIButton()
        leftBarButton.tintColor = .white
        leftBarButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        leftBarButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return leftBarButton
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        txtUsername.addTarget(self, action: #selector(updateUserInfo), for: .allEditingEvents)
        txtEmail.addTarget(self, action: #selector(updateUserInfo), for: .allEditingEvents)
        txtPassword.addTarget(self, action: #selector(updateUserInfo), for: .allEditingEvents)
        txtPasswordConfirm.addTarget(self, action: #selector(updateUserInfo), for: .allEditingEvents)
        
        setupViews()
        
        viewModel.showAlertClosure = { [weak self] title, message in
            self?.showAlert(title: title, message: message){
                
            }
        }
    }

    
    @objc func updateUserInfo() -> Bool
    {
       let authenticate:Bool = checkPassMatch()
       
       if authenticate == true
       {
           self.signUpData.full_name = txtUsername.text ?? ""
           self.signUpData.email = txtEmail.text ?? ""
           self.signUpData.password = txtPassword.text ?? ""
           
           signUpButton.isEnabled = authenticate
       }
       return authenticate
    }
       
    @objc func signUpUser() {
        let isAuthenticated = updateUserInfo()

        if isAuthenticated {
            viewModel.postUserData(name: txtUsername.text, email: txtEmail.text, password: txtPassword.text) { [weak self] result in
                switch result {
                case .success(let response):
                    if let messages = response.message {
                        self?.showAlert(title: "Notification", message: messages) {
                            // Kapatma işlemi için LoginVC'ye geri dön
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    self?.viewModel.showAlertClosure?("Yanlış", error.localizedDescription)
                }
            }
        }
    }

    
    @objc func backButtonTapped(){
        let vc = LoginVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupViews() {
        
        txtPassword.isSecureTextEntry = true
        txtPasswordConfirm.isSecureTextEntry = true
        
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.addSubviews(contentViewBig)
        self.view.addSubviews(leftBarButton, signUpLabel)

        contentViewBig.addSubviews(stackViewMain, signUpButton)
        
        stackViewMain.addArrangedSubviews(viewUsername, viewMail, viewPass, viewPassConfirm)
        
        setupLayout()
    }
    
    func setupLayout() {
        let limits = self.view.safeAreaLayoutGuide.snp
         
        leftBarButton.snp.makeConstraints({btn in
            btn.width.equalTo(24)
            btn.height.equalTo(21)
            btn.top.equalTo(limits.top).offset(15)
            btn.leading.equalToSuperview().offset(24)
        })
        
        signUpLabel.snp.makeConstraints({ lbl in
            lbl.centerX.equalToSuperview()
            lbl.top.equalTo(limits.top)
        })
        
        contentViewBig.snp.makeConstraints { view in
            view.height.equalToSuperview().multipliedBy(0.8)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }
        
        stackViewMain.snp.makeConstraints { stack in
            stack.leading.equalToSuperview().offset(24)
            stack.trailing.equalToSuperview().offset(-24)
            stack.top.equalTo(contentViewBig.snp.top).offset(72)
        }
        
        signUpButton.snp.makeConstraints({ btn in
            btn.bottom.equalTo(limits.bottom).offset(-23)
            btn.trailing.equalToSuperview().offset(-24)
            btn.leading.equalToSuperview().offset(24)
            btn.height.equalTo(54)
        })
    }
}

extension SignUpVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)->Bool
    {
        if textField == txtEmail && textField.text?.count == 21
        {
            return false
        }
        else if textField == txtPassword && textField.text?.count == 21
        {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkPassMatch()
    }
    
    func checkPassMatch()->Bool{
        
        let isEmpty = checkIsEmpty()
        
        if txtPassword.text == txtPasswordConfirm.text && isEmpty != false
        {
            signUpButton.isEnabled = true
            return true
        }
        else{
            signUpButton.isEnabled = false
            return false}
    }
    
    func checkIsEmpty()->Bool?
    {
        if txtUsername.text == "" ||
            txtEmail.text == "" ||
            txtPassword.text == "" ||
            txtPasswordConfirm.text == ""
        {
            return false
        }
        else if txtPassword.text!.count < 6 {
            return false
        }
        else
        {
            return true
        }
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct SignUpVC_Preview: PreviewProvider {
    static var previews: some View{
        
        SignUpVC().showPreview()
    }
}
#endif