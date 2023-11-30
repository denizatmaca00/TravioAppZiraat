import UIKit
import SnapKit
import Network


class LoginVC: UIViewController {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    var viewModel = LoginVM()
    
    private lazy var emailTextField = CustomTextField(title: "Email", placeholder: "developer@bilgeadam.com", icon: nil, iconPosition: .none)
    private lazy var passwordTextField = CustomTextField(title: "Password", placeholder: "***************", icon: UIImage(systemName: "eye.slash.fill"), iconPosition: .right)

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
        startMonitoringNetwork()

        viewModel.showAlertClosure = { [weak self] title, message in
            self?.showAlert(title: title, message: message){
                
            }
        }
        viewModel.updateLoadingStatus = { [weak self] (isLoading) in
            DispatchQueue.main.async {
                switch self!.viewModel.isLoading{
                case true:
                    self?.showIndicator(with: "Waiting for server's response ...")
                case false:
                    self?.hideIndicator()
                }
            }
        }
    }
   

    func startMonitoringNetwork() {
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
            } else {
                DispatchQueue.main.async {
                    self.showNoInternetAlert()
                }
            }
        }
    }
    
    func showNoInternetAlert() {
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your internet connection and try again.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func btnSignUpTapped(){
        let vc = SignUpVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnLoginTapped() {
        guard let email = emailTextField.textField.text  else { return }
        guard let password = passwordTextField.textField.text  else { return }
        guard monitor.currentPath.status == .satisfied else {
            viewModel.showAlertClosure?("Error", "Not Internet Connection")
             return
         }
        viewModel.sendLoginData(email: email, password: password) {[self]  result in
            switch result {
            case .success:
                let vc = TabBarVC()
                navigationController?.pushViewController(vc, animated: true)
            case .failure(_):
                if email.isEmpty && password.isEmpty {
                    viewModel.showAlertClosure?("Error", "Email and password cannot be empty")
                }else if email.isEmpty {
                    viewModel.showAlertClosure?("Error", "Email cannot be empty")
                }else if password.isEmpty{
                    viewModel.showAlertClosure?("Error", "Password cannot be empty")
                }else{
                    viewModel.showAlertClosure?("Error", "Email or password is wrong")
                }
            }
        }
    }
    
    func setupViews() {
        
        emailTextField.textField.keyboardType = .emailAddress
        emailTextField.textField.autocorrectionType = .no
        emailTextField.textField.autocapitalizationType = .none
        passwordTextField.textField.isSecureTextEntry = true
        
        self.view.addSubview(imageView)
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.addSubview(contentViewBig)
        contentViewBig.addSubviews(welcomeLabel, stackViewMain, loginBtn, stackViewSignUp)
        
        stackViewMain.addArrangedSubviews(emailTextField, passwordTextField)
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
