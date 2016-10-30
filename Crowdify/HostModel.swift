//
//  HostModel.swift
//  Crowdify
//
//  Created by Tom Wu on 6/26/16.
//

import Foundation
import Firebase

struct HostModel {
    var ref = FIRDatabase.database().reference()
    
    var groupID: String
    var deviceID: String
    var intervalStr: String
    //var intervalList = [Interval]()
    
    init(snapshot: FIRDataSnapshot){ // Note: you can print any of these values for debugging purposes
        groupID = (snapshot.value as? NSDictionary)?["groupID"] as? String ?? ""
        deviceID = (snapshot.value as? NSDictionary)?["deviceID"] as? String ?? ""
        intervalStr = (snapshot.value as? NSDictionary)?["intervalStr"] as? String ?? ""
        //intervalStr = snapshot.value!["intervalStr"] as! String
        let intervals = intervalStr.components(separatedBy: " ")
        for interval in intervals {
            let vals = interval.components(separatedBy: " ")
            let start = (vals[0] as NSString).doubleValue
            let end = (vals[1] as NSString).doubleValue
            //intervalList.append(Interval(start: start, end: end))
        }
    }
    
    init(groupID: String, deviceID: String, intervalStr: String) {
        self.groupID = groupID
        self.deviceID = deviceID
        self.intervalStr = intervalStr
    }
}
