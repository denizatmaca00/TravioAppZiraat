//
//
//  CustomDetailCellVC.swift
//  TravioApp
//
//  Created by Ece Poyraz on 30.10.2023.
//
//kaldır
import UIKit
import TinyConstraints

class CustomDetailCellVC: UITableViewCell {
    
//    var detailCellViewModel : detail? {
//        didSet{
//            centerText.text = detailCellViewModel?.lbl
//            dateText.text = detailCellViewModel?.date
//            byText.text = detailCellViewModel?.b
//            descText.text = detailCellViewModel?.desc
//        }
//    }
    
    private lazy var centerText:UILabel = {
        let centertxt = UILabel()
        centertxt.text = "Default"
        centertxt.textColor = .black
        centertxt.numberOfLines = 1
        centertxt.font = UIFont(name: "Poppins", size: 30)
        return centertxt
    }()
    private lazy var dateText:UILabel = {
        let datetxt = UILabel()
        datetxt.text = "Default"
        datetxt.textColor = .black
        datetxt.numberOfLines = 1
        //datetxt.backgroundColor = .systemBlue
        datetxt.font = UIFont(name: "Poppins", size: 14)
        return datetxt
    }()
    private lazy var byText:UILabel = {
        let by = UILabel()
        by.text = "Default"
        by.textColor = .black
        by.numberOfLines = 1
        //by.backgroundColor = .systemBlue
        by.font = UIFont(name: "Poppins", size: 10)
        return by
    }()
   
    private lazy var descText:UILabel = {
        let txt = UILabel()
        txt.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        txt.textColor = .black
        txt.numberOfLines = 0
        //centertxt.backgroundColor = .systemBlue
        txt.font = UIFont(name: "Poppins", size: 12)
        //txt.lineBreakMode = .byTruncatingTail
        //txt.adjustsFontSizeToFitWidth = true
        //txt.lineBreakMode = .wordWrap
        //txt.sizeToFit()
        return txt
    }()
        private lazy var imageMap:UIImageView = {
            let i = UIImageView()
            i.image = UIImage(named: "mapimg")
            i.contentMode = .scaleToFill
            return i
        }()
    private lazy var stackText:UIStackView = {
        let s = UIStackView()
        s.spacing = 10
        s.axis = .vertical
        s.distribution = .fill
        return s
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  
    func setupViews() {
       // self.view.addSubviews()
        self.stackText.addSubviews(centerText,dateText,byText,descText,imageMap)
        self.contentView.addSubviews(stackText)
        setupLayout()
    }
    
    func setupLayout() {
 
        
        //imageMap.topToBottom(of: byText,offset: 10)
        imageMap.height(200)
        imageMap.width(350)
        imageMap.leadingToSuperview(offset:20)
        imageMap.topToSuperview(offset:100)
        
        centerText.leading(to: descText)
        dateText.leading(to: centerText)
        byText.leading(to: dateText)
        
        centerText.top(to: imageMap, offset:-100)
        dateText.topToBottom(of: centerText,offset: 10)
        byText.topToBottom(of: dateText,offset:10)
        
        descText.topToBottom(of: imageMap)
        descText.height(300)
        descText.width(350)
        descText.leading(to: imageMap)
        
        
//        centerText.snp.makeConstraints({ $0.height.equalTo(45)})
//        centerText.snp.makeConstraints({$0.width.equalTo(126)})
//
//        dateText.snp.makeConstraints({$0.height.equalTo(45)})
//        dateText.snp.makeConstraints({$0.width.equalTo(126)})
//
//        stackText.snp.makeConstraints({ stack in
//                   stack.leading.equalToSuperview().offset(24)
//                   stack.trailing.equalToSuperview().offset(-24)
//               })
//        //stackText.topToBottom(of: image, offset: 24)
//                imageMap.snp.makeConstraints({$0.width.equalTo(358)})
//                imageMap.snp.makeConstraints({$0.height.equalTo(227)})
       
    }
  
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct CustomDetailCellVC_Preview: PreviewProvider {
    static var previews: some View{
         
        CustomDetailCellVC().showPreview()
    }
}
#endif
