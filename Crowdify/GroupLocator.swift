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
import UIKit

class GroupLocator: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
    }
    
    
    
}
