//
//  TermsOfUseVC.swift
//  TravioApp
//
//  Created by web3406 on 11/6/23.
//

import UIKit

class TermsOfUseVC: UIViewController {
    private lazy var contentViewBig: AppView = {
        let view = AppView()
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Terms Of Use"
        lbl.textColor = .white
        lbl.font = UIFont(name: "Poppins-Medium", size: 32)
        return lbl
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
        
        setupViews()
    }
    
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    func setupViews() {
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.addSubviews(contentViewBig, titleLabel, leftBarButton)
        setupLayout()
    }
    
    func setupLayout() {
        let limits = self.view.safeAreaLayoutGuide.snp
        
        leftBarButton.snp.makeConstraints({ btn in
            btn.centerY.equalTo(titleLabel)
            btn.leading.equalToSuperview().offset(24)
            btn.height.width.equalTo(20)
        })
        
        titleLabel.snp.makeConstraints({ lbl in
            lbl.top.equalToSuperview().offset(60)
            lbl.leading.equalTo(leftBarButton.snp.trailing).offset(24)
        })
        contentViewBig.snp.makeConstraints ({ view in
            view.height.equalToSuperview().multipliedBy(0.8)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        })
    }
}
#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct TermsOfUseVC_Preview: PreviewProvider {
    static var previews: some View{
        
        TermsOfUseVC().showPreview().ignoresSafeArea(.all)
    }
}
#endif