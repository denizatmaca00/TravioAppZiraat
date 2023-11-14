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


class PopularPlaceVC: UIViewController {
    var viewModel = PopularPlaceVM()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogo")
        return imageView
    }()
    
     lazy var titleLabel: UILabel = {
        let wlcLabel = UILabel()
        wlcLabel.text = "Popular Places"
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
    private lazy var sortAscending:UIButton = {
        let up = UIButton()
        up.setImage(UIImage(named: "sortAscending"), for: .normal)
        up.addTarget(self, action: #selector(sortDescending), for: .touchUpInside)
        return up
    }()
    
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
        cv.register(PopularPageCellVC.self, forCellWithReuseIdentifier: "popularCell")
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        cv.layer.maskedCorners = [.layerMinXMinYCorner]
        cv.layer.cornerRadius = 30
        cv.layer.backgroundColor = UIColor(named: "viewBackgroundColor")?.cgColor
        cv.addSubview(sortAscending)
        return cv
    }()
    @objc func sortDescending(){
        sortAscending.setImage(UIImage(named: "sortDescending"), for: .normal)
        sortAscending.addTarget(self, action: #selector(sortAscendingBack), for: .touchUpInside)
    }
    @objc func sortAscendingBack(){
        sortAscending.setImage(UIImage(named: "sortAscending"), for: .normal)
        sortAscending.addTarget(self, action: #selector(sortDescending), for: .touchUpInside)
    }
    
    @objc func backPage(){
        navigationController?.popViewController(animated: true)
     }
    override func viewDidLoad(){
        super.viewDidLoad()
        initAllForUserVM()
        titleLabel.isHidden = false
        sortAscending.isHidden = false
        self.view.backgroundColor = UIColor(named: "viewBackgroundColor")
       setupViews()
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
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(backgroundView)
        self.view.addSubview(uıView)
        uıView.addSubviews(collectionView,sortAscending)
        //collectionView.addSubview(sortAscending)
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(backButton)
//        self.view.addSubview(collectionView)
        self.view.addSubviews()
        setupLayout()
    }
    
    func setupLayout() {
        
        titleLabel.topToSuperview(offset:70)
        titleLabel.height(48)
        titleLabel.width(241)
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
        
        
        sortAscending.height(40)
        sortAscending.width(40)
        sortAscending.topToSuperview(offset:10,usingSafeArea: true)
        sortAscending.trailingToSuperview(offset:40)
  
    }
  
}

extension PopularPlaceVC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 20), height: (collectionView.frame.height/6.5))

    }
}


    extension PopularPlaceVC:UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            print(viewModel.popularArray.count)
            return viewModel.popularArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularCell", for: indexPath) as! PopularPageCellVC
            let deneme = viewModel.popularArray[indexPath.row]
            print(deneme)
            cell.configure(object: deneme)
            return cell
            }
    }

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct PopularPlaceVC_Preview: PreviewProvider {
    static var previews: some View{
         
        PopularPlaceVC().showPreview()
    }
}
#endif
