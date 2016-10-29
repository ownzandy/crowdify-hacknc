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
        createGroupButton.addTarget(self, action: #selector(createGroup), for: .touchUpInside)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let current = locations.last

        lat = current!.coordinate.latitude
        long = current!.coordinate.longitude
        
//        print("locations = \(lat) \(long)")
    }
    
    func createGroup() {
        let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
        
        geoFire.setLocation(CLLocation(latitude: lat, longitude: long), forKey: deviceUUID)
    }
    
    
    
}
