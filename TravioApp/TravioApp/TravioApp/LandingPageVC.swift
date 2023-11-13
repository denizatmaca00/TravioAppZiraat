//
//  LandingPageVC.swift
//  TravioApp
//
//  Created by Aydın Erol on 13.10.2023.
//

import UIKit
import SnapKit
import TinyConstraints

class LandingPageVC: UIViewController {
    
    private lazy var stackLanding:UIStackView =
    {
        let sv = UIStackView()
        sv.distribution = .fillProportionally
        sv.axis = .vertical
        
        return sv
    }()
    
    private lazy var imgViewAppLogo:UIImageView =
    {
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: 0, width: 149, height: 178)
        let img = UIImage(named: "AppLogo")
        imgView.image = img
        
        return imgView
    }()
    
    private lazy var lblLanding:UILabel =
    {
        let lbl = UILabel()
        lbl.text = "Discover the world"
        lbl.font = .Fonts.landingHeader.font
        lbl.textColor = UIColor(named: "titleColor")
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView()
    {
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        self.view.addSubview(stackLanding)
        stackLanding.addSubviews(imgViewAppLogo,lblLanding)
        
        setupLayout()
        
        let vc = LoginVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func setupLayout()
    {
        stackLanding.snp.makeConstraints({ sv in
            sv.top.equalToSuperview().offset(213-36)
            sv.bottom.equalToSuperview().inset(402-36)
            sv.leading.equalToSuperview().offset(76)
            sv.trailing.equalToSuperview().inset(76)
            
        })
        
        imgViewAppLogo.snp.makeConstraints({ img in
            img.top.equalToSuperview()
            img.leading.equalToSuperview().offset(120-76)
            img.trailing.equalToSuperview().inset(120-76)
            
        })
        
        lblLanding.snp.makeConstraints({ lbl in
            lbl.top.equalTo(imgViewAppLogo.snp.bottom).offset(11)
            lbl.bottom.equalToSuperview()
            lbl.leading.equalToSuperview()
            lbl.trailing.equalToSuperview()
            
        })
        
    }

}


#if DEBUG

import SwiftUI

@available(iOS 13, *)
struct LandingPageVC_Preview:PreviewProvider {
    static var previews: some View{
        
        LandingPageVC().showPreview()
    }
}
#endif
