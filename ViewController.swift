//
//  ViewController.swift
//  MemorablePlaces
//
//  Created by Lana Sanyoura on 1/1/17.
//  Copyright © 2017 Lana Sanyoura. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var address = ""
    var subtitle = ""
    var throughRow = false 
    var currLocation = CLLocation()
    var memorablePlaces : [String : String] =  [:]
    var orderedAddress = [String]()
    @IBOutlet var map: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        let userMem = UserDefaults.standard.object(forKey: "memorablePlaces")
        let orderedAdd =  UserDefaults.standard.object(forKey:"orderedAddress")
        if userMem == nil {
            
            UserDefaults.standard.setValue(memorablePlaces, forKey:"memorablePlaces")  // The text written on the anotation
            UserDefaults.standard.setValue(orderedAddress, forKey:"orderedAddress")  // The text written on the anotation

        } else {
            memorablePlaces = userMem as!  [String: String]
            orderedAddress = orderedAdd as! [String]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*
        for address in self.memorablePlaces {
            let latitude: CLLocationDegrees = CLLocationDegrees(self.memorablePlaces[address.key]!["latitude"]!)
            let longitude : CLLocationDegrees = CLLocationDegrees(self.memorablePlaces[address.key]!["longitude"]!)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate

            annotation.title = address.key
    
        } */
        if throughRow {
            let latLong = self.memorablePlaces[self.address]?.components(separatedBy: ",")
            let latitude: CLLocationDegrees = CLLocationDegrees(latLong![0])!
            let longitude : CLLocationDegrees = CLLocationDegrees(latLong![1])!
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            self.currLocation = CLLocation(latitude: latitude, longitude: longitude)
            
            self.configMap(location: CLLocation(latitude: latitude, longitude: longitude))
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
        
            annotation.title = self.address
            map.addAnnotation(annotation)
            
        } else {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress(gestureRecognizer:)))
            longPressGestureRecognizer.minimumPressDuration = 2
            map.addGestureRecognizer(longPressGestureRecognizer)
        }
    }
    
    func longPress( gestureRecognizer : UIGestureRecognizer) {
        
        let touchPoint : CGPoint = gestureRecognizer.location(in: self.map)
        let coordinates = self.map.convert(touchPoint, toCoordinateFrom: map)
        let latitude : String = String(coordinates.latitude)
        let longitude : String = String(coordinates.longitude)
        self.currLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        /*
        self.setAddress()
        var i = 0
        while self.address == "" {
             i += 1
             self.setAddress()
            print("\n The address is \(self.address) \(i)\n")
        }
        /*
        var newAddress = ""
        CLGeocoder().reverseGeocodeLocation(self.currLocation) { (placeMarks, error) in
            
            if error != nil {
                print("\n THERE WAS AN ERROR \(error)\n")
                
            } else {
                let placeMark = placeMarks?[0]
                
                if  placeMark?.subThoroughfare != nil {
                    newAddress = placeMark!.subThoroughfare!
                    print("\nGEO" + newAddress + "\n")
                }
                
                if placeMark?.thoroughfare != nil {
                    newAddress = newAddress + " " + placeMark!.thoroughfare!
                    print("\nGEO" + newAddress + "\n")
                }
                
                if placeMark?.subLocality != nil {
                    newAddress = newAddress + " " + placeMark!.subLocality!
                    print("\nGEO" + newAddress + "\n")
                }
                if placeMark?.country != nil {
                    self.subtitle = self.subtitle + " " + placeMark!.country!
                }
                if placeMark?.administrativeArea != nil {
                    self.subtitle = placeMark!.administrativeArea!
                }
                
            }
            
        }
        
        print("\nThis is the NEW ADDRESS \(newAddress)\n")
        */
        */
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func configMap(location: CLLocation) {
        let lanDelta = 0.01
        let lonDelta = 0.01
        let span = MKCoordinateSpan(latitudeDelta: lanDelta, longitudeDelta: lonDelta)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        self.map.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.configMap(location: locations[0])
        self.setAddress()
        }
    func setAddress() {
        CLGeocoder().reverseGeocodeLocation(self.currLocation) { (placeMarks, error) in
          
            if error != nil {
                print("\n THERE WAS AN ERROR \(error)\n")
                
            } else {
                let placeMark = placeMarks?[0]
                
                if  placeMark?.subThoroughfare != nil {
                    self.address = placeMark!.subThoroughfare!
                }
                
                if placeMark?.thoroughfare != nil {
                    self.address = self.address + " " + placeMark!.thoroughfare!
                }
                
                if placeMark?.subLocality != nil {
                    self.address = self.address + " " + placeMark!.subLocality!
                }
                if placeMark?.country != nil {
                    self.subtitle = self.subtitle + " " + placeMark!.country!
                }
                if placeMark?.administrativeArea != nil {
                    self.subtitle = placeMark!.administrativeArea!
                }
                
            }
            if self.address != "" {
                let annotation = MKPointAnnotation()
                annotation.coordinate = self.currLocation.coordinate
                annotation.title = self.address
                annotation.subtitle = self.subtitle
                self.map.addAnnotation(annotation)
                
                let value = "\(self.currLocation.coordinate.latitude),\(self.currLocation.coordinate.longitude)"
                
                if !(self.orderedAddress.contains(self.address)) {
                    self.memorablePlaces[self.address] = value
                    self.orderedAddress.append(self.address)
                    
                    UserDefaults.standard.setValue(self.memorablePlaces, forKey:"memorablePlaces")
                    UserDefaults.standard.setValue( self.orderedAddress, forKey:"orderedAddress")
                }
                
                self.currLocation = CLLocation()
            }

            
        }

    }
}

