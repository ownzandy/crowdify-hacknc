//
//  GroupLocator.swift
//  Crowdify
//
//  Created by Cody Li on 10/29/16.
//  Copyright © 2016 Andy Wang. All rights reserved.
//

import GeoFire
import Foundation
import SnapKit
import CoreLocation
import FirebaseDatabase
import Firebase
import UIKit

class GroupLocatorViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let geofireRef = FIRDatabase.database().reference()
    var geoFire: GeoFire!
    var lat : Double = 0.0
    var long : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        geoFire = GeoFire(firebaseRef: geofireRef)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        
        let createGroupButton = UIButton()
        view.addSubview(createGroupButton)
        createGroupButton.backgroundColor = UIColor.green
        createGroupButton.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.centerY.equalTo(view)
        }
        createGroupButton.addTarget(self, action: #selector(joinGroup), for: .touchUpInside)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let current = locations.last

        lat = current!.coordinate.latitude
        long = current!.coordinate.longitude
        
    }
    
    func createGroup() {
        let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
        
        geoFire.setLocation(CLLocation(latitude: lat, longitude: long), forKey: deviceUUID)
    }
    
    func joinGroup() {
        let center = CLLocation(latitude: lat, longitude: long)
        // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
        var circleQuery = geoFire.query(at: center, withRadius: 0.6)
        
//        print(circleQuery)
        
        // Query location by region
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let region = MKCoordinateRegionMake(center.coordinate, span)
        var regionQuery = geoFire.query(with: region)
        
        regionQuery?.observe(.keyEntered, with: { key, location in
            print("Key '\(key!)' entered the search area and is at location '\(location)'")
        })
    }
    
}
