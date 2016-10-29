//
//  AppDelegate.swift
//  Crowdify
//
//  Created by Andy Wang on 10/28/16.
//  Copyright © 2016 Andy Wang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SPTAudioStreamingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SPTAuth.defaultInstance().clientID = "1e6187fb28dd41308bf132bec985eb76"
        SPTAuth.defaultInstance().redirectURL = URL(string: "crowdify-hacknc://callback")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope]
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = LoginViewController()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(SPTAuth.defaultInstance().canHandle(url))
        if SPTAuth.defaultInstance().canHandle(url) {
            SPTAuth.defaultInstance().handleAuthCallback(withTriggeredAuthURL: url, callback: { error, session -> Void in
                print(session)
                if error != nil {
                    print("AUTHENTICATION ERROR", error)
                    return
                }
                self.loginWithSession(session: session!)
            })
            return true
        }
        return false
    }
    
    func loginWithSession(session: SPTSession) {
        let player = SPTAudioStreamingController.sharedInstance()
        player?.delegate = self
        do {
            try player?.start(withClientId: "1e6187fb28dd41308bf132bec985eb76")
            player?.login(withAccessToken: session.accessToken)
        } catch {
            print("PLAYER COULD NOT BE STARTED")
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        SPTAudioStreamingController.sharedInstance().playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { error -> Void in
            if(error != nil) {
                print("Error playing Spotify URI", error)
                return
            }
        })
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

