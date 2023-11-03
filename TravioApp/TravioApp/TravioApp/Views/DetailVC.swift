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

class DetailVC: UIViewController, UIScrollViewDelegate {
    var mapView: MKMapView!
    var pinCoordinate: CLLocationCoordinate2D?
    var viewModel = DetailVM()
//    var placeid:String?{
//        didSet{
//            print("saflfşskşfdsklşfdks\(placeid)")
//        }
//    }
//    

    private lazy var imageCollection:UICollectionView = {
        let l = UICollectionViewFlowLayout()
        l.scrollDirection = .horizontal
        l.minimumLineSpacing = 0
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
        let sb = UIButton()
        sb.setImage(UIImage(named: "save"), for: .normal)
        sb.addTarget(self, action: #selector(buttonSave), for: .touchUpInside)
        return sb
    }()
    private lazy var backButton:UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "bckBtn"), for: .normal)
        b.addTarget(self, action: #selector(back), for: .touchUpInside)
        return b
    }()
    
    private lazy var pageControl:UIPageControl = {
        let p = UIPageControl()
        p.numberOfPages = 3
        p.currentPage = 1
       // p.setCurrentPageIndicatorImage(UIImage(named: "pageControl"), forPage: 2)
        p.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "pageControl")!)
        p.pageIndicatorTintColor = UIColor.lightGray
        p.currentPageIndicatorTintColor = UIColor.black
        //p.backgroundColor = UIColor.green
        return p
    }()
    private var scrollView:UIScrollView = {
        let s = UIScrollView()
        s.isScrollEnabled = true
        s.showsVerticalScrollIndicator = true
        s.contentSize = CGSize(width: s.frame.size.width, height: 1000)
        return s
    }()
    private var centerText:UILabel = {
        let centertxt = UILabel()
        centertxt.text = "İSTANBUL"
        centertxt.textColor = .black
        centertxt.numberOfLines = 1
        centertxt.font = UIFont(name: "Poppins", size: 30)
        return centertxt
    }()
    private var dateText:UILabel = {
        let datetxt = UILabel()
        datetxt.text = "31.10.2023"
        datetxt.textColor = .black
        datetxt.numberOfLines = 1
        //datetxt.backgroundColor = .systemBlue
        datetxt.font = UIFont(name: "Poppins", size: 14)
        return datetxt
    }()
    private var byText:UILabel = {
        let by = UILabel()
        by.text = "Ece Poyraz"
        by.textColor = .black
        by.numberOfLines = 1
        //by.backgroundColor = .systemBlue
        by.font = UIFont(name: "Poppins", size: 10)
        return by
    }()
    private lazy var mapButton:UIButton = {
        let mb = UIButton()
        mb.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        mb.clipsToBounds = true
        mb.layer.cornerRadius = 16
        mb.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        return mb
    }()
    private var descText:UILabel = {
        let txt = UILabel()
        txt.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        txt.textColor = .black
        txt.numberOfLines = 0
        txt.font = UIFont(name: "Poppins", size: 12)
        return txt
    }()
    
    @objc func back(){
        print("tıklandı back")
        var denemee = VisitsVC()
        navigationController?.pushViewController(denemee, animated: true)
        //navigationController?.popViewController(animated: true)
    }
    @objc func mapButtonTapped(){
        //mapvc ye gidecek.
        let vc = MapVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func buttonSave(){
        var testtt = DetailVM()
        saveBtn.setImage(UIImage(named: "savefill"), for: .normal)
        //print("tıklandı")
        saveBtn.addTarget(self, action: #selector(refreshButton), for: .touchUpInside)
       // var paramPost:String
        var id = "1"
//        NetworkingHelper.shared.dataFromRemote(urlRequest: .postVisit(id: id, params: paramPost)) { [weak self] (result:Result<DataPlaces, Error>) in
//
//            switch result {
//            case .success(let data):
//                testtt.fetchVisits(favorites: data.data.places )
//            case .failure(let failure):
//                print(failure.localizedDescription)
//            }
//        }
    }
    @objc func refreshButton(){
        saveBtn.setImage(UIImage(named: "save"), for: .normal)
        saveBtn.addTarget(self, action: #selector(buttonSave), for: .touchUpInside)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupViews()
        imageCollection.delegate = self
        viewModel.reloadClosure = { place in
            guard let place = place else { return }
            self.imageCollection.reloadData()
        }
        var pinCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        let mapSnapshotOptions = MKMapSnapshotter.Options()
                mapSnapshotOptions.region = MKCoordinateRegion(center: pinCoordinate, latitudinalMeters: 100, longitudinalMeters: 100)
                mapSnapshotOptions.size = CGSize(width: 500, height: 500)
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapShotter.start { snapshot, error in
            if let snapshot = snapshot {
                let image = snapshot.image
                self.mapButton.setBackgroundImage(image, for: .normal)

            }
        }
    }
    func setupViews(){
        self.view.backgroundColor = .white
        view.addSubview(imageCollection)
        view.addSubview(saveBtn)
        view.addSubview(backButton)
        view.addSubview(pageControl)
        view.addSubview(scrollView)
        scrollView.addSubview(centerText)
        scrollView.addSubview(dateText)
        scrollView.addSubview(byText)
        scrollView.addSubview(mapButton)
        scrollView.addSubview(descText)
        
        setupLayout()
    }
    
    func setupLayout(){
        imageCollection.edgesToSuperview(excluding: .bottom, insets: .left(0) + .right(0) + .top(0))
        imageCollection.height(249)
        
        saveBtn.topToSuperview(offset:30)
        saveBtn.top(to: imageCollection,offset:50)
        saveBtn.trailingToSuperview(offset:15)
        saveBtn.height(40)
        saveBtn.width(40)
        
        backButton.topToSuperview(offset:30)
        backButton.leadingToSuperview(offset: 20)
        backButton.height(40)
        backButton.width(40)
        
        pageControl.topToSuperview(offset: 180) //offset ayarla.
        pageControl.centerXToSuperview()
        pageControl.leadingToSuperview(offset:20)
        pageControl.height(100)
        pageControl.width(50)
        
        scrollView.topToBottom(of: imageCollection, offset:0)
        scrollView.leadingToSuperview()
        scrollView.trailingToSuperview()
        scrollView.bottomToSuperview()
        
        centerText.topToSuperview()
        centerText.leadingToSuperview(offset:20)
        dateText.topToBottom(of: centerText,offset: 5)
        dateText.leading(to: centerText)
        byText.topToBottom(of: dateText,offset: 5)
        byText.leading(to: dateText)
         

        mapButton.topToBottom(of: byText,offset: 15)
        mapButton.leadingToSuperview(offset:20)
        mapButton.height(227)
        mapButton.width(358)
       
        descText.topToBottom(of: mapButton, offset: -20)
        descText.height(300)
        descText.width(350)
        descText.leading(to: mapButton)

    }

}

extension DetailVC:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        var fractionalPage = scrollView.contentOffset.x / pageWidth

        // Kontrol sınırlarının dışına çıkmasını engelle
        fractionalPage = max(0, min(2, fractionalPage))

        let currentPage = Int(fractionalPage)
        pageControl.currentPage = currentPage
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let c = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as? DetailPageCell else {
            return UICollectionViewCell()
        }
        print(viewModel.currentPlace)
        if let imgUrl = viewModel.currentPlace?.cover_image_url {
            if let url = URL(string: imgUrl) {
                c.configure(imageURL: url)
            }
        }
        return c
    }
}
extension UIImageView{
  func imageFrom(url:URL){
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: url){
        if let image = UIImage(data:data){
          DispatchQueue.main.async{
            self?.image = image
          }
        }
      }
    }
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
