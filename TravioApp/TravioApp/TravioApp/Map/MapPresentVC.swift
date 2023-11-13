//
//  MapPresentVC.swift
//  TravioApp
//
//  Created by web3406 on 11/1/23.
//

import UIKit

class MapPresentVC: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {
    func presentImagePicker() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    var latitude: Double?
       var longitude: Double?
    var updateMapClosure: (() -> Void)?

    let viewModel = MapPresentVM()
    
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
        collectionView.register(MapPresentCellVC.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private lazy var imagePicker: UIImagePickerController = {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.allowsEditing = false
            return picker
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

    }
    
    @objc func btnAddPlaceTapped() {
        print(txtTitle.text!)
        //print(txtDescription.text!)
        print(txtLocation.text!)
        print(self.latitude)
        print(self.longitude)
 
        viewModel.postAddNewPlace(place: txtLocation.text!, title: txtTitle.text!, description: textFieldDescription.text, cover_image_url: "http.png", latitude: latitude!, longitude: longitude!, completion: { [weak self] result in
            switch result {
            case .success(let response):
                if let messages = response.message {
                    print(messages)
                    print(response.message)
                    print(self!.latitude)
                    print(self!.longitude)
                    // presenti dismiss et mapi reload et
                    self!.dismiss(animated: true)
                    self?.updateMapClosure?()

                    }
            case .failure(let error):
                print("Error: \(error)")

            }
        })
        MapVC().initVM()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }

//        func textViewDidEndEditing(_ textView: UITextView) {
//            if textView.text.isEmpty {
//                textView.text = "Placeholder metni"
//                textView.textColor = UIColor.lightGray
//            }
//        }
    
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
//        textFieldDesciption.snp.makeConstraints({tf in
//            tf.top.equalTo(titleDescrpition.snp.bottom).offset(8)
//            tf.height.equalTo(185)
//        })
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

extension MapPresentVC: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            // Seçilen fotoğrafı işleyebilirsin yine

            handlePickedImage(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func handlePickedImage(_ image: UIImage) {
        // Seçilen fotoğrafı işleyecek
        // imageview içine koysan daha iyi olaiblir
        
        // Daha sonra bu fotoğrafı API'ye yükle
        uploadPhoto(image: image)
    }

    func uploadPhoto(image: UIImage) {
        // Fotoğrafı API'ye yüklemek için kullanıcı tanımlı bir fonksiyon
        // Önce fotoğrafı bir veriye dönüştürüp, ardından bu veriyi kullanarak API çağrısı yapabilirsiniz
        // API çağrısını gerçekleştiren bir fonksiyonunuz varsa, onu kullanabilirsiniz
        let uploadRouter = Router.uploadAddPhoto(params: ["yourParam": "value"])

        NetworkingHelper.shared.uploadPhoto(image: image, urlRequest: uploadRouter) { (result: Result<AddPhotoUploadMultipart, Error>) in
            switch result {
            case .success(let uploadResult):
                //  yüklendi
                print("Upload success: \(uploadResult)")
            case .failure(let error):
                // Hata 
                print("Upload failure: \(error)")
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
