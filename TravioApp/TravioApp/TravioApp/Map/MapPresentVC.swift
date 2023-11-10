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
        lbl.font = .Fonts.signUpTitle.font
        return lbl
        
    }()
    private lazy var textFieldDesciption: UITextView = {
        let textField = UITextView()
        // textField.numberOfLines = 0
        textField.font = .Fonts.textFieldText.font
        textField.text = "Lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lore İpsum lorem İpsum lorem İpsum"
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var btnAddPlace: UIButton = {
        let b = AppButton()
        b.setTitle("Add Place", for: .normal)
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
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private lazy var stackViewMain: UIStackView = {
        let stackViews = UIStackView()
        stackViews.backgroundColor = UIColor(named: "viewBackgroundColor")
        stackViews.axis = .vertical
        stackViews.spacing = 16
        return stackViews
    }()
    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MapPresentCellVC.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
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
        self.view.addSubviews(stackViewMain, imageCollectionView ,btnAddPlace)
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
            tf.height.equalTo(185)
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
        imageCollectionView.snp.makeConstraints ({ make in
            make.top.equalTo(stackViewMain.snp.bottom).offset(-16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(btnAddPlace.snp.top).offset(-16)
        })// dosya yükle limkleri al iki işlem
    }
}
extension MapPresentVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        // Görsel içeriği yükleme
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Görsel hücre boyutu
        return CGSize(width: 270, height: 154)
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
