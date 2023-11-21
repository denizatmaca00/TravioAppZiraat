//
//  MapPresentVC.swift
//  TravioApp
//
//  Created by web3406 on 11/1/23.
//

import UIKit

class MapPresentVC: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {
    
    let viewModel = MapPresentVM()
    
    var latitude: Double?
    var longitude: Double?
    
    var updateMapClosure: (() -> Void)?
    
    private lazy var mapAddTitle = AppTextField(data: .presentMapTitle)
    private lazy var mapAddLocation = AppTextField(data: .presentMapLocation)
    
    private lazy var txtTitle = mapAddTitle.getTFAsObject()
    private lazy var txtLocation = mapAddLocation.getTFAsObject()
    
    private lazy var titleDescrpition: UILabel = {
        let lbl = UILabel()
        lbl.text = "Visit Description"
        lbl.textColor = .black
        lbl.font = .Fonts.signUpTitle.font
        return lbl
        
    }()
    
    private lazy var textFieldDescription: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.text = "Lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lorem İpsum lore İpsum lorem İpsum lorem İpsum"
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        return textView
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
        collectionView.register(MapPresentCellVC.self, forCellWithReuseIdentifier: MapPresentCellVC.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.dismissClosure = {
            self.dismiss(animated: true)
        }
        
        /// Initiate alert closure to present alerts
        viewModel.showAlertClosure = { [weak self] title, message in
            self?.showAlert(title: title, message: message){
                
            }
        }
        
        /// Initiate activity indicator view to be initiated via updateLoadingStatus closure
        viewModel.updateLoadingStatus = { [weak self] (isLoading) in
            DispatchQueue.main.async {
                switch self!.viewModel.isLoading{
                case true:
                    self?.showIndicator()
                case false:
                    self?.hideIndicator()
                }
            }
        }
    }
    
    @objc func btnAddPlaceTapped() {
        
        let placeInfo = AddPlace(place: txtLocation.text!, title: txtTitle.text!, description: textFieldDescription.text, cover_image_url: "", latitude: latitude!, longitude: longitude!)
        
        viewModel.placeInfo = placeInfo
        
        self.viewModel.savePlace()
    }
    
    private lazy var imagePicker:UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    func initPicker (){
        viewModel.picker = imagePicker
        present(viewModel.picker!, animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor(named: "viewBackgroundColor")
        self.view.addSubviews(stackViewMain, imageCollectionView ,btnAddPlace)
        stackView.addArrangedSubviews(titleDescrpition,textFieldDescription)
        
        stackViewMain.addArrangedSubviews(mapAddTitle,stackView, mapAddLocation)
        
        setupLayout()
    }
    
    func setupLayout() {
        let limits = self.view.safeAreaLayoutGuide.snp
        
        titleDescrpition.snp.makeConstraints({ lbl in
            lbl.top.equalTo(stackView).offset(8)
            lbl.leading.equalToSuperview().offset(12)
        })
        
        textFieldDescription.snp.makeConstraints { make in
            make.top.equalTo(titleDescrpition.snp.bottom).offset(8)
            // make.leading.equalTo(view).offset(20)
            // make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(185)
        }
        
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
        })
    }
}

extension MapPresentVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapPresentCellVC.reuseIdentifier, for: indexPath) as? MapPresentCellVC else {fatalError("Cell is not found")}
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MapPresentCellVC else {return}
        
        /// initiate picker view from viewModel
        self.initPicker()
        
        /// initiate reload CV closure in viewModel
        viewModel.reloadCollectionViewClosure = {
            DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
            }
            self.viewModel.fetchData(in: cell, with: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /// Cell size
        return CGSize(width: 270, height: 154)
    }
}

extension MapPresentVC: UIImagePickerControllerDelegate{
    
    func pickerCloseEvents(_ picker: UIImagePickerController){
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage{
            viewModel.imageArray.append(selectedImage)
            viewModel.lastImage = selectedImage
            pickerCloseEvents(picker)
            viewModel.reloadCollectionViewClosure!()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerCloseEvents(picker)
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
