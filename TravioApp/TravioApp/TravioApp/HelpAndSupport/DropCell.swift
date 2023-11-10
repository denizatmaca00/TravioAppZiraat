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
    var toExpand = false {
        didSet{
            toggleCellData(data: "")
        }
    }
    override var isSelected: Bool{
        didSet{
//            print("isSelected changed to \(isSelected)")
//            imgDropButton.image = (self.isSelected ?
//                                   UIImage(systemName: "chevron.up") :
//                                    UIImage(systemName: "chevron.down"))?
//                .withRenderingMode(.alwaysOriginal)
//            lblDescription.isHidden = (self.isSelected ? false : true)
        }
    }
    //MARK: -- Properties
    
//    var isExpanded:Bool = false
    
    var dropCellViewModel:DropCellViewModel? {
        didSet{
            lblHeader.text = dropCellViewModel?.title
            lblDescription.text = dropCellViewModel?.description
            //lblDescription.text = (!dropCellViewModel!.isExpanded ? dropCellViewModel?.description : "")
//            lblDescription.text = (!dropCellViewModel!.isExpanded ? dropCellViewModel?.description : "")
//            lblDescription.isHidden = !dropCellViewModel!.isExpanded
//            print("DidSet of DropCell: \(!dropCellViewModel!.isExpanded)")
//            imgDropButton.image = (!dropCellViewModel!.isExpanded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down"))?.withRenderingMode(.alwaysOriginal)
//            
        }
    }
    
    func animate() {
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
    
    func toggleCellData(data:String){
        //let isExpanded = dropCellViewModel?.isExpanded
        // ucuncude burası false kalıyor
        lblDescription.isHidden = !toExpand
//        lblDescription.text = (!isExpanded! ? data : "")
        
        print("Function of DropCell: \(!toExpand)")
//        imgDropButton.image = (self.isSelected ?
//                                           UIImage(systemName: "chevron.up") :
//                                            UIImage(systemName: "chevron.down"))? .withRenderingMode(.alwaysOriginal)
        
        imgDropButton.image = (!toExpand ?
                               UIImage(systemName: "chevron.up") :
                                UIImage(systemName: "chevron.down"))?
            .withRenderingMode(.alwaysOriginal)
    }
    
    var setHeightClosure: ()-> CGFloat = {return 73}
    
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
        lbl.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        lbl.font = .Fonts.descriptionText.font
        lbl.textColor = UIColor(named: "textColor")
        lbl.isHidden = true
        lbl.numberOfLines = -1
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
//        dropView.addSubview(viewSeperator)
        
        setupLayout()
    }
    
    private func setupLayout() {
        // Add here the setup for layout
        dropView.snp.makeConstraints({ dv in
            dv.top.equalToSuperview()
            dv.bottom.equalToSuperview().offset(-viewSeperator.frame.height)
            dv.leading.equalToSuperview()
            dv.trailing.equalToSuperview()
            
        })
        
//        dropView.addSubview(viewSeperator)
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
            lbl.trailing.equalToSuperview().offset(-46)
            
        })
        
        lblDescription.snp.makeConstraints({ lbl in
            lbl.top.equalTo(lblHeader.snp.bottom)
            lbl.bottom.equalToSuperview().offset(-16)
            lbl.leading.equalTo(lblHeader.snp.leading)
            lbl.trailing.equalToSuperview().offset(-15)
            
        })
        
        imgDropButton.snp.makeConstraints({ img in
//            img.top.equalTo(lblHeader.snp.bottom)
//            img.bottom.equalTo(lblHeader.snp.bottom).offset(-lblHeader.frame.height/1.3)
            img.centerY.equalTo(lblHeader.snp.centerY)
            img.trailing.equalToSuperview().offset(-18.37)
            
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
