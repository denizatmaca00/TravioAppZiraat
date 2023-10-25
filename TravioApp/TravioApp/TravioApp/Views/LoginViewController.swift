import UIKit
import SnapKit
// Veri modeli oluştur



class LoginViewController: UIViewController {

// git için deneme
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
        loginButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 16)
        loginButton.backgroundColor = UIColor(named: "backgroundColor")
        loginButton.layer.cornerRadius = 12
        return loginButton
    }()
    
    private lazy var lblNameText: UILabel = {
        let label = UILabel()
        label.text = "Don't have any account?"
        label.textColor = .black
        label.numberOfLines = 1
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    private lazy var btnSignUp: UIButton = {
        let b = UIButton()
        b.setTitle("Sign Up", for: .normal)
        b.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        b.setTitleColor(.black, for: .normal)
        b.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        return b
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    @objc func btnSignUpTapped(){
        
        let vc = SignUpVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    let imageView = UIImageView()

    func setupViews() {
        
        imageView.image = UIImage(named: "AppLogo")
       // imageView.frame = CGRect(x: 120, y: 64, width:149, height: 178)
        self.view.addSubview(imageView)

        
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.addSubview(contentViewBig)
        contentViewBig.addSubview(welcomeLabel)
        contentViewBig.addSubview(stackViewMain)
        contentViewBig.addSubview(loginBtn)
        contentViewBig.addSubview(lblNameText)
        contentViewBig.addSubview(btnSignUp)

        stackViewMain.addArrangedSubview(AppTextField(data: .email))
        stackViewMain.addArrangedSubview(AppTextField(data: .password))

        setupLayout()
    }

    func setupLayout() {
        contentViewBig.snp.makeConstraints { view in
            view.height.equalToSuperview().multipliedBy(0.7)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }

        welcomeLabel.snp.makeConstraints { lbl in
            lbl.leading.equalToSuperview().offset(82)
            lbl.trailing.equalToSuperview().offset(-82)
            lbl.top.equalTo(contentViewBig).offset(64)
        }

        stackViewMain.snp.makeConstraints { stack in
            stack.leading.equalToSuperview().offset(24)
            stack.trailing.equalToSuperview().offset(-24)
            stack.top.equalTo(welcomeLabel.snp.bottom).offset(41)
        }
        
        loginBtn.snp.makeConstraints({ btn in
            btn.leading.equalToSuperview().offset(24)
            btn.trailing.equalToSuperview().offset(-24)
            btn.bottom.equalTo(contentViewBig).inset(183)
            btn.height.equalTo(54)
            
        })
        lblNameText.snp.makeConstraints({lbl in
            lbl.bottom.equalTo(contentViewBig).inset(21)
            lbl.leading.equalTo(contentViewBig).inset(74)
        })
        btnSignUp.snp.makeConstraints({btn in
            btn.leading.equalTo(lblNameText.snp.trailing).offset(2)
            btn.centerY.equalTo(lblNameText)
        })
        
        imageView.snp.makeConstraints({ img in
            img.top.equalToSuperview().offset(54).constraint.isActive = true
            img.leading.equalToSuperview().offset(120)
            img.trailing.equalToSuperview().offset(-121)
        })

    }
}
