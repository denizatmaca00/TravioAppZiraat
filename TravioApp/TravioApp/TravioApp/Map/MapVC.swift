import UIKit
import MapKit

class MapVC: UIViewController {
    
    let viewModel = MapVM()
    var selectedAnnotation: MKAnnotation?
    var updateMapClosure: (() -> Void)?

    private lazy var collectionView: UICollectionView = {
        let layout = MapPageLayout.shared.mapLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MapPlacesCellVC.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchAndShowPlaces()
        setupViews()
        viewModel.map.delegate = self
        setupTapGestureRecognizer()

       // initVM()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       initVM()
    }
    
    func initVM() {
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.fetchPlacesForCollectionCell()
    }
    
    func setupViews() {
        self.view.addSubview(viewModel.map)
        self.view.addSubview(collectionView)
        setupLayout()
    }
    
    func setupLayout() {
        collectionView.snp.makeConstraints { cv in
            cv.leading.equalToSuperview()
            cv.trailing.equalToSuperview()
            cv.bottom.equalToSuperview().offset(-20)
            cv.height.equalTo(178)
        }
        viewModel.map.frame = view.bounds
        viewModel.map.showsUserLocation = true
    }
    
    func setupTapGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        viewModel.map.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: viewModel.map)
            let coordinate = viewModel.map.convert(touchPoint, toCoordinateFrom: viewModel.map)
            
            // Eğer önceki bir seçili pin varsa, onu kaldır
            if let existingAnnotation = selectedAnnotation {
                viewModel.map.removeAnnotation(existingAnnotation)
            }
            
            // Eğer önceki bir seçili pin varsa, seçili pin'i kaldır ama çalışmıyor
            deselectSelectedAnnotation()

            let newAnnotation = CustomAnnotation(
                title: "Yeni Pin",
                subtitle: "Açıklama",
                coordinate: coordinate,
                logoImage: UIImage(named: "pinLogo")
            )
            viewModel.map.addAnnotation(newAnnotation)
            
            // Yeni pin'i seçili olarak işaretle
            selectedAnnotation = newAnnotation
            
            let vc = MapPresentVC()
            vc.latitude = coordinate.latitude
            vc.longitude = coordinate.longitude
            
            vc.updateMapClosure = { [weak self] in
                self?.initVM()}
            self.present(vc, animated: true, completion: nil)
        }
    }

}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if let customAnnotation = annotation as? CustomAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: "custom")
                annotationView?.canShowCallout = false
            }
            
            annotationView?.image = UIImage(named: "pin")
            
            if let logoImage = customAnnotation.logoImage {
                let logoImageView = UIImageView(image: logoImage)
                logoImageView.frame = CGRect(x: 3.92, y: 3.62, width: 23, height: 21)
                annotationView?.addSubview(logoImageView)
            }
            
            return annotationView
        }
        
        return nil
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? CustomAnnotation,
              let index = viewModel.places.firstIndex(where: { $0.title == annotation.title }) else {
            return
        }

        selectCollectionViewCell(at: index)

        if annotation === selectedAnnotation {
            deselectSelectedAnnotation()
        }
    }

    func deselectSelectedAnnotation() {
        if let selectedAnnotation = selectedAnnotation {
            viewModel.map.removeAnnotation(selectedAnnotation)
            self.selectedAnnotation = nil
        }
    }


    func selectCollectionViewCell(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }


}

extension MapVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.places.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.tappedCellMap(at: indexPath)
        print("ldfkhlfh")
        //map didselect cell id detail sayfasına iletilecek.
        let vc = DetailVC()
        let deger = vc.viewModel.placeIdtest = viewModel.places[indexPath.row].id
        print(deger)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MapPlacesCellVC else {
            fatalError("cell does not exist")
        }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.visitCellViewModel = cellVM
        return cell
        
    }
}


//extension MapVC: CLLocationManagerDelegate{
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let mUserLocation:CLLocation = locations[0] as CLLocation
//        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
//        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        map.setRegion(mRegion, animated: true)
//
//        // kullnıcının şimdiki konumunu alıp pin bırakacak olan bu diyor medium
//        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
//        mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
//        mkAnnotation.title = self.setUsersClosestLocation(mLattitude: mUserLocation.coordinate.latitude, mLongitude: mUserLocation.coordinate.longitude)
//        map.addAnnotation(mkAnnotation)
//    }
//    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) -> String {
//        let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: mLattitude, longitude: mLongitude)
//
//        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
//            if let placemark = placemarks?.first {
//                if let name = placemark.name,
//                   let city = placemark.locality {
//                    self.currentLocationStr = "\(name), \(city)"
//                }
//            }
//        }
//        return currentLocationStr
//    }
//
//
//}
#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct MapVC_Preview: PreviewProvider {
    static var previews: some View{
        
        MapVC().showPreview()
    }
}
#endif

    

    
