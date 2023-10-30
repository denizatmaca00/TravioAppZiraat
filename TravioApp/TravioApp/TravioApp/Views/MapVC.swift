import UIKit
import MapKit
import SnapKit

class MapVC: UIViewController {
    
    let map = MKMapView()
    let coordinate = CLLocationCoordinate2D(latitude: 40.720, longitude: -74)
    let pin = MKPointAnnotation()
    let pinLogoImageView = UIImageView(image: UIImage(named: "pinLogo")) // Pin logosunun adını ve boyutunu uygun şekilde ayarlayın
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        setupViews()
        addCustomPin()
    }
    
    private func addCustomPin() {
        pin.coordinate = coordinate
        pin.title = "Pin Burada"
        pin.subtitle = "pine gdebilir misin?"
    }
    
    func setupViews() {
        self.view.addSubview(map)
        map.addAnnotation(pin)

        map.addSubview(pinLogoImageView)
        setupLayout()
    }
    
    func setupLayout() {
        map.frame = view.bounds
        map.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
        
        pinLogoImageView.snp.makeConstraints { img in
            img.centerX.equalTo(map)
            img.centerY.equalTo(map).offset(-3.62)
            img.width.equalTo(25)
            img.height.equalTo(25)
        }
    }
}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if let annotationView = annotationView {
            annotationView.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
        }
        
        annotationView?.image = UIImage(named: "pin")
        
        return annotationView
    }
}
extension MapVC: CLLocationManagerDelegate{
    //MARK:- CLLocationManagerDelegate Methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation:CLLocation = locations[0] as CLLocation

        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        map.setRegion(mRegion, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }

}
// deneme
