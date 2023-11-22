//
//  MapPresentCellVC.swift
//  TravioApp
//
//  Created by web3406 on 11/10/23.
//

import UIKit

class MapPresentCellVC: UICollectionViewCell, UINavigationControllerDelegate {
    
    // Cell Identifiers
    var lastSelectedImage: UIImage? 
    static let reuseIdentifier: String = "ImageCell"
    
    // View Model
    
    var viewModel = MapPresentVM()
    
    // Closures
    
    var presentClosure:((UIImagePickerController)->Void)?
    var dismissClosure:(()->Void)?
    
    // Cell UI Elements
    
    private lazy var cellView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
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
    lazy var changePhotoBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "exit"), for: .normal)
        return btn
    }()
    
    
    // Private Functions
    
    func fillCellWith(image:UIImage){
        self.cellView.image = image
        addPhotoBtn.isHidden = true
        addPhotoIcon.isHidden = true
    }
    
    // Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // UI Setup
    
    func setupViews() {

        /// Create background shadow for cell
        self.layer.shadowOpacity = 0.10
        self.layer.shadowRadius = 16
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.masksToBounds = true
        
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        
        self.addSubviews(cellView)
        
        cellView.addSubviews(changePhotoBtn, addPhotoIcon, addPhotoBtn)
        
        setupLayout()
    }
    
    // UI Layout
    
    func setupLayout() {
        
        cellView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(215)
            make.width.equalTo(270)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
            
        }
        
        changePhotoBtn.snp.makeConstraints({ btn in
            btn.top.equalToSuperview().offset(7)
            btn.leading.equalToSuperview().offset(7)
            btn.height.width.equalTo(15)
        })
        self.cellView.bringSubviewToFront(changePhotoBtn)
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
        
        MapPresentVC().showPreview().ignoresSafeArea(.all)
        MapPresentCellVC().showPreview()
    }
}
#endif
