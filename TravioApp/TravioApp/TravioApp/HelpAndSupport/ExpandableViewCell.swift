//
//  ExpandableViewCell.swift
//  TravioApp
//
//  Created by Aydın Erol on 7.11.2023.
//

import UIKit

class ExpandableViewCell: UICollectionViewCell {
    
    static let reuseIdentifier:String = "cell"
    
    var expandCell = false
    
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
        lbl.isHidden = false
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()
    
    //MARK: -- Views
    
    lazy var dropView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3 //UIColor(named: "viewBackgroundColor")
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.shadowRadius = 16
        view.layer.shadowOpacity = 1
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        return view
    }()
    
    private lazy var viewSeperator:UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 12))
        return v
    }()
    
    private lazy var imgDropButton:UIImageView = {
        let imgView = UIImageView(image: UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysOriginal))
        
        return imgView
    }()
    
    //MARK: -- Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        //configureCell(title: "Init", description: "Desc", isExpanded: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -- Component Actions
    
    //MARK: -- Private Methods
    
    public func configureCell(title:String, description:String, isExpanded:Bool){
        lblHeader.text = title
        lblDescription.text = description
        lblDescription.isHidden = isExpanded
        imgDropButton.image = (isExpanded ?
                               UIImage(systemName: "chevron.up") :
                                UIImage(systemName: "chevron.down"))?
            .withRenderingMode(.alwaysOriginal)
    }
    
    //MARK: -- UI Methods
    
    private func setupViews() {
        // Add here the setup for the UI
        
        self.addSubviews(dropView)
        dropView.addSubviews(lblHeader, imgDropButton, lblDescription)
        //dropView.addSubview(viewSeperator)
        
        setupLayout()
    }
    
    private func setupLayout() {
        // Add here the setup for layout
        dropView.snp.makeConstraints({ dv in
            dv.top.equalToSuperview()
            dv.bottom.equalToSuperview()//.offset(-viewSeperator.frame.height)
            dv.leading.equalToSuperview()
            dv.trailing.equalToSuperview()
            
        })
//        
//        viewSeperator.snp.makeConstraints({ view in
//            view.leading.equalToSuperview()
//            view.trailing.equalToSuperview()
//            view.top.equalTo(dropView.snp.bottom)
//            view.bottom.equalToSuperview()
//            
//        })
        
        lblHeader.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(16)
            lbl.bottom.equalTo(lblDescription.snp.top).offset(-12)
            lbl.leading.equalToSuperview().offset(12)
            lbl.trailing.equalToSuperview().offset(-12*4)
            
        })
        
        lblDescription.snp.makeConstraints({ lbl in
            lbl.top.equalTo(lblHeader.snp.bottom).offset(4)
            lbl.bottom.equalToSuperview().inset(16)
            lbl.leading.equalToSuperview().inset(16)
            lbl.trailing.equalToSuperview().inset(16)
            
        })
        
        imgDropButton.snp.makeConstraints({ img in
            img.top.equalTo(lblHeader.snp.bottom)
            img.bottom.equalTo(lblHeader.snp.bottom).offset(-lblHeader.frame.height/1.5)
            img.trailing.equalToSuperview().offset(-18.37)
            
        })
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct ExpandableCollectionViewCell_Preview: PreviewProvider {
    static var previews: some View{
        
        ExpandableViewCell().showPreview()
        HelpAndSupportCollectionVC().showPreview()
    }
}
#endif
