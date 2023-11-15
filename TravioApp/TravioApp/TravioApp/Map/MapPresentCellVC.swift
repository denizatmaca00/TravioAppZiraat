//
//  MapPresentCellVC.swift
//  TravioApp
//
//  Created by web3406 on 11/10/23.
//

import UIKit

class MapPresentCellVC: UICollectionViewCell, UIImagePickerControllerDelegate {


    var viewModel = MapPresentVM()
    
    var visitCellViewModel: VisitCellViewModel? {
        didSet {
            
        }
    }
    
    private lazy var cellView: UIImageView = {
        let view = UIImageView()
        let img = UIImage(named: "sultanahmet")
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
    
    lazy var addPhotoBtn: UILabel = {
        let lbl = UILabel()
        lbl.text = "Add Photo"
        lbl.font = .Fonts.textFieldText.font
        lbl.textColor = UIColor(named: "inactiveButtonColor")
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    func setupViews() {
        
        self.addSubviews(cellView)
        cellView.addSubviews(addPhotoIcon, addPhotoBtn)
        
        setupLayout()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage{
            cellView.image = selectedImage
            viewModel.imageData.append(selectedImage)
            
            print("avemaria \(selectedImage)")
        }
    }
    
    func setImage(){
        
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

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct MapPresentCellVC_Preview: PreviewProvider {
    static var previews: some View{

        MapPresentCellVC().showPreview()
    }
}
#endif
