//
//  ViewController.swift
//  FindDude
//
//  Created by Dev on 26/04/2018.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit
import Mapbox
import MapboxGeocoder


class ViewController: UIViewController, MGLMapViewDelegate {
    @IBOutlet weak var map: MGLMapView!
    @IBOutlet weak var Input: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Au Lancement on se retrouve a IT AKADEMY
        
        map.delegate = self
        // Set avec les coordonnées GPS
        map.setCenter(CLLocationCoordinate2D(latitude: 45.7398274, longitude: 4.817861099999959), zoomLevel: 10, animated: false)
        view.addSubview(map)
        
        // Marker fixe avec les datas de l'ITAKADEMY
        let hello = MGLPointAnnotation()
        hello.coordinate = CLLocationCoordinate2D(latitude: 45.7398274, longitude: 4.817861099999959)
        hello.title = "IT-AKADEMY"
        hello.subtitle = "11 Passage Panama, 69002 Lyon"
        self.map.addAnnotation(hello)
        
        displayChangeStyleMap()
        self.hideKeyboard()
    }
    
    // Affiche un selecteur de style de carte
    func displayChangeStyleMap() {
       
        
        // Creation d'un rectangle
        let styleToggle = UISegmentedControl(items: ["Dark", "Streets", "Satellites"])
        styleToggle.translatesAutoresizingMaskIntoConstraints = false
        styleToggle.selectedSegmentIndex = 1
        view.insertSubview(styleToggle, aboveSubview: map)
        styleToggle.addTarget(self, action: #selector(changeStyle(sender:)), for: .valueChanged)
        
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[styleToggle]-40-|", options: [], metrics: nil, views: ["styleToggle" : styleToggle]))
        NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: .bottom, relatedBy: .equal, toItem: map.logoView, attribute: .top, multiplier: 1, constant: -20)])
    }
    
    
    // Selecteur de style
    @objc func changeStyle(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            map.styleURL = MGLStyle.darkStyleURL
        case 1:
            map.styleURL = MGLStyle.streetsStyleURL
        case 2:
            map.styleURL = MGLStyle.satelliteStyleURL
        default:
            map.styleURL = MGLStyle.streetsStyleURL
        }
    
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Bouton SEND
    @IBOutlet weak var btn: UIButton!
    // Fonction sur le bouton
    @IBAction func buttonClick(sender: UIButton) {
        
        map.delegate = self
        
        var name : String = ""
        name = Input.text!
        
        // Recupere la clef dans infoplist 
        let geocoder = Geocoder.shared
        
        let options = ForwardGeocodeOptions(query: name)
        options.allowedISOCountryCodes = ["FR"]
        options.focalLocation = CLLocation(latitude: 45.3, longitude: -66.1)
        options.allowedScopes = [.address, .pointOfInterest]
        
        let task = geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemark = placemarks?.first else {
                return
            }
            
            let coordinate = placemark.location?.coordinate
            print("\(coordinate?.latitude), \(coordinate?.longitude)")
            
            
            
            self.map.setCenter(CLLocationCoordinate2D(latitude: (coordinate?.latitude)!, longitude:(coordinate?.longitude)!), zoomLevel: 10,  animated: false)
            self.view.addSubview(self.map)
            
            
            let hello = MGLPointAnnotation()
            hello.coordinate = CLLocationCoordinate2D(latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!)
            hello.title = placemark.name
            // Sous titre : voir pour afficher l'adresse
//            hello.subtitle = placemark.superiorPlacemarks[0].qualifie
            self.map.addAnnotation(hello)

            self.displayChangeStyleMap()
        }
        
    }
    
    //defaut marker
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Affiche titre et label quand on click sur le marker
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
       // Quand la map est chargé cela lance l'animation
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 4500, pitch: 15, heading: 180)
        
        // Durée animation 5s
        mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 4000, pitch: 20, heading: 0)
        mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }

}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
