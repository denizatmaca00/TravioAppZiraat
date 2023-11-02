//
//  SettingsVC.swift
//  TravioApp
//
//  Created by web3406 on 11/2/23.
//

import UIKit

class SettingsVC: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogo")
        return imageView
    }()
    
    private lazy var contentViewBig: UIView = {
       let view = UIView()
       view.backgroundColor = UIColor(named: "viewBackgroundColor")
       view.clipsToBounds = true
       view.layer.cornerRadius = 80
       view.layer.maskedCorners = [.layerMinXMinYCorner]
       return view
   }()
    
    private lazy var label: AppLabel = {
       let lbl = AppLabel()
        lbl.text = "Securtiy Settings"
        lbl.sideView = .left(image: UIImage(systemName: "arrow.fill"))
       return lbl
   }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        
    }
    func setupViews() {
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.addSubviews(contentViewBig)
        contentViewBig.addSubviews(imageView, label)
        
        setupLayout()
    }

    func setupLayout() {
        
        label.snp.makeConstraints({ lbl in
            lbl.top.equalTo(imageView.snp.bottom).offset(74)
            lbl.trailing.equalTo(contentViewBig).offset(-16)
            lbl.leading.equalTo(contentViewBig).offset(16)
        })
        imageView.snp.makeConstraints({ img in
            img.top.equalTo(contentViewBig).offset(24)
            //img.centerX.equalTo(contentViewBig)
            img.leading.equalTo(contentViewBig).offset(135)
            img.trailing.equalTo(contentViewBig).offset(-135)
            img.height.equalTo(120)
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
struct SettingsVC_Preview: PreviewProvider {
    static var previews: some View{

        SettingsVC().showPreview()
    }
}
#endif
