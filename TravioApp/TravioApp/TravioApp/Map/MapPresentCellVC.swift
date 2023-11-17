//
//  MapPresentCellVC.swift
//  TravioApp
//
//  Created by web3406 on 11/10/23.
//

import UIKit

class MapPresentCellVC: UICollectionViewCell, UINavigationControllerDelegate {
    
    
    var viewModel = MapPresentVM()
    
    var presentClosure:((UIImagePickerController)->Void)?
    var dismissClosure:(()->Void)?
    
    private lazy var cellView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var addPhotoIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "addPhoto")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy var addPhotoBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Add Photo", for: .normal)
        btn.setTitleColor(UIColor(named: "inactiveButtonColor"), for: .normal)
        btn.titleLabel?.font = .Fonts.textFieldText.font
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func imagePicker (){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        presentClosure!(picker)
    }
    
    func setupViews() {
        
        self.addSubviews(cellView)
        cellView.addSubviews(addPhotoIcon, addPhotoBtn)
        
        setupLayout()
    }
    
    func setupLayout() {
        
        cellView.snp.makeConstraints { make in
            make.height.equalTo(180)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(270)
        }
        
        addPhotoIcon.snp.makeConstraints { make in
            make.top.equalTo(cellView).offset(79)
            make.height.equalTo(35)
            make.centerX.equalTo(cellView)
        }
        
        addPhotoBtn.snp.makeConstraints({lbl in
            lbl.top.equalTo(addPhotoIcon.snp.bottom)
            lbl.centerX.equalTo(cellView)
        })
    }
}

extension MapPresentCellVC:UIImagePickerControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage{
            cellView.image = selectedImage
            viewModel.imageData.append(selectedImage)
            dismissClosure!()
        }
    }
    
    func handlePickedImage(_ image: UIImage) {
        // Seçilen fotoğrafı işleyecek
        // imageview içine koysan daha iyi olaiblir
        
        // Daha sonra bu fotoğrafı API'ye yükle
        //  uploadPhoto(image: image)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct MapPresentCellVC_Preview: PreviewProvider {
    static var previews: some View{
        
        MapPresentVC().showPreview().ignoresSafeArea(.all)
        MapPresentCellVC().showPreview()
    }
}
#endif
