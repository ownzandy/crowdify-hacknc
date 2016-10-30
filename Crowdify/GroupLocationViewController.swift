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
    
    let myColorUtils = ColorUtils() 
    let tableView = UITableView()
    let locationManager = CLLocationManager()
    let rootRef = FIRDatabase.database().reference()
    var geoFire: GeoFire!
    var lat : Double = 0.0
    var long : Double = 0.0
    var groupSet = Set<String>();
    var myUid: String! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myDefaults = UserDefaults.standard
        self.myUid = myDefaults.string(forKey: "token")!
        print("womp token " + self.myUid)
        
        geoFire = GeoFire(firebaseRef: rootRef)
        self.initLocationManager()
        self.addButtons()
        self.addTableView()
    }
    
    func initLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func addTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view.center.y).offset(250)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GroupLocationViewCell.self, forCellReuseIdentifier: GroupLocationViewCell.reuseID)

    }
    
    func addButtons() {
        let cancel = UIButton()
        let refresh = UIButton()
        view.addSubview(cancel)
        view.addSubview(refresh)
        
        cancel.layer.borderColor = myColorUtils.hexStringToUIColor(hex: "d0ced5").cgColor
        cancel.layer.borderWidth = 2.0
        cancel.setTitle("Create Group", for: .normal)
        cancel.setTitleColor(myColorUtils.hexStringToUIColor(hex: "d0ced5"), for: .normal)
        cancel.layer.cornerRadius = 15.0
        cancel.snp.makeConstraints { make in
            make.width.equalTo(130.0)
            make.height.equalTo(30.0)
            make.centerX.equalTo(view.center.x).offset(80)
            make.top.equalTo(view).offset(20)
        }
        cancel.addTarget(self, action: #selector(self.createGroup), for: .touchUpInside)
        
        refresh.layer.borderColor = myColorUtils.hexStringToUIColor(hex: "dc3a79").cgColor
        refresh.layer.borderWidth = 2.0
        refresh.setTitle("Refresh", for: .normal)
        refresh.setTitleColor(myColorUtils.hexStringToUIColor(hex: "dc3a79"), for: .normal)
        refresh.layer.cornerRadius = 15.0
        refresh.snp.makeConstraints { make in
            make.width.equalTo(130.0)
            make.height.equalTo(30.0)
            make.centerX.equalTo(view.center.x).offset(300)
            make.top.equalTo(view).offset(20)
        }
        refresh.addTarget(self, action: #selector(self.refreshGroups), for: .touchUpInside)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let current = locations.last

        lat = current!.coordinate.latitude
        long = current!.coordinate.longitude
    }
    
    func createGroup() {
        print("Create group pressed")
        
        geoFire.setLocation(CLLocation(latitude: lat, longitude: long), forKey: self.myUid)
        rootRef.child(self.myUid).child("leader").setValue(self.myUid)
        // Automatically join created group as a follower (in addition to being a leader)
        let arr: NSArray = [self.myUid]
        rootRef.child(self.myUid).child("followers").setValue(arr) // add self to followers
//        self.groupSet.insert(self.myUid)
        self.tableView.reloadData()
    }

    func refreshGroups() {
        print("Refresh group pressed")
        let center = CLLocation(latitude: lat, longitude: long)
        // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
//        var circleQuery = geoFire.query(at: center, withRadius: 0.6)
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
        let currentRef = rootRef.child(joinKey)
        print(self.myUid)
        
        currentRef.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            
            if snapshot.hasChild("followers") {
                print("has followers")
                print(snapshot.value)
                if let snapValue = snapshot.value as? NSDictionary {
                    var arr = snapValue["followers"] as! [String]
                    print(arr)
                    print(self.myUid)
                    if !arr.contains(self.myUid) {
                        print("appending self...")
                        arr.append(self.myUid)
                        currentRef.child("followers").setValue(arr) // add self to followers
                    }
                    else {
                        print("duplicate")
                    }
                }
            }
            else {
                print("no followers")
                let arr: NSArray = [self.myUid]
                currentRef.child("followers").setValue(arr) // add self to followers
            }
        })
        
        // TODO: transition to PlaylistVC afterwards 
    }
}
