//
//  HostBackend.swift
//  Crowdify
//
//  Created by Tom on 6/29/16.
//

import Foundation
import Firebase

class HostBackend {
    var map = [String: Interval]()
    
    // set or add interval
    func setInterval(deviceID: String, interval: Interval) {
        map[deviceID] = interval
    }
    
    func removeInterval() {
        // No longer required
    }
    
    func addDevice(deviceID: String) {
        map[deviceID] = Interval(start: 1.0, end: 1.0)
    }
    
    func removeDevice(deviceID: String) {
        map.removeValue(forKey: deviceID)
    }
    
    func play(deviceID: String, intervals: Interval...) {
        // FireBase polling?
    }
    
    func playBroadcast() {
        for deviceID in map.keys {
            play(deviceID: deviceID, intervals: map[deviceID]!)
        }
    }
    
    func startBroadcast() {
        for deviceID in map.keys {
            // send intervals
        }
        playBroadcast()
    }
    
    // Debugging
    func printMap() {
        print("")
        print("")
        for deviceID in map.keys {
            print("id="+deviceID)
            print("interval="+(map[deviceID]?.toString())!)
        }
        print("")
    }
    
}
