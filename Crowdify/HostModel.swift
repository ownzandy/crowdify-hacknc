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
    var intervalList = [Interval]()
    
    init(snapshot: FIRDataSnapshot){ // Note: you can print any of these values for debugging purposes
        groupID = snapshot.value!["groupID"] as! String
        deviceID = snapshot.value!["deviceID"] as! String
        intervalStr = snapshot.value!["intervalStr"] as! String
        let intervals = intervalStr.split{$0 == " "}
        for interval in intervals {
            let vals = interval.split{$0 == "-"}
            let start = vals[0]
            let end = vals[1]
            intervalList.append(Interval())
        }
    }
    
    init(groupID: String, deviceID: String, intervalList: [Interval]) {
        self.groupID = groupID
        self.deviceID = deviceID
        self.intervalList = intervalList
    }
}
