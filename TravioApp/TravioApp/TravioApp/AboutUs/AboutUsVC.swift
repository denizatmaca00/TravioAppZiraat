//
//  AboutUsVC.swift
//  TravioApp
//
//  Created by web3406 on 11/6/23.
//

import UIKit

class AboutUsVC: UIViewController {
    private lazy var contentViewBig: AppView = {
        let view = AppView()
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "About Us"
        lbl.textColor = .white
        lbl.font = .Fonts.pageHeader32.font
        return lbl
    }()
    private lazy var leftBarButton: UIButton = {
        let leftBarButton = UIButton()
        leftBarButton.tintColor = .white
        leftBarButton.setImage(UIImage(named: "leftArrow"), for: .normal)
         leftBarButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return leftBarButton
    }()
    override func viewDidLoad()
    {
        view.backgroundColor = UIColor(named: "backgroundColor")

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
            view.bottom.equalToSuperview()        })
    }
}



#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct AboutUsVC_Preview: PreviewProvider {
    static var previews: some View{
        
        AboutUsVC().showPreview().ignoresSafeArea(.all)
    }
}
#endif
