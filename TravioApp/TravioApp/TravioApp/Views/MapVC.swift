import UIKit
import MapKit



class MapVC: UIViewController {
    
    let map = MKMapView()
    let coordinate = CLLocationCoordinate2D(latitude: 40.93567, longitude: 29.15507)

    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        setupViews()
        setupTapGestureRecognizer()
        addInitialPin()
    }

    func setupViews() {
        self.view.addSubview(map)
        setupLayout()
    }

    func setupLayout() {
        map.frame = view.bounds
        map.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
    }

    func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        map.addGestureRecognizer(tapGesture)
    }
    func addInitialPin() {
        let firstAnnotation = CustomAnnotation(title: "PinBurada", subtitle: "içindekiler", coordinate: coordinate, logoImage: UIImage(named: "pinLogo"))
        map.addAnnotation(firstAnnotation)
    }

    @objc func handleMapTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let touchPoint = sender.location(in: map)
            let coordinate = map.convert(touchPoint, toCoordinateFrom: map)
            let newAnnotation = CustomAnnotation(
                title: "Yeni Pin",
                subtitle: "Açıklama",
                coordinate: coordinate,
                logoImage: UIImage(named: "pinLogo")
            )
            map.addAnnotation(newAnnotation)
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
