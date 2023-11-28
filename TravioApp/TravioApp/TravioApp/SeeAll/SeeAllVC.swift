//
//  
//  PopularPlaceVC.swift
//  TravioApp
//
//  Created by Ece Poyraz on 2.11.2023.
//
//
import UIKit
import TinyConstraints
import SnapKit

enum sortType{
    case AToZ
    case ZToA
}
class SeeAllVC: UIViewController {
    
    var viewModel = SeeAllVM()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogo")
        return imageView
    }()
    
     lazy var titleLabel: UILabel = {
        let wlcLabel = UILabel()
        wlcLabel.text = "My Added Places"
        wlcLabel.textColor = .white
        wlcLabel.font = .Fonts.pageHeader32.font
        return wlcLabel
    }()
    private lazy var uıView:UIView = {
        let uv = UIView()
        uv.layer.backgroundColor = UIColor(named: "viewBackgroundColor")?.cgColor
        uv.backgroundColor = UIColor(named: "viewBackgroundColor")
        uv.layer.cornerRadius = 80
        uv.layer.maskedCorners = [.layerMinXMinYCorner]
        return uv
    }()

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "backgroundColor")
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner]
        return view
    }()
    private lazy var sortButton:UIButton = {
        let up = UIButton()
        up.setImage(UIImage(named: "sortAscending"), for: .normal)
        up.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return up
    }()
    private var isAscending = true
    @objc func sortButtonTapped() {
            isAscending.toggle()

            if isAscending {
                viewModel.sortPlace(getSortType: .AToZ)
            } else {
                viewModel.sortPlace(getSortType: .ZToA)
            }

            collectionView.reloadData()
            updateSortButton()
        }
        private func updateSortButton() {
            let imageName = isAscending ? "sortAscending" : "sortDescending"
            sortButton.setImage(UIImage(named: imageName), for: .normal)
        }
    private lazy var backButton:UIButton = {
        let bck = UIButton()
        bck.setImage(UIImage(named: "bckBtnSecuritySetting"), for: .normal)
        bck.addTarget(self, action: #selector(backPage), for: .touchUpInside )
        return bck
    }()
    private lazy var collectionView:UICollectionView = {
        let layoutcv = UICollectionViewFlowLayout()
        layoutcv.scrollDirection = .vertical
        layoutcv.minimumLineSpacing = 1
        layoutcv.minimumInteritemSpacing = 1
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layoutcv)
        cv.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        cv.register(SeeAllCellVC.self, forCellWithReuseIdentifier: "SeeAllCell")
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        cv.layer.maskedCorners = [.layerMinXMinYCorner]
        cv.layer.cornerRadius = 30
        cv.layer.backgroundColor = UIColor(named: "viewBackgroundColor")?.cgColor
        cv.addSubview(sortButton)
        return cv
    }()
    @objc func backPage(){
        navigationController?.popViewController(animated: true)
     }
    override func viewDidLoad(){
        super.viewDidLoad()
        initAllForUserVM()
        titleLabel.isHidden = false
        sortButton.isHidden = false
        self.view.backgroundColor = UIColor(named: "viewBackgroundColor")
       setupViews()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)

    }

    func initAllForUserVM() {
        viewModel.reloadPopularClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.fetch(array: viewModel.popularArray )
    }
    func initNewPlace(){
        viewModel.reloadNewPopular = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    func initAllPlace(){
        viewModel.reloadAllPopular = {[weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
   
    func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(backgroundView)
        self.view.addSubview(uıView)
        uıView.addSubviews(collectionView,sortButton)
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(backButton)
        self.view.addSubviews()
        setupLayout()
    }
    
    func setupLayout() {
        
        titleLabel.topToSuperview(offset:70)
        titleLabel.leading(to: backButton, offset: 48)
        titleLabel.trailingToSuperview(offset: -20)
        titleLabel.height(48)
        titleLabel.centerXToSuperview()
        
        backButton.centerY(to: titleLabel)
        backButton.height(40)
        backButton.height(40)
        backButton.leadingToSuperview(offset:20)
        
        backgroundView.edgesToSuperview()
        uıView.topToSuperview(offset:125)
        uıView.edgesToSuperview(excluding: .bottom,usingSafeArea: true)
        uıView.height(800)
        
        
        collectionView.topToSuperview(offset:50)
        collectionView.edgesToSuperview(excluding: .bottom,usingSafeArea: true)
        collectionView.height(800)
        
        
        sortButton.height(40)
        sortButton.width(40)
        sortButton.topToSuperview(offset:10,usingSafeArea: true)
        sortButton.trailingToSuperview(offset:40)
  
    }
  
}

extension SeeAllVC:UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 20), height: (collectionView.frame.height/6.5))

    }
}
    extension SeeAllVC:UICollectionViewDataSource,UICollectionViewDelegate {
         
         func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
             return viewModel.popularArray.count
         }
         
         func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeeAllCell", for: indexPath) as! SeeAllCellVC
             let placeInfo = viewModel.popularArray[indexPath.row]
             cell.configure(object: placeInfo)
             return cell
             }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let vc = DetailVC()
            vc.viewModel.placeId = viewModel.popularArray[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        }



     }

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct SeeAllVC_Preview: PreviewProvider {
    static var previews: some View{
         
        SeeAllVC().showPreview()
    }
}
#endif
