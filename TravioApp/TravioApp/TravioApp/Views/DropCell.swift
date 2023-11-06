//
//  
//  DropCell.swift
//  TravioApp
//
//  Created by Aydın Erol on 2.11.2023.
//
//
import UIKit
import TinyConstraints
import SnapKit

class DropCell: UITableViewCell {
    
    static let reuseIdentifier = "ExpandableCell"
    
    //MARK: -- Properties
    
//    var isExpanded:Bool = false
    
    var dropCellViewModel:DropCellViewModel? {
        didSet{
            lblHeader.text = dropCellViewModel?.title
            lblDescription.text = dropCellViewModel?.description
            lblDescription.isHidden = !dropCellViewModel!.isExpanded
            print("\(!dropCellViewModel!.isExpanded)")
            imgDropButton.image = (dropCellViewModel!.isExpanded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down"))?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    var setHeightClosure: ()-> CGFloat = {return 73}
    
    private lazy var lblHeader: UILabel = {
        let lbl = UILabel()
        lbl.text = "placeHolderTitle"
        lbl.font = UIFont(name: "Poppins-Medium", size: 14)
        lbl.textColor = UIColor(named: "textColor")
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        lbl.font = UIFont(name: "Poppins-Regular", size: 10)
        lbl.textColor = UIColor(named: "textColor")
//        lbl.isHidden = false
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()
    
    //MARK: -- Views
    
    lazy var dropView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.45
        view.layer.maskedCorners = [.layerMinXMinYCorner]
        return view
    }()
    private lazy var viewSpace:UIView = {
        let v = UIView()
        return v
    }()
    
    private lazy var imgDropButton:UIImageView = {
        let imgView = UIImageView(image: UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysOriginal))
        //let img = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysOriginal)
        //imgView.image = img
        
        return imgView
    }()
    
    //MARK: -- Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -- Component Actions
    
    //MARK: -- Private Methods
    
    //MARK: -- UI Methods
    
    private func setupViews() {
        // Add here the setup for the UI
        self.selectionStyle = .none
        self.addSubviews(dropView)
        dropView.addSubviews(lblHeader, imgDropButton, lblDescription)
        
        setupLayout()
    }
    
    private func setupLayout() {
        // Add here the setup for layout
        dropView.snp.makeConstraints({ dv in
            dv.top.equalToSuperview()
            dv.bottom.equalToSuperview()
            dv.leading.equalToSuperview()
            dv.trailing.equalToSuperview()
            
        })
        
        lblHeader.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(16)
            lbl.bottom.equalTo(lblDescription.snp.top).offset(-12)
            lbl.leading.equalToSuperview().offset(12)
            lbl.trailing.equalToSuperview().offset(-12*4)
            
        })
        
        lblDescription.snp.makeConstraints({ lbl in
            lbl.top.equalTo(lblHeader.snp.bottom)
            lbl.bottom.equalToSuperview()
            lbl.leading.equalTo(lblHeader)
            lbl.trailing.equalToSuperview().offset(-15)
            
        })
        
        imgDropButton.snp.makeConstraints({ img in
            img.top.equalTo(lblHeader.snp.bottom)
            img.bottom.equalTo(lblHeader.snp.bottom).offset(-lblHeader.frame.height/1.5)
            img.trailing.equalToSuperview().offset(-18.37)
            
        })
        
//        viewSpace.snp.makeConstraints({ view in
//            view.top.equalTo(dropView.snp.bottom)
//
//        })
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct DropCell_Preview: PreviewProvider {
    static var previews: some View{
        
        DropCell().showPreview()
    }
}
#endif
