//
//  ViewController.swift
//  Mapping101
//
//  Created by AJMac on 2/19/19.
//  Copyright © 2019 AJMac. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

   
    
    @IBOutlet weak var mapView: MKMapView!
     @IBOutlet weak var locationText: UILabel!
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
    }
    
    @IBAction func addCurrentLocationMarker(_ sender: Any) {
        if let location = locationManager.location {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            let timeStamp = dateFormatter.string(from: Date())
            annotation.title = "You were here at \(timeStamp)"
            mapView.addAnnotation(annotation)
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: {(placeMarks: [CLPlacemark]?, error: Error?) in
                if error == nil {
                    let placeMark = placeMarks![0]
                    self.reverseGeocodeComplete(location:placeMark)
                    
                }
            })
        }
    }
    
    func reverseGeocodeComplete(location: CLPlacemark){
        let locationString = "\(location)"
        print(locationString)
        self.locationText.text = locationString
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse{
            mapView.showsUserLocation = true
            moveToCurrentLocation()
        } else {
            let alert = UIAlertController(title: "Can't Display Location", message: "Please grant permission in settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: { (action: UIAlertAction) -> Void in UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)}))
            present (alert, animated: true, completion: nil)
        }
        
        
    }
    func moveToCurrentLocation() {
        if let location = locationManager.location {
            mapView.setCenter(location.coordinate, animated: true)
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinAnnotation = MKPinAnnotationView()
            pinAnnotation.pinTintColor = UIColor.cyan
            pinAnnotation.annotation = annotation
            pinAnnotation.canShowCallout = true
            return pinAnnotation
        }
        return nil
    }
    
}

