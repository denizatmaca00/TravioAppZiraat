import UIKit
import MapKit
// protocol mapte

protocol ReloadData{
    func reloadMapData()
}

class MapVC: UIViewController {
    
    let viewModel = MapVM()
    var selectedAnnotation: MKAnnotation?
    var addedPin: MKAnnotation?
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
        setupTapGestureRecognizer()
        viewModel.map.delegate = self
        setupViews()
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
    func initVM() {
        viewModel.reloadCollectionViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.addPinUpdate()
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
            cv.top.equalToSuperview().offset(self.view.frame.height * 0.67)
            cv.bottom.equalToSuperview().offset(self.view.frame.height * 0.75)
            cv.left.right.equalToSuperview()
        }
        viewModel.map.frame = view.bounds
        viewModel.map.showsUserLocation = true
    }
    
    func setupTapGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        viewModel.map.addGestureRecognizer(longPressGesture)
    }
    
    func addPinUpdate(){
        viewModel.map.removeAnnotations(viewModel.map.annotations)
        
        for pin in viewModel.places{
            if let latitude = pin.latitude, let longitude = pin.longitude{
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                viewModel.addCustomAnnotation(title: "", subtitle: "", coordinate: coordinate, logoImage: UIImage(named: "pinLogo"))
            }
            
        }
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: viewModel.map)
            let coordinate = viewModel.map.convert(touchPoint, toCoordinateFrom: viewModel.map)
            
            addedPin = viewModel.map.annotations.last
            
            let vc = MapPresentVC()
            vc.latitude = coordinate.latitude
            vc.longitude = coordinate.longitude
            vc.delegate = self
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
              let index = viewModel.places.firstIndex(where: { $0.latitude == annotation.coordinate.latitude && $0.longitude == annotation.coordinate.longitude}) else {
            return
        }
        selectCollectionViewCell(at: index)
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
        vc.viewModel.placeId = viewModel.places[indexPath.row].id
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
    }
}
extension MapVC : ReloadData{
    func reloadMapData() {
        initVM()
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




