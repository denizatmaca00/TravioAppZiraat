//
//  SignUpVC.swift
//  TravioIki
//
//  Created by web3406 on 10/25/23.
//

import UIKit

class SignUpVC: UIViewController {
    
    var signUpData:User = User()
    
    //var userDelegator:UserDataDelegator?
    
    private lazy var txtUsername = AppTextField(data: .username)
    private lazy var txtEmail = AppTextField(data: .email)
    private lazy var txtPassword = AppTextField(data: .password)
    private lazy var txtPasswordConfirm = AppTextField(data: .passwordConfirm)
    
    private lazy var contentViewBig: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        view.clipsToBounds = true
        view.layer.cornerRadius = 80
        view.layer.maskedCorners = [.layerMinXMinYCorner]
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
        signUpButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 16)
        signUpButton.backgroundColor = UIColor(named: "backgroundColor")
        signUpButton.layer.cornerRadius = 12
        signUpButton.addTarget(self, action: #selector(signUpUser), for: .touchUpInside)
        signUpButton.isEnabled = false
        return signUpButton
    }()
    private lazy var leftBarButton: UIBarButtonItem = {
        let leftBarButton = UIBarButtonItem()
        leftBarButton.tintColor = .white
        leftBarButton.image = UIImage(named: "leftArrow")
        leftBarButton.target = self
        leftBarButton.action = #selector(signUpUser)
        return leftBarButton
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
        
    }

    
    @objc func updateUserInfo() -> Bool
    {
       print("Update user info in SignUpVC")
       let authenticate:Bool = checkPassMatch()
       
       if authenticate == true
       {
           self.signUpData.username = txtUsername.getLoginTextFieldText()
           self.signUpData.mail = txtEmail.getLoginTextFieldText()
           self.signUpData.password = txtPassword.getLoginTextFieldText()
           
           signUpButton.isEnabled = authenticate
       }
       return authenticate
    }
       
    @objc func signUpUser()
    {
        print("triga")
        let isAuthenticated = updateUserInfo()

        if isAuthenticated
        {
           // buraya signUpData cinsinden kullanıcı verisi gelecek
           //userDelegator?.getUserData(params: signUpData)
           print(signUpData)
           backButtonTapped()
        }
    }
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        
        // imageView.frame = CGRect(x: 120, y: 64, width:149, height: 178)
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.addSubviews(contentViewBig)
        self.navigationItem.leftBarButtonItem = leftBarButton

        contentViewBig.addSubview(stackViewMain)
        contentViewBig.addSubview(signUpButton)
        
        
        stackViewMain.addArrangedSubviews(txtUsername, txtEmail, txtPassword, txtPasswordConfirm)
        
        
        setupLayout()
    }
    
    func setupLayout() {
        let limits = self.view.safeAreaLayoutGuide.snp
        
        
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

extension SignUpVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)->Bool
    {
        // , shouldChangeCharactersIn range: NSRange, replacementString string: String
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
    
    //    func textEdit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkPassMatch()
    }
    
    func checkPassMatch()->Bool{
        
        let isEmpty = checkIsEmpty()
        
        if txtPassword.getLoginTextFieldText() == txtPasswordConfirm.getLoginTextFieldText() && isEmpty != false
        {
            print("butonu aç")
            signUpButton.isEnabled = true
            return true
            //return true
        }
        else{
            print("butonu kapa")
            signUpButton.isEnabled = false
            return false}
    }
    
    func checkIsEmpty()->Bool?
    {
        print("check if empty")
        if txtUsername.getLoginTextFieldText() == "" || txtEmail.getLoginTextFieldText() == "" || txtPassword.getLoginTextFieldText() == "" || txtPasswordConfirm.getLoginTextFieldText() == ""
        {
            print("boş")
            return false
        }
        else
        {
            print("dolu")
            return true
        }
    }
}

// geçici User tanımlaması
struct User{
    var username:String?
    var mail:String?
    var password:String?
}
