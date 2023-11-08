//
//  
//  HelpAndSupportCollectionVCVC.swift
//  TravioApp
//
//  Created by Aydın Erol on 7.11.2023.
//
//
import UIKit
import SnapKit

class HelpAndSupportCollectionVC: UIViewController {
    
    //MARK: -- Properties
    
    private let viewModel:HelpAndSupportVM = {
        return HelpAndSupportVM()
    }()
    
    private let expandableCell = ExpandableViewCell()
    
    private lazy var lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.text = "Help&Support"
        lbl.textColor = .white
        lbl.font = UIFont(name: "Poppins-Bold", size: 32)
        return lbl
    }()
    
    private lazy var lblPageTitle:UILabel = {
        let lbl = UILabel()
        lbl.text = "FAQ"
        lbl.textColor = UIColor(named: "backgroundColor")
        lbl.font = UIFont(name: "Poppins-SemiBold", size: 24)
        return lbl
    }()
    
    private lazy var leftBarButton: UIBarButtonItem = {
        let leftBarButton = UIBarButtonItem()
        leftBarButton.tintColor = .white
        leftBarButton.image = UIImage(named: "leftArrow")
        leftBarButton.target = self
        leftBarButton.action = #selector(backButtonTapped)
        return leftBarButton
    }()
    
    //MARK: -- Views
    
    private lazy var contentViewBig: UIView = {
       let view = UIView()
       view.backgroundColor = UIColor(named: "viewBackgroundColor")
       view.clipsToBounds = true
       view.layer.cornerRadius = 80
       view.layer.maskedCorners = [.layerMinXMinYCorner]
       return view
   }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        // aynı satırdakileri ayırmak
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)

//        cv.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        cv.isPagingEnabled = true
        
        cv.dataSource = self
        cv.delegate = self

        cv.register(ExpandableViewCell.self, forCellWithReuseIdentifier: ExpandableViewCell.reuseIdentifier)

        return cv
    }()
    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        collectionView.reloadData()
    }
    
    //MARK: -- Component Actions
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: -- Private Methods
    
    private func reloadCV(){
        self.collectionView.reloadData()
    }
    
    //MARK: -- UI Methods
    func setupViews() {
        // Add here the setup for the UI
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        self.view.addSubviews(lblHeader, contentViewBig)
        contentViewBig.addSubviews(lblPageTitle, collectionView)
        
        setupLayout()
    }
    
    func setupLayout() {
        
        let startY = self.view.bounds.origin.y + 50
        
        // Add here the setup for layout
        contentViewBig.snp.makeConstraints ({ view in
            view.height.equalToSuperview().multipliedBy(0.8)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
            
        })
        
        collectionView.snp.makeConstraints({ tv in
            tv.top.equalToSuperview().offset(120)
            tv.leading.equalToSuperview().offset(24)
            tv.trailing.equalToSuperview().offset(-24)
            tv.bottom.equalToSuperview()
            
        })
        
        lblHeader.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(startY)
            lbl.leading.equalToSuperview().offset(72)
            
        })
        
        lblPageTitle.snp.makeConstraints({ lbl in
            lbl.top.equalToSuperview().offset(44)
            lbl.leading.equalToSuperview().offset(24)
            
        })
    }
  
}

extension HelpAndSupportCollectionVC : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.descriptions.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpandableViewCell.reuseIdentifier, for: indexPath) as! ExpandableViewCell
        
        let description = viewModel.descriptions[indexPath.row]
        let title = viewModel.titles[indexPath.row]
        let isExpand = cell.expandCell
        cell.configureCell(title: title, description: description, isExpanded: false)
        
        
        return cell
    }
    
    /*
    
    // dynamic height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
        expandableCell.frame = CGRect(origin: .zero, size: CGSize(width: collectionView.bounds.width - 40, height: 1000))
        
        expandableCell.isSelected = isSelected
        expandableCell.setNeedsLayout()
        expandableCell.layoutIfNeeded()
        
        let size = expandableCell.systemLayoutSizeFitting(CGSize(width: collectionView.bounds.width - 40, height: .greatestFiniteMagnitude), withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        24
    }
    
    // cell expand using CVDelegate
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.performBatchUpdates(nil)
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        collectionView.performBatchUpdates(nil)
        
        DispatchQueue.main.async {
            guard let attributes = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath) else {return}
            let desiredOffset = attributes.frame.origin.y - 20
            let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
            let maxPossibleOffset = contentHeight - collectionView.bounds.height
            let finalOffset = max(min(desiredOffset, maxPossibleOffset), 0)
            collectionView.setContentOffset(CGPoint(x: 0, y: finalOffset), animated: true)
            
            // or:
            //collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
     return true
    }
    */
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct HelpAndSupCollectionViewVC_Preview: PreviewProvider {
    static var previews: some View{
        
        HelpAndSupportCollectionVC().showPreview().ignoresSafeArea(.all)
    }
}
#endif
