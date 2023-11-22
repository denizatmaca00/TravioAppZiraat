//
//
//  HomeVC.swift
//  TravioApp
//
//  Created by Aydın Erol on 30.10.2023.
//
//

import UIKit
import SnapKit

class HomeVC: UIViewController {
    
    let viewModel:HomeVM = HomeVM()
    
    //MARK: -- Properties
    
    //MARK: -- Views
    
    private lazy var stackViewLogo: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fillProportionally
        //sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var imgLogo: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "pinLogo")
        imageView.image = image
        return imageView
    }()
    
    private lazy var lblHeader: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "travioLabel")?.withRenderingMode(.automatic)
        imageView.image = image
        return imageView
    }()
    
    private lazy var contentViewBig : UIView = {
        let view = AppView()
        return view
    }()
    
    private lazy var collectionView:UICollectionView = {
        let layout = makeCollectionViewLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(named: "viewBackgroundColor")
        cv.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier)
        cv.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseId)
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    //MARK: -- Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        initPopularVM()
        initNewsVM()
        initAllForUserVM()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initPopularVM()
        initNewsVM()
        initAllForUserVM()
    }

    
    //MARK: -- Component Actions
    
    @objc private func btnSeeAllTapped(sender:UIButton!){
    }
    
    //MARK: -- Private Methods
    
    func initPopularVM() {
        viewModel.reloadPopularClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.initFetchPopularHomeLimits(limit: 10)
    }
    
    func initNewsVM() {
        viewModel.reloadNewPlacesClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.initFetchNewHomeLimits(limit: 10)
    }
    
    func initAllForUserVM() {
        viewModel.reloadAllForUserPlacesClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.initFetchAllForUserHomeAll()
    }
    
    //MARK: -- UI Methods
    
    func setupViews() {
        // Add here the setup for the UI
        
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.view.addSubviews(stackViewLogo, contentViewBig)
        stackViewLogo.addArrangedSubviews(imgLogo, lblHeader)
        
        contentViewBig.addSubviews(collectionView)
        
        setupLayout()
        
        viewModel.sectionsArray = [viewModel.popularPlaces, viewModel.newPlaces, viewModel.allPlaces]
    }
    
    func setupLayout() {
        let limits = self.view.safeAreaLayoutGuide.snp
        
        // Add here the setup for layout
        stackViewLogo.snp.makeConstraints({sv in            
            sv.leading.equalToSuperview().offset(16)
            sv.top.equalTo(limits.top)
            
        })

        contentViewBig.snp.makeConstraints({cv in
            cv.top.equalTo(stackViewLogo.snp.bottom).offset(35)
            cv.bottom.equalToSuperview()
            cv.leading.equalToSuperview().offset(1)
            cv.width.equalToSuperview()
            
        })
        
        collectionView.snp.makeConstraints({ cv in
            cv.top.equalTo(contentViewBig.snp.top).offset(55)
            cv.bottom.equalTo(contentViewBig.snp.bottom)
            cv.leading.equalTo(contentViewBig.snp.leading)
            cv.width.equalTo(contentViewBig.snp.width)
            
        })
    }
}

extension HomeVC {
    
    func makeSliderLayoutSection() -> NSCollectionLayoutSection {
        
        // header adjustments
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        headerElement.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom:0, trailing: 16)
        
        headerElement.pinToVisibleBounds = false
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(280), heightDimension: .estimated(178))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [item])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 20, trailing: 16)
        
        layoutSection.interGroupSpacing = 16
        
        // set/show headers
        layoutSection.boundarySupplementaryItems = [headerElement]
        
        layoutSection.orthogonalScrollingBehavior = .groupPaging
        
        return layoutSection
    }
    
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        
        UICollectionViewCompositionalLayout {
            
            [weak self] sectionIndex, environment in
            
            return self?.makeSliderLayoutSection()
            
        }
    }
}

extension HomeVC:UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.numberOfCells
        }
        else if section == 1{
            return viewModel.newPlaces.count
        }
        else{
            return viewModel.allPlaces.count
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier, for: indexPath) as? CustomCollectionViewCell else {fatalError("Cell not found")}
        
        cell.contentView.isUserInteractionEnabled = false
        
        switch indexPath.section {
        case 0:
            let object = viewModel.popularPlaces[indexPath.row]
            cell.configure(object:object)
        case 1:
            let object = viewModel.newPlaces[indexPath.row]
            cell.configure(object:object)
        case 2:
            let object = viewModel.allPlaces[indexPath.row]
            cell.configure(object:object)
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseId, for: indexPath) as! HeaderView
        
        let vc = SeeAllVC()
        
        switch indexPath.section {
        case 0:
            let title = "Popular Places"
            header.setTitle(titleText: title)
            header.btnTapAction = {
                
                vc.titleLabel.text = title
                vc.viewModel.getPopularPlace()
                vc.hidesBottomBarWhenPushed = true

                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            let title = "New Places"
            header.setTitle(titleText: title)
            header.btnTapAction = {
                
                vc.titleLabel.text = title
                vc.viewModel.newPlace()
                vc.hidesBottomBarWhenPushed = true

                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 2:
            header.setTitle(titleText: "My Added Places")
            header.btnTapAction = {
                
                vc.titleLabel.text = "My Added Places"
                vc.viewModel.allPlaceforUser()
                vc.hidesBottomBarWhenPushed = true

                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
        return header
    }
}

extension HomeVC:UICollectionViewDelegate
{
    // used for adjusting item sizes
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 10) * 1,
                      height: (collectionView.frame.height - 10 ) * 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let placeId = viewModel.sectionsArray[indexPath.section][indexPath.row].id
        let vc = DetailVC()
        vc.viewModel.placeIdtest = placeId
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct HomeVC_Preview: PreviewProvider {
    static var previews: some View{
        
        HomeVC().showPreview().ignoresSafeArea(.all)
    }
}
#endif
