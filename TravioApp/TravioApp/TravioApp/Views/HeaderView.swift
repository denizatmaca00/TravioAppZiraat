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
    //var delegate:SectionContentDelegate = nil
    
    var btnTapAction: (()->()) = { print("button tapped closure")}
    
    private lazy var sectionView:UIView = {
        let view = UIView()
        
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var lblSectionTitle:UILabel = {
        let l = UILabel()
        l.text = "Popular Placesxd"
        l.font = UIFont(name: "Poppins-Medium", size: 20)
        return l
    }()
    
    lazy var btnSeeAll:UIButton = {
        let b = UIButton()
        b.setTitle("See All", for: .normal)
        b.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        b.setTitleColor(UIColor(named: "backgroundColor"), for: .normal)
        //b.addTarget(self, action: #selector(self.btnSeeAllTapped), for: .touchUpInside)

        return b
    }()
    
    @objc private func btnSeeAllTapped(sender:UIButton!){
        btnTapAction()
        print(sender.tag)
        print("Command to See All inside objective")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //delegate.wakeButton()
        //self.btnSeeAll.addTarget(self, action: #selector(btnSeeAllTapped), for: .touchUpInside)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(titleText:String){
        lblSectionTitle.text = titleText
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = btnSeeAll.hitTest(point, with: event)
        
        if view == nil {
            view = super.hitTest(point, with: event)
        }
        return view
    }
    
    func wakeButton(){
        self.btnSeeAll.addTarget(self, action: #selector(self.btnSeeAllTapped), for: .touchUpInside)
    }
    
    private func setupView(){
        
        self.btnSeeAll.addTarget(self, action: #selector(btnSeeAllTapped), for: .touchUpInside)

        self.addSubviews(sectionView)
        sectionView.addSubviews(lblSectionTitle, btnSeeAll)
        
        setupLayout()
    }
    
    private func setupLayout(){

        sectionView.snp.makeConstraints({view in
            view.top.equalToSuperview().offset(55-8)
            view.leading.equalToSuperview().offset(24)
            view.width.equalToSuperview().offset(-26)
        })
        
        lblSectionTitle.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview()
            lbl.leading.equalToSuperview()

        })
        
        btnSeeAll.snp.makeConstraints({ btn in
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
