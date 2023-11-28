//
//  SignUpVC.swift
//  TravioIki
//
//  Created by web3406 on 10/25/23.
//

//

import UIKit

class SignUpVC: UIViewController {
    
    var signUpData: User = User(full_name: "", email: "", password: "")
    
    var viewModel = SignUpVM()
    
    
    private lazy var usernameTextField = CustomTextField(title: "Username", placeholder: "bilge_adam", icon: nil, iconPosition: .none)
    private lazy var emailTextField = CustomTextField(title: "Email", placeholder: "bilgeadam@gmail.com", icon: nil, iconPosition: .none)
    private lazy var passwordTextField = CustomTextField(title: "Password", placeholder: "", icon: UIImage(systemName: "eye.slash.fill"), iconPosition: .right)
    private lazy var passwordConfirmTextField = CustomTextField(title: "Password Confirm", placeholder: "", icon: UIImage(systemName: "eye.slash.fill"), iconPosition: .right)
    
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
        usernameTextField.textField.addTarget(self, action: #selector(updateUserInfo), for: .allEditingEvents)
        emailTextField.textField.addTarget(self, action: #selector(updateUserInfo), for: .allEditingEvents)
        passwordTextField.textField.addTarget(self, action: #selector(updateUserInfo), for: .allEditingEvents)
        passwordConfirmTextField.textField.addTarget(self, action: #selector(updateUserInfo), for: .allEditingEvents)
        setupViews()
        
        viewModel.showAlertClosure = { [weak self] title, message in
            self?.showAlert(title: title, message: message){
                
            }
        }
        viewModel.indicatorUpdateClosure = { [weak self] isLoading in
            DispatchQueue.main.async {
                switch isLoading{
                case true:
                    self?.showIndicator()
                case false:
                    self?.hideIndicator()
                }
            }
        }
    }
    
    @objc func updateUserInfo() -> Bool
    {
        let authenticate:Bool = checkPassMatch()
        
        if authenticate == true
        {
            self.signUpData.full_name = usernameTextField.textField.text ?? ""
            self.signUpData.email = emailTextField.textField.text ?? ""
            self.signUpData.password = passwordTextField.textField.text ?? ""
            
            signUpButton.isEnabled = authenticate
        }
        return authenticate
    }
    
    @objc func signUpUser() {
        
        viewModel.isLoading = true
        
        let isAuthenticated = updateUserInfo()

        if isAuthenticated {
            viewModel.postUserData(name: usernameTextField.textField.text, email: emailTextField.textField.text, password: passwordTextField.textField.text) { [weak self] result in
                switch result {
                case .success(let response):
                    if let messages = response.message {
                        self?.showAlert(title: "Notification", message: messages) {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                case .failure(let error):
                    self?.viewModel.showAlertClosure?("Error", error.localizedDescription)
                }
            }
        }
    }

    
    @objc func backButtonTapped(){
        let vc = LoginVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupViews() {
        usernameTextField.textField.autocapitalizationType  = .words
        
        emailTextField.textField.keyboardType = .emailAddress
        emailTextField.textField.autocorrectionType = .no
        emailTextField.textField.autocapitalizationType = .none
        
        passwordTextField.textField.isSecureTextEntry = true
        passwordConfirmTextField.textField.isSecureTextEntry = true
        
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.addSubviews(contentViewBig)
        self.view.addSubviews(leftBarButton, signUpLabel)
        
        contentViewBig.addSubviews(stackViewMain ,signUpButton)
        
        stackViewMain.addArrangedSubviews(usernameTextField,emailTextField, passwordTextField, passwordConfirmTextField)

        
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
        if textField == emailTextField.textField && textField.text?.count == 21
        {
            return false
        }
        else if textField == passwordTextField.textField && textField.text?.count == 21
        {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
   
    func checkPassMatch()->Bool{
        
        let isEmpty = checkIsEmpty()
        
        if passwordTextField.textField.text == passwordConfirmTextField.textField.text && isEmpty != false
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
        if usernameTextField.textField.text == "" ||
            emailTextField.textField.text == "" ||
            passwordTextField.textField.text == "" ||
            passwordConfirmTextField.textField.text == ""
        {
            return false
        }
        else if passwordTextField.textField.text!.count < 6 {
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
