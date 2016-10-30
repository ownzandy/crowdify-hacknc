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

class GroupLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    let tableView = UITableView()
    let locationManager = CLLocationManager()
    let geofireRef = FIRDatabase.database().reference()
    var geoFire: GeoFire!
    var lat : Double = 0.0
    var long : Double = 0.0
    var groupSet = Set<String>();
    
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
            make.centerX.equalTo(view.center.x).offset(80)
            make.centerY.equalTo(view.center.y).offset(50)
        }
        createGroupButton.addTarget(self, action: #selector(createGroup), for: .touchUpInside)
        
        let joinGroupButton = UIButton()
        view.addSubview(joinGroupButton)
        joinGroupButton.backgroundColor = UIColor.red
        joinGroupButton.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.equalTo(view.center.x).offset(300)
            make.centerY.equalTo(view.center.y).offset(50)
        }
        joinGroupButton.addTarget(self, action: #selector(joinGroup), for: .touchUpInside)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view.center.y).offset(250)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GroupLocationViewCell.self, forCellReuseIdentifier: GroupLocationViewCell.reuseID)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let current = locations.last

        lat = current!.coordinate.latitude
        long = current!.coordinate.longitude
        
    }
    
    func createGroup() {
        let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
        let uuid = UUID().uuidString
        
        geoFire.setLocation(CLLocation(latitude: lat, longitude: long), forKey: uuid)
        geofireRef.child(uuid).child("leader").setValue(deviceUUID)
        let arr : [String] = []
        geofireRef.child(uuid).child("followers").setValue(arr)
    }
    
    func joinGroup() {
        print("heyheyhey")
        let center = CLLocation(latitude: lat, longitude: long)
        // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
        var circleQuery = geoFire.query(at: center, withRadius: 0.6)

//        print(circleQuery)
        
        // Query location by region
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let region = MKCoordinateRegionMake(center.coordinate, span)
        var regionQuery = geoFire.query(with: region)
        
        regionQuery?.observe(.keyEntered, with: { key, location in
            self.groupSet.insert(key!)
            print("Key '\(key!)' entered the search area and is at location '\(location)'")
        })
        self.tableView.reloadData()

    }
}

extension GroupLocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("testing testing " + String(groupSet.count))
        return groupSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupLocationViewCell.reuseID, for: indexPath) as! GroupLocationViewCell
        cell.groupLabel.text = groupSet[groupSet.index(groupSet.startIndex, offsetBy: indexPath.row)]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellNumber = indexPath.row
        let joinKey = groupSet[groupSet.index(groupSet.startIndex, offsetBy: cellNumber)]
        let currentArray : [String]
        let currentRef = geofireRef.child(joinKey).child("followers")
        
//        currentRef.observeSingleEvent(of: .value, with: { snapshot in
//            
//            if !snapshot.exists() { return }
//            
//            if let currentFollowers = snapshot.value["followers"] as? [String: AnyObject] {
//                currentArray = currentFollowers
//
//            }
//            
//
//        })
        
        currentRef.observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as! [String: AnyObject]
            print("womp")
            print(postDict)
        })
        
        
//        let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
//        currentArray.append(deviceUUID)
//        geofireRef.child(joinKey).child("followers").setValue(currentArray)
//        geofireRef.child(joinKey).child()

//        geofireRef.child(uuid).child("leader").setValue(deviceUUID)
    }
}
