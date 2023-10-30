import UIKit
import SnapKit
// Veri modeli oluştur




class LoginVC: UIViewController, ViewModelDelegate {

    private lazy var viewMail = AppTextField(data: .email)
    private lazy var viewPass = AppTextField(data: .password)
    
    private lazy var txtEmail = viewMail.getTFAsObject()
    private lazy var txtPassword = viewPass.getTFAsObject()
    
    var viewModel = NetworkVM()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogo")
        return imageView
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let wlcLabel = UILabel()
        wlcLabel.text = "Welcome to Travio"
        wlcLabel.textColor = .black
        wlcLabel.font = UIFont(name: "Poppins-Regular", size: 24)
        return wlcLabel
    }()

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
    
    private lazy var loginBtn : UIButton = {
        let loginButton = AppButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        loginButton.backgroundColor = UIColor(named: "backgroundColor")
        loginButton.layer.cornerRadius = 12
        loginButton.addTarget(self, action: #selector(btnLoginTapped), for: .touchUpInside)

        return loginButton
    }()
    
    private lazy var lblSignUp: UILabel = {
        let label = UILabel()
        label.text = "Don't have any account?"
        label.textColor = .black
        label.numberOfLines = 1
        label.font = UIFont(name: "Poppins-Bold", size: 14)
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    private lazy var btnSignUp: UIButton = {
        let b = UIButton()
        b.setTitle("Sign Up", for: .normal)
        b.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        b.setTitleColor(.black, for: .normal)
        b.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        return b
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.showAlertClosure = { [weak self] title, message in
            self?.showAlert(title: title, message: message)
        }
    }
    
    @objc func btnSignUpTapped(){
        let vc = SignUpVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func btnLoginTapped() {
        guard let email = txtEmail.text  else { return }
        guard let password = txtPassword.text  else { return }
        viewModel.getUserData(email: email, password: password) {[self]  result in
            switch result {
            case .success:
                let vc = TabBarVC()
                navigationController?.pushViewController(vc, animated: true)
            case .failure(_):
                if email.isEmpty && password.isEmpty {
                    viewModel.showAlertClosure?("Hata", "Email ve şifre alanları boş bırakılmaz")
                }else if email.isEmpty {
                    viewModel.showAlertClosure?("Hata", "Email alanı boş bırakılmaz")
                }else if password.isEmpty{
                    viewModel.showAlertClosure?("Hata", "Şifre alanı boş bırakılmaz")
                }else{
                    viewModel.showAlertClosure?("Hata", "Email veya şifre hatalı")
                }
            }
        }
    }

    func setupViews() {
        
        self.view.addSubview(imageView)
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.addSubview(contentViewBig)
        contentViewBig.addSubviews(welcomeLabel, stackViewMain, loginBtn, lblSignUp, btnSignUp)

        stackViewMain.addArrangedSubviews(viewMail, viewPass)
        setupLayout()
    }

    func setupLayout() {
        contentViewBig.snp.makeConstraints ({ view in
            view.height.equalToSuperview().multipliedBy(0.7)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        })

        welcomeLabel.snp.makeConstraints ({ lbl in
            lbl.leading.equalToSuperview().offset(82)
            lbl.trailing.equalToSuperview().offset(-82)
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
        
        lblSignUp.snp.makeConstraints({lbl in
            lbl.bottom.equalTo(contentViewBig).inset(21)
            lbl.leading.equalTo(contentViewBig).inset(74)
        })
        
        btnSignUp.snp.makeConstraints({btn in
            btn.leading.equalTo(lblSignUp.snp.trailing).offset(2)
            btn.centerY.equalTo(lblSignUp)
        })
        
        imageView.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(54).constraint.isActive = true
            img.leading.equalToSuperview().offset(120)
            img.trailing.equalToSuperview().offset(-121)
        })
    }
}
