//
//  SignUpVC.swift
//  TravioIki
//
//  Created by web3406 on 10/25/23.
//

import UIKit

class SignUpVC: UIViewController {
    
    
    
    
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
        return signUpButton
    }()
    private lazy var leftBarButton: UIBarButtonItem = {
        let leftBarButton = UIBarButtonItem()
        leftBarButton.tintColor = .white
        leftBarButton.image = UIImage(named: "leftArrow")
        leftBarButton.target = self
        leftBarButton.action = #selector(backButtonTapped)
        return leftBarButton
    }()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
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
        
        
        stackViewMain.addArrangedSubviews(AppTextField(data: .username), AppTextField(data: .email), AppTextField(data: .password), AppTextField(data: .passwordConfirm))
        
        
        
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
