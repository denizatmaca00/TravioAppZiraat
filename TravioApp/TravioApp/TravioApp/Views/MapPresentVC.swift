//
//  MapPresentVC.swift
//  TravioApp
//
//  Created by web3406 on 11/1/23.
//

import UIKit

class MapPresentVC: UIViewController {
    
    private lazy var mapAddTitle = AppTextField(data: .presentMapTitle)
   // private lazy var mapAddDescription = AppTextField(data: .presentMapDescription)
    private lazy var mapAddLocation = AppTextField(data: .presentMapLocation)
    
    private lazy var txtTitle = mapAddTitle.getTFAsObject()
 //   private lazy var txtDescription = mapAddDescription.getTFAsObject()
    private lazy var txtLocation = mapAddLocation.getTFAsObject()
    
    private lazy var titleDescrpition: UILabel = {
        let lbl = UILabel()
        lbl.text = "Visit Description"
        lbl.textColor = .black
        lbl.font = UIFont(name: "Poppins-Medium", size: 14)
        return lbl
        
    }()
    private lazy var textFieldDesciption: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "Poppins-Regular", size: 12)
        textField.placeholder = "Lorem İpsum"
        return textField
    }()

    private lazy var btnAddPlace: UIButton = {
        let b = UIButton()
        b.setTitle("Add Place", for: .normal)
        b.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 16)
        b.backgroundColor = UIColor(named: "backgroundColor")
        b.layer.cornerRadius = 12
        b.setTitleColor(.white, for: .normal)
        b.addTarget(self, action: #selector(btnAddPlaceTapped), for: .touchUpInside)
        return b
        
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.layer.cornerRadius = 16
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.layer.shadowRadius = 20
        stackView.layer.shadowOpacity = 0.15
        stackView.backgroundColor = UIColor(named: "textColorReversed")
        return stackView
    }()
    
    private lazy var stackViewMain: UIStackView = {
        let stackViews = UIStackView()
        stackViews.backgroundColor = UIColor(named: "viewBackgroundColor")
        stackViews.axis = .vertical
        stackViews.spacing = 16
        return stackViews
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    @objc func btnAddPlaceTapped() {
        print("eklendi")
        print(txtTitle.text!)
        //print(txtDescription.text!)
        print(txtLocation.text!)
        
        
    }
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor(named: "viewBackgroundColor")
        self.view.addSubviews(stackViewMain, btnAddPlace)
        stackView.addArrangedSubviews(titleDescrpition,textFieldDesciption)

        stackViewMain.addArrangedSubviews(mapAddTitle,stackView, mapAddLocation)
        
        setupLayout()
    }
    
    func setupLayout() {
        let limits = self.view.safeAreaLayoutGuide.snp
 
        titleDescrpition.snp.makeConstraints({ lbl in
            lbl.top.equalTo(stackView).offset(8)
            lbl.leading.equalToSuperview().offset(12)
        })
        textFieldDesciption.snp.makeConstraints({tf in
            tf.top.equalTo(titleDescrpition.snp.bottom).offset(8)
            tf.height.equalTo(215)
        })
        
        stackViewMain.snp.makeConstraints { stack in
            stack.leading.equalToSuperview().offset(24)
            stack.trailing.equalToSuperview().offset(-24)
            stack.top.equalToSuperview().offset(72)
        }
        
        btnAddPlace.snp.makeConstraints({ btn in
            btn.bottom.equalTo(limits.bottom).offset(-23)
            btn.trailing.equalToSuperview().offset(-24)
            btn.leading.equalToSuperview().offset(24)
            btn.height.equalTo(54)
        })
    }
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct MapPresentVC_Preview: PreviewProvider {
    static var previews: some View{
         
        MapPresentVC().showPreview()
    }
}
#endif
