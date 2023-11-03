//
//  
//  HomeVC.swift
//  TravioApp
//
//  Created by Aydın Erol on 30.10.2023.
//
//
import UIKit
import TinyConstraints
import SnapKit

class HomeVC: UIViewController {
    func wakeButton() {
        print("axax")
    }
    
    
    var popularPlaces:[Place] = [Place(id: "1", creator: "Avni", place: "Colloseo", title: "KolezyumBaşlık", description: "Kolezyuma gittim geldim falan", cover_image_url: "https://myimage.com/colosseum", latitude: 27.232323, longitude: 15.35215, created_at: "2023-10-28", updated_at: "2023-10-28"), Place(id: "2", creator: "Mehmet", place: "Ayasofya", title: "AyasofyaBaşlık", description: "Ayasofya'da 2 rekat kıldım gittim geldim falan", cover_image_url: "https://myimage.com/hagiasophia", latitude: 23.232323, longitude: 17.35215, created_at: "2023-10-28", updated_at: "2023-10-28"), Place(id: "3", creator: "Ali", place: "Çultanahmet", title: "AyasofyaBaşlık", description: "Sultanahmt'te 2 rekat kıldım gittim geldim falan", cover_image_url: "https://myimage.com/hagiasophia", latitude: 23.232323, longitude: 17.35215, created_at: "2023-10-28", updated_at: "2023-10-28")]
                                
    var newPlaces:[Place] = [Place(id: "1", creator: "Avni", place: "Colloseo", title: "KolezyumBaşlık", description: "Kolezyuma gittim geldim falan", cover_image_url: "https://myimage.com/colosseum", latitude: 27.232323, longitude: 15.35215, created_at: "2023-10-28", updated_at: "2023-10-28"), Place(id: "2", creator: "Mehmet", place: "Ayasofya", title: "AyasofyaBaşlık", description: "Ayasofya'da 2 rekat kıldım gittim geldim falan", cover_image_url: "https://myimage.com/hagiasophia", latitude: 23.232323, longitude: 17.35215, created_at: "2023-10-28", updated_at: "2023-10-28"), Place(id: "3", creator: "Ali", place: "Çultanahmet", title: "AyasofyaBaşlık", description: "Sultanahmt'te 2 rekat kıldım gittim geldim falan", cover_image_url: "https://myimage.com/hagiasophia", latitude: 23.232323, longitude: 17.35215, created_at: "2023-10-28", updated_at: "2023-10-28")]
                            
    //MARK: -- Properties
    
    private lazy var imgLogo: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "pinLogo")
        imageView.image = image
        return imageView
    }()
    
//    private lazy var imgHeader: UIImageView = {
//        let imageView = UIImageView()
//        let image = UIImage(named: "travioHeader")?.withRenderingMode(.automatic)
//        imageView.image = image
//        return imageView
//    }()
    
    private lazy var lblHeader:UILabel = {
        let lbl = UILabel()
        
        lbl.text = "travio"
        lbl.font = UIFont(name: "Poppins-Medium", size: 28)
        lbl.textColor = UIColor(named: "textColorReversed")
        
        return lbl
    }()
    
    private lazy var collectionView:UICollectionView = {
        let layout = makeCollectionViewLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        

        cv.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cvCell")
        cv.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseId)
        cv.dataSource = self
        cv.delegate = self
        
//        cv.isUserInteractionEnabled = true
        return cv
    }()
    
    //MARK: -- Views
    
    private lazy var viewHeader:UICollectionReusableView = {
        let v = UICollectionReusableView()
        
        return v
    }()
    
    private lazy var contentViewBig : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        view.clipsToBounds = true
        view.layer.cornerRadius = 80
        view.layer.maskedCorners = [.layerMinXMinYCorner]
        
        return view
    }()
    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupViews()
    }
    
    //MARK: -- Component Actions
    
    //MARK: -- Private Methods
    @objc private func btnSeeAllTapped(sender:UIButton!){
        print(sender.tag)
    }
    
    //MARK: -- UI Methods
    func setupViews() {
        // Add here the setup for the UI
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.view.addSubviews(imgLogo, lblHeader, contentViewBig)
        
        contentViewBig.addSubviews(collectionView)
        
        setupLayout()
    }
    
    func setupLayout() {
        // Add here the setup for layout
        imgLogo.snp.makeConstraints({ img in
            img.leading.equalToSuperview().offset(16)
            img.top.equalToSuperview().offset(50)
            img.height.equalTo(62)
            img.width.equalTo(66)
            
        })

//        imgHeader.snp.makeConstraints({ lbl in
//
//            lbl.leading.equalTo(imgLogo.snp.trailing)
//            lbl.centerY.equalTo(imgLogo.snp.centerY)
//            lbl.height.equalTo(28)
//            lbl.width.equalTo(102)
//        })
        
        lblHeader.snp.makeConstraints({ lbl in
            
            lbl.leading.equalTo(imgLogo.snp.trailing)
            lbl.centerY.equalTo(imgLogo.snp.centerY)

        })
        
        contentViewBig.snp.makeConstraints({cv in
            cv.top.equalToSuperview().offset(125)
            cv.bottom.equalToSuperview()
            cv.leading.equalToSuperview()
            cv.width.equalToSuperview()
            
        })
        
        collectionView.snp.makeConstraints({ cv in
            
            cv.top.equalTo(contentViewBig.snp.top)
            cv.bottom.equalTo(contentViewBig.snp.bottom)
            cv.leading.equalTo(contentViewBig.snp.leading)
            cv.width.equalTo(contentViewBig.snp.width)
            
        })
    }
}

// Extension for CollectionViewLayout
extension HomeVC {
    
    func makeSliderLayoutSection() -> NSCollectionLayoutSection {
        
        // header adjustments
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .estimated(2))
        
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        headerElement.pinToVisibleBounds = false
        
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 87, leading: -48, bottom: 0, trailing: 0)
        
        //fractional height
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: .fractionalHeight(0.38))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [item] )
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        // set/show headers
        layoutSection.boundarySupplementaryItems = [headerElement]
        
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
        return popularPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as! CustomCollectionViewCell
        let object = popularPlaces[indexPath.row]
        
        cell.configure(object:object)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseId, for: indexPath) as! HeaderView
        header.setTitle(titleText: "Popiler")
        header.btnSeeAll.tag = indexPath.row
        header.btnSeeAll.addTarget(self, action: #selector(self.btnSeeAllTapped(sender: )), for: .touchUpInside)
//        header.wakeButton()
//        header.btnTapAction = { () in
//            header.wakeButton()
//            print("axaxa")
//        }
        
        // delegate
//        header.delegate = self
        return header
    }
}

extension HomeVC:UICollectionViewDelegateFlowLayout
{
    // item büyüklüklerini ayarlamak içni gerekli
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 10) * 1,
                      height: (collectionView.frame.height - 10 ) * 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

protocol SectionContentDelegate {
    func wakeButton()
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct HomeVC_Preview: PreviewProvider {
    static var previews: some View{

        HomeVC().showPreview()
    }
}
#endif

// AutoLayout ile kısıtlamalar tanımıyoruz ve bunlara göre farklı ekranlarda aynı sonuç alıyoruz. Bunu da genelde superview ile yapıyoruz.

// layout'daki genişliği neye göre vereceğiz?

