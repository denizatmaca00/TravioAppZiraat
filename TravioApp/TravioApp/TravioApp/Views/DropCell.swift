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
    
    //MARK: -- Properties
    
    var isExpanded:Bool = false
    
    var dropCellViewModel:DropCellViewModel? {
        didSet{
            lblHeader.text = dropCellViewModel?.title
            lblDescription.text = dropCellViewModel?.description
        }
    }
    
    private lazy var lblHeader: UILabel = {
        let lbl = UILabel()
        lbl.text = "placeHolderTitle"
        lbl.font = UIFont(name: "Poppins-Medium", size: 14)
        lbl.textColor = UIColor(named: "textColor")
        return lbl
    }()
    
    private lazy var lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.text = "placeHolderDescription"
        lbl.font = UIFont(name: "Poppins-Regular", size: 10)
        lbl.textColor = UIColor(named: "textColor")
        return lbl
    }()
    
    //MARK: -- Views
    
    private lazy var dropView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner]
        return view
    }()
    
    private lazy var imgDropButton:UIImageView = {
        let imgView = UIImageView()
        let img = UIImage(systemName: "drop")?.withRenderingMode(.alwaysOriginal)
        imgView.image = img
        
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
    func setContent(){
        self.lblHeader.text = ""
        self.lblDescription.text = ""
    }
    
    //MARK: -- Private Methods
    
    
    //MARK: -- UI Methods
    private func setupViews() {
        // Add here the setup for the UI
        self.backgroundColor = UIColor(named: "viewBackgroundColor")
        self.backgroundColor = .systemGray3
        self.addSubviews(dropView)
        dropView.addSubviews(lblHeader, imgDropButton, lblDescription)
        
        setupLayout()
    }
    
    private func setupLayout() {
        // Add here the setup for layout
        dropView.snp.makeConstraints({ dv in
            dv.leading.equalToSuperview().offset(24)
            dv.trailing.equalToSuperview().offset(-24)
            dv.height.equalTo(73)
            dv.center.equalToSuperview()
            
        })
        
        lblHeader.snp.makeConstraints({lbl in
            lbl.centerY.equalToSuperview()
            lbl.leading.equalToSuperview().offset(12)
            
        })
        
        lblDescription.snp.makeConstraints({ lbl in
            lbl.top.equalTo(lblHeader).offset(12)
            lbl.leading.equalTo(lblHeader)
            lbl.trailing.equalToSuperview().offset(-15)
        })
        
        imgDropButton.snp.makeConstraints({ img in
            img.trailing.equalToSuperview().offset(-18.37)
            img.centerY.equalToSuperview()
        })
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
