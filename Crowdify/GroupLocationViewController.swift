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
    let geoFire = GeoFire()
    
    let createGroupButton: UIButton! = nil
    let joinGroupButton: UIButton! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRApp.configure()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        view.addSubview(createGroupButton)
        createGroupButton.backgroundColor = UIColor.blue
        createGroupButton.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.centerY.equalTo(view)
        }
        createGroupButton.addTarget(self, action: #selector(createGroup), for: .touchUpInside)
        
    }
    
    func createGroup() {
        geoFire.setLocation(CLLocation(latitude: 37.7853889, longitude: -122.4056973), forKey: "firebase-hq")
    }
    
    
    
}
