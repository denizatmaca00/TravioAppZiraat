//
//  MapPresentVC.swift
//  TravioApp
//
//  Created by web3406 on 11/1/23.
//

import UIKit
import CoreLocation

class MapPresentVC: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {
    
    let viewModel = MapPresentVM()
    var mapReloadClosure: (()-> Void)?
    var latitude: Double?
    var longitude: Double?
    var localName: String?{
        didSet{
            if localName!.count > 2{
                mapAddLocation.textField.text = localName
            }
        }
    }
    
    var delegate: ReloadData?
    private lazy var mapAddTitle = CustomTextField(title: "Place Name", placeholder: "Please write a place name", icon: nil, iconPosition: .none)
    private lazy var mapAddLocation = CustomTextField(title: "Country, City", placeholder: "France, Paris", icon: nil, iconPosition: .none)

    
    private lazy var titleDescrpition: UILabel = {
        let lbl = UILabel()
        lbl.text = "Visit Description"
        lbl.textColor = .black
        lbl.font = .Fonts.signUpTitle.font
        return lbl
        
    }()
    
    private lazy var textFieldDescription: UITextView = {
        let textView = UITextView()
        textView.font = .Fonts.textFieldText.font
        textView.text = "Description"
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
        layout.minimumLineSpacing = -24
  
        layout.estimatedItemSize = CGSize(width: 270+48, height: 215)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MapPresentCellVC.self, forCellWithReuseIdentifier: MapPresentCellVC.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //buraya unwarpp gerek
        self.getLocalName(latitude: self.latitude!, longitude: self.longitude!)
    }
    override func viewWillDisappear(_ animated: Bool) {
        mapReloadClosure?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        /// Closure to dismiss PresentVC
        viewModel.dismissClosure = {
            self.dismiss(animated: true, completion: { [self] in
                delegate?.reloadMapData()
            })
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
        
        let placeInfo = AddPlace(place: mapAddLocation.textField.text!, title: mapAddTitle.textField.text!, description: textFieldDescription.text, cover_image_url: "", latitude: latitude!, longitude: longitude!)
        
        viewModel.placeInfo = placeInfo
        
        self.viewModel.savePlace()
        
    }
    
    private lazy var imagePicker:UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePicker.sourceType = sourceType
            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlert(title: "Error", message: "Selected source type is not available.", completion: {})
        }
    }

    func showImagePicker(for indexPath: IndexPath) {
        imagePicker.delegate = self
        imagePicker.view.tag = indexPath.item

        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.presentImagePicker(sourceType: .camera)
        }

        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { [weak self] _ in
            self?.presentImagePicker(sourceType: .photoLibrary)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        self.addActionSheet(title: "Added Photo", message: "Choose Your Way", actions: [cameraAction, galleryAction, cancelAction])
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor(named: "viewBackgroundColor")
        
        self.view.addSubviews(stackViewMain, imageCollectionView, btnAddPlace)
        
        stackView.addArrangedSubviews(titleDescrpition, textFieldDescription)
        
        stackViewMain.addArrangedSubviews(mapAddTitle, stackView, mapAddLocation)
        
        setupLayout()
    }
    
    func setupLayout() {
        let limits = self.view.safeAreaLayoutGuide.snp
        
        titleDescrpition.snp.makeConstraints({ lbl in
            lbl.top.equalTo(stackView).offset(8)
            lbl.leading.equalToSuperview().offset(12)
        })

        textFieldDescription.snp.makeConstraints ({ make in
           // make.top.equalTo(titleDescrpition.snp.bottom).offset(8)
            make.leading.equalTo(view).offset(34.5)
            make.bottom.equalTo(stackView).offset(-20)
            make.trailing.equalToSuperview().offset(-15)
           // make.bottom.equalTo(stackView).offset(50)
        })
        
        stackViewMain.snp.makeConstraints ({ stack in
            stack.leading.equalToSuperview().offset(24)
            stack.trailing.equalToSuperview().offset(-24)
            stack.top.equalToSuperview().offset(40)
        })
        
        btnAddPlace.snp.makeConstraints({ btn in
            btn.bottom.equalTo(limits.bottom).offset(-23)
            btn.trailing.equalToSuperview().offset(-24)
            btn.leading.equalToSuperview().offset(24)
            btn.height.equalTo(54)
        })
        
        imageCollectionView.snp.makeConstraints ({ make in
            make.top.equalTo(mapAddLocation.snp.bottom).offset(16)
            make.height.equalTo(215)
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
        showImagePicker(for: indexPath)
        
        /// initiate reload CV closure in viewModel

        viewModel.reloadCollectionViewClosure = {
            DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
            }
            
        }
    }
}

extension MapPresentVC: UIImagePickerControllerDelegate{
    
    func pickerCloseEvents(_ picker: UIImagePickerController){
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        let indexPath = IndexPath(item: picker.view.tag, section: 0)
        
        if let cell = imageCollectionView.cellForItem(at: indexPath) as? MapPresentCellVC {

            cell.cellView.image = selectedImage

            
            if indexPath.item < viewModel.imageArray.count {

                (viewModel.imageArray[indexPath.item] = selectedImage)
                cell.addPhotoBtn.isHidden = true
                cell.addPhotoIcon.isHidden = true
            }
            else {

                viewModel.imageArray.append(selectedImage)
                cell.addPhotoBtn.isHidden = true
                cell.addPhotoIcon.isHidden = true

            }
            viewModel.reloadCollectionViewClosure = {
                DispatchQueue.main.async {
                    self.imageCollectionView.reloadData()
                }
            }
            
        }

        pickerCloseEvents(picker)
        

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerCloseEvents(picker)
    }
}

// Helper method to get closest district/city name for given latitude:longitude coordinates
extension MapPresentVC {
    // This function can be used to create cellView with city data obtained by Lat:Long data in favorites array
    func getLocalName(latitude:Double, longitude:Double){
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks , error in
            
            if error == nil && placemarks!.count > 0 {
                guard let placemark = placemarks?.last else {
                    return
                }
                let city = placemark.locality ?? " "
                if let country = placemark.country {
                    self.localName = "\(country), \(city)"
                } else{
                    self.localName = "\(city)"
                }
            }
        }
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

