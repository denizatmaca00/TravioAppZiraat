//
//  UserTableCell.swift
//  MvvmBir
//
//  Created by web3406 on 10/23/23.
//

import UIKit
import TinyConstraints
import SnapKit

class UserTableCell: UICollectionViewCell {
    
        private lazy var name:UILabel = {
           let label = UILabel()
            label.textColor = .systemBlue
            label.numberOfLines = 0
            label.font = UIFont(name: "Avenir-Medium", size: 14)
            return label
        }()
        
        private lazy var phoneNumber:UILabel = {
           let label = UILabel()
            label.textColor = .systemBlue
            label.numberOfLines = 0
            label.font = UIFont(name: "Avenir-Medium", size: 14)
            return label
        }()
        
        private lazy var email:UILabel = {
           let label = UILabel()
            label.textColor = .systemBlue
            label.numberOfLines = 0
            label.font = UIFont(name: "Avenir-Medium", size: 14)
            return label
        }()
        
        private lazy var note:UILabel = {
           let label = UILabel()
            label.textColor = .systemBlue
            label.numberOfLines = 0
            label.font = UIFont(name: "Avenir-Medium", size: 14)
            return label
        }()
        
        private lazy var id:UILabel = {
           let label = UILabel()
            label.textColor = .systemBlue
            label.numberOfLines = 0
            label.font = UIFont(name: "Avenir-Medium", size: 14)
            return label
        }()
        
        private lazy var stackView:UIStackView = {
           let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fill
            stack.spacing = 8
            return stack
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
        }
        
        public func configure(object: User){
            name.text = object.name
            phoneNumber.text = object.phoneNumber
            note.text = object.note
            email.text = object.email
            id.text = object.id
        
        }
        
        
        private func setupViews(){
            self.contentView.addSubview(stackView)
            stackView.addArrangedSubviews(name,phoneNumber,note,email,id)

            let separatorView = UIView()
            
            //aşağıdaki kod çizgi çekmek için
            separatorView.backgroundColor = .gray
            self.contentView.addSubview(separatorView)
                
            separatorView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            setupLayout()
        }
        
        private func setupLayout(){
    //        name.leadingToSuperview(offset: 30)
    //        phoneNumber.leadingToTrailing(of: name, offset: 30)
            stackView.horizontalToSuperview(insets: .left(10) + .right(10) ,usingSafeArea: true)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }


