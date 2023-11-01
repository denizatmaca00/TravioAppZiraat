//
//  HeaderView.swift
//  TravioApp
//
//  Created by Aydın Erol on 31.10.2023.
//

import Foundation
import UIKit
import SnapKit

class HeaderView: UICollectionReusableView {
    
    static let reuseId = "HeaderView"
    
    lazy var lblSectionTitle:UILabel = {
        let l = UILabel()
        l.text = "Popular Placesxd"
        l.font = UIFont(name: "Poppins-Medium", size: 20)
        return l
    }()
    
    private lazy var btnSeeAll:UIButton = {
        let b = UIButton()
        b.setTitle("See All", for: .normal)
        b.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        b.setTitleColor(UIColor(named: "backgroundColor"), for: .normal)
        b.addTarget(self, action: #selector(btnSeeAllTapped), for: .touchUpInside)
        return b
    }()
    
    @objc func btnSeeAllTapped(){
        print("Command")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(titleText:String){
        lblSectionTitle.text = titleText
    }
    
    private func setupView(){
        
        addSubviews(lblSectionTitle)
        self.addSubviews(lblSectionTitle, btnSeeAll)
        
        setupLayout()
    }
    
    private func setupLayout(){
        
        lblSectionTitle.snp.makeConstraints({lbl in

            lbl.top.equalToSuperview().offset(55-8)
            lbl.leading.equalToSuperview().offset(24)

        })

        btnSeeAll.snp.makeConstraints({btn in
            btn.centerY.equalTo(lblSectionTitle).offset(4)
            btn.trailing.equalToSuperview()

        })
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct HomeHeaderVC_Preview: PreviewProvider {
    static var previews: some View{

        HomeVC().showPreview()
    }
}
#endif
