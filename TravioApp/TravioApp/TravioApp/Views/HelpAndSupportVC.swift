//
//  
//  HelpAndSupportVC.swift
//  TravioApp
//
//  Created by Aydın Erol on 2.11.2023.
//
//
import UIKit
import TinyConstraints
import SnapKit

class HelpAndSupportVC: UIViewController {
    
    //MARK: -- Properties
    
    private lazy var lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.text = "Help&Support"
        lbl.textColor = .white
        lbl.font = UIFont(name: "Poppins-Bold", size: 32)
        return lbl
    }()
    
    private lazy var leftBarButton: UIBarButtonItem = {
        let leftBarButton = UIBarButtonItem()
        leftBarButton.tintColor = .white
        leftBarButton.image = UIImage(named: "leftArrow")
        leftBarButton.target = self
        leftBarButton.action = #selector(backButtonTapped)
        return leftBarButton
    }()
    
    //MARK: -- Views
    
    private lazy var contentViewBig: UIView = {
       let view = UIView()
       view.backgroundColor = UIColor(named: "viewBackgroundColor")
       view.clipsToBounds = true
       view.layer.cornerRadius = 80
       view.layer.maskedCorners = [.layerMinXMinYCorner]
       return view
   }()
    
    //MARK: -- Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupViews()
       
    }
    
    //MARK: -- Component Actions
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: -- Private Methods
    
    
    //MARK: -- UI Methods
    
    func setupViews() {
        // Add here the setup for the UI
        self.view.backgroundColor = UIColor(named: "backgroundColor")
//        self.title = "Help&Support"
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        self.view.addSubviews(lblHeader, contentViewBig)
        
        setupLayout()
    }
    
    func setupLayout() {
        
        let limits = self.view.safeAreaLayoutGuide.snp
        self.navigationItem.titleView?.layer
        let startY = self.view.bounds.origin.y + 50
        
        // Add here the setup for layout
        contentViewBig.snp.makeConstraints ({ view in
            view.height.equalToSuperview().multipliedBy(0.8)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        })
        
        lblHeader.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(startY)
            lbl.leading.equalToSuperview().offset(72)
        })
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct HelpAndSupportVC_Preview: PreviewProvider {
    static var previews: some View{
        
        HelpAndSupportVC().showPreview().ignoresSafeArea(.all)
    }
}
#endif
