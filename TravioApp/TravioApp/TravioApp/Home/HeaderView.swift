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
    
    var btnTapAction: (()->Void)?
    
    private lazy var sectionView:UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var lblSectionTitle:UILabel = {
        let l = UILabel()
        l.text = "PlaceHolder"
        l.font = .Fonts.sectionTitle.font
        return l
    }()
    
    lazy var btnSeeAll:UIButton = {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 47, height: 21))
        b.setTitle("See All", for: .normal)
        b.titleLabel?.font = .Fonts.textFieldTitle.font
        b.setTitleColor(UIColor(named: "backgroundColor"), for: .normal)
        b.addTarget(self, action: #selector(self.btnSeeAllTapped), for: .touchUpInside)
        return b
    }()
    
    @objc func btnSeeAllTapped(sender:UIButton!){
        btnTapAction?()
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

        self.addSubviews(sectionView)
        sectionView.addSubviews(lblSectionTitle, btnSeeAll)
        
        setupLayout()
    }
    
    private func setupLayout(){

        sectionView.snp.makeConstraints({view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.width.equalToSuperview()
            
        })
        
        lblSectionTitle.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview()
            lbl.leading.equalToSuperview()

        })
        
        btnSeeAll.snp.makeConstraints({ btn in
            btn.top.equalTo(lblSectionTitle.snp.top).offset(1)
            btn.trailing.equalToSuperview().offset(16)
            btn.height.equalToSuperview()
//            btn.width.equalTo(btnSeeAll.frame.width)

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
