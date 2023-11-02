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
        view.clipsToBounds = true
        view.layer.cornerRadius = 80
        view.layer.maskedCorners = [.layerMinXMinYCorner]
        return view
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
        dropView.addSubviews(lblHeader, lblDescription)
        
        setupLayout()
    }
    
    private func setupLayout() {
        // Add here the setup for layout
        dropView.snp.makeConstraints({ dv in
            dv.width.equalToSuperview()
            dv.height.equalTo(50)
            dv.center.equalToSuperview()
            
        })
        
        lblHeader.snp.makeConstraints({lbl in
            lbl.leading.equalToSuperview()
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
