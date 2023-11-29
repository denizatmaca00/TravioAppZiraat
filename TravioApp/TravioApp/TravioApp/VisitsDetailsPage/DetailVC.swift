//
//  DetailVC.swift
//  TravioApp
//
//  Created by Ece Poyraz on 30.10.2023.
//

import UIKit
import TinyConstraints
import SnapKit
import MapKit

class DetailVC: UIViewController {
    var mapView: MKMapView!
    var pinCoordinate: CLLocationCoordinate2D?
    var viewModel = DetailVM()
    let profilViewModel = ProfileVM()
    var profileFullname : String?
    var deleteCreator: String?
    
    private lazy var imageCollection:UICollectionView = {
        let l = UICollectionViewFlowLayout()
        l.scrollDirection = .horizontal
        l.minimumLineSpacing = 0
        l.minimumInteritemSpacing = 0
        
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: l)
        cv.isPagingEnabled = true
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(DetailPageCell.self, forCellWithReuseIdentifier: "detailCell")
        return cv
    }()
    private lazy var saveBtn:UIButton = {
        let adbtn = UIButton()
        adbtn.setImage(UIImage(named: "save"), for: .normal)
        adbtn.addTarget(self, action: #selector(buttonSave), for: .touchUpInside)
        return adbtn
    }()
    private lazy var deleteBtn:UIButton = {
        let delBtn = UIButton()
        delBtn.setImage(UIImage(systemName:  "trash.fill"), for: .normal)
        delBtn.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
        return delBtn
    }()
    private lazy var backButton:UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "bckBtn"), for: .normal)
        b.addTarget(self, action: #selector(back), for: .touchUpInside)
        return b
    }()
    private lazy var pageControl:UIPageControl = {
        let p = UIPageControl()
        p.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "pageControl")!)
        p.pageIndicatorTintColor = UIColor.lightGray
        p.currentPageIndicatorTintColor = UIColor.black
        
        p.tintColor = UIColor.white
        return p
    }()
    private var scrollView:UIScrollView = {
        let s = UIScrollView()
        s.showsVerticalScrollIndicator = false
        return s
    }()
    private lazy var allView:UIView = {
        let all = UIView()
        return all
    }()
    private var centerText:UILabel = {
        let centertxt = UILabel()
        centertxt.text = "İSTANBUL"
        centertxt.textColor = .black
        centertxt.numberOfLines = 1
        centertxt.font = .Fonts.title30.font
        centertxt.layer.backgroundColor = UIColor.white.cgColor
        return centertxt
    }()
    private var dateText:UILabel = {
        let datetxt = UILabel()
        datetxt.text = "31.10.2023"
        datetxt.textColor = .gray
        datetxt.numberOfLines = 1
        datetxt.font = .Fonts.dateText.font
        return datetxt
    }()
    private var byText:UILabel = {
        let by = UILabel()
        by.text = "Ece Poyraz"
        by.textColor = .lightGray
        by.numberOfLines = 1
        by.font = .Fonts.creatorText.font
        return by
    }()
    private lazy var mapButton:UIImageView = {
        let mb = UIImageView()
        mb.clipsToBounds = true
        mb.layer.cornerRadius = 16
        mb.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        return mb
    }()
    private var descText:UILabel = {
        let txt = UILabel()
        txt.text = "Lorem Ipsum is..."
        txt.textColor = .black
        txt.numberOfLines = 0
        txt.lineBreakMode = .byWordWrapping
        txt.sizeToFit()
        txt.font = .Fonts.descriptionLabel.font
        return txt
    }()
    
    @objc func back(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonSave(){
        if  saveBtn.image(for: .normal) == UIImage(named: "savefill"){
            self.showAlert(title: "", message: "Removed from saved") {
                self.viewModel.deleteVisitbyPlceID()
                self.saveBtn.setImage(UIImage(named: "save"), for: .normal)
            }
            
        }else {
            self.showAlert(title: "", message: "Saved") {
                self.viewModel.postVisit()
                self.saveBtn.setImage(UIImage(named: "savefill"), for: .normal)
            }
            
        }
    }
    @objc func deleteBtnTapped() {
        profilViewModel.getProfileInfos { profileResult in
            switch profileResult {
            case .success(let profile):
                let detailCreator = self.deleteCreator
                self.profileFullname = profile.full_name
                
                if detailCreator == self.profileFullname {
                    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                        self.viewModel.deleteMyAdded()
                        self.showAlert(title: "Notification", message: "Deleted Successfully") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    
                    self.addActionSheet(title: "Are you sure?", message: "This action cannot be undone.", actions: [deleteAction, cancelAction])
                } else {
                    self.showAlert(title: "Error", message: "Only the person who added this content can delete it.", completion: {})
                }
            case .failure(let error):
                print("Hata oluştu: \(error)")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.checkVisitbyPlaceID()
        navigationController?.navigationBar.isHidden = true
        setupViews()
        
        viewModel.showAddActionClosure = { [weak self] title, message in
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            self?.addActionSheet(title: title, message: message, actions: [cancelAction])
            
        }
        viewModel.showAddActionClosure = { [weak self] title, message in
            self?.showAlert(title: title, message: message, completion: {
            })
        }
        
        viewModel.checkSuccessID = {[weak self] () in
            self?.saveBtn.setImage(UIImage(named: "savefill"), for: .normal)
            
        }
        viewModel.checkErrorID = {[weak self] () in
            self?.saveBtn.setImage(UIImage(named: "save"), for: .normal)
        }
        
        viewModel.getAPlaceById { Place in
            self.configurePage(place: Place)
            self.createMapView()
        }
        
        viewModel.getAllGaleryById(complete: {() in
            DispatchQueue.main.async {
                self.pageControl.currentPage = 0
                guard let count = self.viewModel.galeryData?.data.count else {return}
                self.pageControl.numberOfPages = count
                self.imageCollection.reloadData()
                
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        let height = descText.frame.origin.y + descText.frame.height
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: height)
    }
    func createMapView() {
        if let pinCoordinate = pinCoordinate {
            let mapSnapshotOptions = MKMapSnapshotter.Options()
            let darkModeTraitCollection = UITraitCollection(userInterfaceStyle: .dark)
            mapSnapshotOptions.traitCollection = darkModeTraitCollection
            mapSnapshotOptions.region = MKCoordinateRegion(center: pinCoordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
            let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
            
            snapShotter.start { snapshot, error in
                if let snapshot = snapshot {
                    let image = snapshot.image
                    
                    if let annotationView = self.createPinImage() {
                        let pinPoint = snapshot.point(for: pinCoordinate)
                        
                        
                        
                        let renderer = UIGraphicsImageRenderer(size: image.size)
                        let combinedImage = renderer.image { _ in
                            image.draw(at: .zero)
                            annotationView.drawHierarchy(in: CGRect(x: pinPoint.x - annotationView.bounds.width / 2, y: pinPoint.y - annotationView.bounds.height / 2, width: annotationView.bounds.width, height: annotationView.bounds.height), afterScreenUpdates: true)
                        }
                        
                        self.mapButton.image = combinedImage
                    }
                }
                
            }
        }
        
    }
    func configurePage(place:Place){
        centerText.text = place.place.extractCityName()
        dateText.text = place.created_at.formatDate()
        byText.text = place.creator
        deleteCreator = place.creator
        byText.text = ("added by @\(place.creator)")
        descText.text = place.description
        pinCoordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        
    }    
    func createPinImage() -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: "pinAnnotation")
        
        let pinImage = UIImage(named: "pin")
        annotationView.image = pinImage
        
        let customImageView = UIImageView(image: UIImage(named: "pinLogo"))
        customImageView.contentMode = .scaleAspectFill
        customImageView.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        annotationView.addSubview(customImageView)
        
        annotationView.bounds = CGRect(x: -2, y: -2, width: customImageView.bounds.width, height: customImageView.bounds.height * 1.5)
        
        return annotationView
    }
    
    func setupViews(){
        self.view.backgroundColor = .white
        view.addSubviews(imageCollection,deleteBtn,saveBtn,backButton,pageControl)
        allView.addSubview(centerText)
        allView.addSubview(dateText)
        allView.addSubview(byText)
        allView.addSubview(mapButton)
        allView.addSubview(descText)
        scrollView.addSubviews(allView)
        view.addSubview(scrollView)
        
        setupLayout()
    }
    
    func setupLayout(){
        
        imageCollection.topToSuperview(offset:0)
        imageCollection.leadingToSuperview()
        imageCollection.trailingToSuperview()
        imageCollection.height(249)
        
        saveBtn.top(to: imageCollection,offset:50)
        saveBtn.trailingToSuperview(offset:15)
        saveBtn.height(40)
        saveBtn.width(40)
        
        deleteBtn.top(to: saveBtn,offset:5)
        deleteBtn.trailingToSuperview(offset:65)
        deleteBtn.height(30)
        deleteBtn.width(30)
        
        backButton.top(to: imageCollection,offset:50)
        backButton.leadingToSuperview(offset: 20)
        backButton.height(40)
        backButton.width(40)
        
        pageControl.bottom(to: imageCollection)
        pageControl.centerXToSuperview()
        pageControl.leadingToSuperview(offset:20)
        pageControl.height(64)
        pageControl.width(24)
        
        scrollView.topToBottom(of: imageCollection)
        scrollView.leadingToSuperview()
        scrollView.snp.makeConstraints({s in
            s.bottom.equalToSuperview().offset(40)
            s.trailing.equalToSuperview()
        })
        
        allView.snp.makeConstraints { a in
            a.edges.equalToSuperview()
            a.width.equalTo(view.snp.width)
        }
        
        centerText.topToSuperview(offset:24)
        centerText.leadingToSuperview(offset:20)
        centerText.snp.makeConstraints({s in
            s.trailing.equalToSuperview().offset(-20)
        })
        
        
        dateText.topToBottom(of: centerText,offset: 5)
        dateText.leading(to: centerText)
        dateText.trailing(to: centerText)
        
        byText.topToBottom(of: dateText,offset: 5)
        byText.leading(to: centerText)
        byText.trailing(to: centerText)
        
        mapButton.topToBottom(of: byText,offset: 15)
        mapButton.leadingToSuperview(offset:20)
        mapButton.height(227)
        mapButton.trailingToSuperview(offset:20)
        
        
        descText.topToBottom(of: mapButton, offset: 20)
        descText.trailing(to: centerText)
        descText.leading(to: centerText)
        descText.snp.makeConstraints({s in
            s.bottom.equalToSuperview().offset(-40)
        })
        
    }
    
}

extension DetailVC:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        var fractionalPage = scrollView.contentOffset.x / pageWidth
        
        fractionalPage = max(0, min(2, fractionalPage))
        
        let currentPage = Int(fractionalPage)
        pageControl.currentPage = currentPage
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = viewModel.galeryData?.data.count else {return 0}
        return count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as? DetailPageCell else {
            return UICollectionViewCell()
        }
        
        guard let url = viewModel.galeryData?.data.images[indexPath.row] else {return UICollectionViewCell()}
        cell.configure(imageURL: url)
        return cell
    }
    
}



#if DEBUG
import SwiftUI
import MapKit

@available(iOS 13, *)
struct DetailVC_Preview: PreviewProvider {
    static var previews: some View{
        
        DetailVC().showPreview()
    }
}
#endif
