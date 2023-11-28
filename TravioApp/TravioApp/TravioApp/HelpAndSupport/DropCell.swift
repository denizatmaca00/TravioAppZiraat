//
//  
//  DropCell.swift
//  TravioApp
//
//  Created by Aydın Erol on 2.11.2023.
//
//

import UIKit
import SnapKit

class DropCell: UITableViewCell {
    
    //MARK: -- Properties
    
    static let reuseIdentifier = "ExpandableCell"
    
    var toExpand = false {
        didSet{
            toggleCellData()
        }
    }
    
    var dropCellViewModel:DropCellViewModel? {
        didSet{
            lblHeader.text = dropCellViewModel?.title
            lblDescription.text = dropCellViewModel?.description
        }
    }
    
    private lazy var lblHeader: UILabel = {
        let lbl = UILabel()
        lbl.text = "placeHolderTitle"
        lbl.font = .Fonts.textFieldTitle.font
        lbl.textColor = UIColor(named: "textColor")
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.text = "Lorem Ipsum"
        lbl.font = .Fonts.descriptionText.font
        lbl.textColor = UIColor(named: "textColor")
        lbl.isHidden = true
        lbl.numberOfLines = 0
        return lbl
    }()
    
    //MARK: -- Views
    
    private lazy var viewContainer:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var stackView:UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .equalCentering
        sv.spacing = 12+10
        sv.alignment = .center
        return sv
    }()
    
    private lazy var viewSeperator:UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 12))
        return v
    }()
    
    private lazy var imgDropButton:UIImageView = {
        let image = UIImage(named: "expandChevron")?.withRenderingMode(.alwaysOriginal)
        let imgView = UIImageView(image:image)
        
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
    
    //MARK: -- Private Methods
    
    func animate() {
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
    /// Toggle function to make cell show or hide to create expand-collapse effect
    func toggleCellData(){
        lblDescription.isHidden = !toExpand
        
            self.imgDropButton.transform = self.toExpand ?
                                   CGAffineTransform(rotationAngle: CGFloat(Double.pi)) : CGAffineTransform(rotationAngle: CGFloat(-Double.zero))
    }
    
    //MARK: -- UI Methods
    
    private func setupViews() {
        // Add here the setup for the UI
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16
        
        self.contentView.addSubviews(viewContainer)
        
        viewContainer.addSubviews(stackView, imgDropButton)
        
        stackView.addArrangedSubviews(lblHeader, lblDescription)
        
        setupLayout()
    }
    
    private func setupLayout() {
        // Add here the setup for layout
        viewContainer.snp.makeConstraints({ sv in
            sv.top.equalToSuperview()
            /// creates spacing between cells
            sv.bottom.equalToSuperview().inset(12)
            sv.leading.equalToSuperview().offset(24)
            sv.trailing.equalToSuperview().inset(24)
            
        })
        
        stackView.snp.makeConstraints({ sv in
            sv.top.equalToSuperview().offset(16)
            sv.bottom.equalToSuperview().inset(15)
            sv.leading.equalToSuperview().offset(12)
            sv.trailing.equalToSuperview()
            
        })
        
        lblHeader.snp.makeConstraints({lbl in
            lbl.leading.equalToSuperview()
            lbl.trailing.equalToSuperview().inset(46)
            
        })
        
        lblDescription.snp.makeConstraints({ lbl in
            lbl.leading.equalToSuperview()
            lbl.trailing.equalToSuperview().inset(15)
            
        })
        
        imgDropButton.snp.makeConstraints({ img in
            img.centerY.equalTo(lblHeader.snp.centerY)
            img.trailing.equalToSuperview().inset(18.37)
            
        })
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct DropCell_Preview: PreviewProvider {
    static var previews: some View{
        HelpAndSupportVC().showPreview().ignoresSafeArea()
        DropCell().showPreview()
    }
}
#endif
