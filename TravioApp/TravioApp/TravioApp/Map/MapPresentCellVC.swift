//
//  MapPresentCellVC.swift
//  TravioApp
//
//  Created by web3406 on 11/10/23.
//

import UIKit

class MapPresentCellVC: UICollectionViewCell {
    
    weak var delegate: MapPresentCellDelegate?

    var viewModel = MapVM()
    
    var visitCellViewModel: VisitCellViewModel? {
        didSet {
            
        }
    }
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
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
        btn.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
        
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
    @objc func addPhotoButtonTapped() {
           delegate?.presentImagePicker()
        print("add photo butonuna basıldı mı")
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

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct MapPresentCellVC_Preview: PreviewProvider {
    static var previews: some View{

        MapPresentCellVC().showPreview()
    }
}
#endif
