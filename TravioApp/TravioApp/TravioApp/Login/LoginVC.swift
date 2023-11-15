import UIKit
import SnapKit


class LoginVC: UIViewController {
    
    private lazy var viewMail = AppTextField(data: .email)
    private lazy var viewPass = AppTextField(data: .password)
    
    private lazy var txtEmail = viewMail.getTFAsObject()
    private lazy var txtPassword = viewPass.getTFAsObject()
    
    var viewModel = LoginVM()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogo")
        return imageView
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let wlcLabel = UILabel()
        wlcLabel.text = "Welcome to Travio"
        wlcLabel.textColor = UIColor(named: "settingsLabelColor")
        wlcLabel.font = .Fonts.title24.font
        return wlcLabel
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
    
    private lazy var stackViewSignUp: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 2
        return sv
    }()
    
    private lazy var loginBtn : UIButton = {
        let loginButton = AppButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(btnLoginTapped), for: .touchUpInside)
        
        return loginButton
    }()
    
    private lazy var lblSignUp: UILabel = {
        let label = UILabel()
        label.text = "Don't have any account?"
        label.textColor = .black
        label.numberOfLines = 1
        label.font = .Fonts.signUpTitle.font
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    private lazy var btnSignUp: UIButton = {
        let b = UIButton()
        b.setTitle("Sign Up", for: .normal)
        b.titleLabel?.font = .Fonts.signUpTitle.font
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        b.setTitleColor(.black, for: .normal)
        b.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        return b
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.navigationController?.navigationBar.isHidden = true
        
        viewModel.showAlertClosure = { [weak self] title, message in
            self?.showAlert(title: title, message: message){
                
            }
        }
        viewModel.updateLoadingStatus = { [weak self] (isLoading) in
            DispatchQueue.main.async {
                switch self!.viewModel.isLoading{
                case true:
                    self?.showIndicator()
                case false:
                    self?.hideIndicator()
                }
            }
        }
    }
    
    @objc func btnSignUpTapped(){
        let vc = SignUpVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnLoginTapped() {
        
        guard let email = txtEmail.text  else { return }
        guard let password = txtPassword.text  else { return }
        
        viewModel.sendLoginData(email: email, password: password) {[self]  result in
            switch result {
            case .success:
                let vc = TabBarVC()
                navigationController?.pushViewController(vc, animated: true)
            case .failure(_):
                if email.isEmpty && password.isEmpty {
                    viewModel.showAlertClosure?("Hata", "Email and password cannot be empty")
                }else if email.isEmpty {
                    viewModel.showAlertClosure?("Hata", "Email cannot be empty")
                }else if password.isEmpty{
                    viewModel.showAlertClosure?("Hata", "Password cannot be empty")
                }else{
                    viewModel.showAlertClosure?("Hata", "Email or password is wrong")
                }
            }
        }
    }
    
    func setupViews() {
        
        txtEmail.keyboardType = .emailAddress
        txtEmail.autocorrectionType = .no
        txtEmail.autocapitalizationType = .none
        txtPassword.isSecureTextEntry = true
        
        self.view.addSubview(imageView)
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.addSubview(contentViewBig)
        contentViewBig.addSubviews(welcomeLabel, stackViewMain, loginBtn, stackViewSignUp)
        
        stackViewMain.addArrangedSubviews(viewMail, viewPass)
        stackViewSignUp.addArrangedSubviews(lblSignUp, btnSignUp)
        setupLayout()
    }
    
    func setupLayout() {
        let limits = self.view.safeAreaLayoutGuide.snp
        
        contentViewBig.snp.makeConstraints ({ view in
            view.height.equalToSuperview().multipliedBy(0.7)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        })
        
        welcomeLabel.snp.makeConstraints ({ lbl in
            lbl.centerX.equalToSuperview()
            lbl.top.equalTo(contentViewBig).offset(64)
        })
        
        stackViewMain.snp.makeConstraints ({ stack in
            stack.leading.equalToSuperview().offset(24)
            stack.trailing.equalToSuperview().offset(-24)
            stack.top.equalTo(welcomeLabel.snp.bottom).offset(41)
        })
        
        loginBtn.snp.makeConstraints({ btn in
            btn.leading.equalToSuperview().offset(24)
            btn.trailing.equalToSuperview().offset(-24)
            btn.top.equalTo(stackViewMain.snp.bottom).offset(48)
            btn.height.equalTo(54)
        })
        
        stackViewSignUp.snp.makeConstraints({ sv in
            sv.centerX.equalToSuperview()
            sv.bottom.equalTo(contentViewBig).inset(21)
        })
        
        imageView.snp.makeConstraints({ img in
            img.top.equalTo(limits.top)
            img.centerX.equalToSuperview()
        })
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct LoginVC_Preview: PreviewProvider {
    static var previews: some View{
        
        LoginVC().showPreview().ignoresSafeArea()
    }
}
#endif
