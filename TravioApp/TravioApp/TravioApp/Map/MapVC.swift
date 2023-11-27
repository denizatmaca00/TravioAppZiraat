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
        viewModel.fetchAndShowPlaces()
        viewModel.map.delegate = self

        setupViews()
        setupTapGestureRecognizer()
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       initVM()
        locationPermissionMap()
    }
 
    func locationPermissionMap(){
            let locationManager = CLLocationManager()
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                print("Location access granted.")
            default:
                print("Location access denied.")
                locationManager.requestWhenInUseAuthorization()
            }
    }
//duruma göre default locationa izin sonrası pin atabilir.
//    func statusPermissionMap(){
//            let locationManager = CLLocationManager()
//            let status = CLLocationManager.authorizationStatus()
//            switch status {
//            case .authorizedWhenInUse, .authorizedAlways:
//                print("Location access granted.")
//            default:
//                print("Location access denied.")
//            }
//    }
    func initVM() {
        viewModel.reloadCollectionViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.fetchPlacesForCollectionCell()
    }
    
    func setupViews() {
        self.view.addSubviews(viewModel.map,collectionView)
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
            
            deselectSelectedAnnotation()

            viewModel.addCustomAnnotation(title: "Yeni Pin", subtitle: "Açıklama", coordinate: coordinate, logoImage: UIImage(named: "pinLogo"))
            
            selectedAnnotation = viewModel.map.annotations.last
            
            let vc = MapPresentVC()
            vc.latitude = coordinate.latitude
            vc.longitude = coordinate.longitude
            
            vc.viewModel.updateMapClosure = { [weak self] in
                self?.initVM()
            }
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
        let vc = DetailVC()
        vc.viewModel.placeIdtest = viewModel.places[indexPath.row].id
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

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct MapVC_Preview: PreviewProvider {
    static var previews: some View{
        
        MapVC().showPreview()
    }
}
#endif

    

    
