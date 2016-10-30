//
//  PlaylistViewController.swift
//  Crowdify
//
//  Created by Andy Wang on 10/29/16.
//  Copyright © 2016 Andy Wang. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage

class PlaylistViewController: UIViewController, UISearchBarDelegate {
    
    var crowdID = "crowdID"
    var playTracks: [Track] = []
    var searchTracks: [Track] = []
    let searchController = UISearchController(searchResultsController: nil)
    let tableView = UITableView()
    let navBar = UINavigationBar()
    let player = SPTAudioStreamingController.sharedInstance()
    var ref = FIRDatabase.database().reference()
    var searchActive: Bool = false
    var playing: Bool = false
    var master: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player?.playbackDelegate = self
        
        self.ref.child("sync").setValue(["sync": "true"])
        
        let crowdRef = self.ref.child("crowds").child(crowdID).child("songs").queryOrdered(byChild: "index")
        
        crowdRef.observe(FIRDataEventType.value, with: { snapshot in
            if let tracks = snapshot.value as? [String: AnyObject] {
                let sortedTracks = tracks.sorted {
                    return ($0.value["index"] as! Int) < ($1.value["index"] as! Int)
                }
                var newTracks: [Track] = []
                for (key, value) in sortedTracks {
                    if let track = value as? [String: AnyObject] {
                        newTracks.append(Track(name: track["name"] as! String,
                                               uri: URL(string: track["uri"] as! String)!,
                                               artists: track["artists"] as! [String],
                                               coverArt: URL(string: track["coverArt"] as! String)!,
                                               albumName: track["albumName"] as! String,
                                               firebaseID: key,
                                               index: track["index"] as! Int))
                    }
                }
                self.playTracks = newTracks
                self.tableView.reloadData()
            }
        })
        
        self.navBar.barStyle = UIBarStyle.black
        self.navBar.barTintColor = UIColor(red:0.09, green:0.09, blue:0.10, alpha:1.0)
        self.navBar.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.10, alpha:1.0)
        
        view.addSubview(navBar)
        navBar.snp.makeConstraints { make in
            make.top.width.equalTo(view)
            make.height.equalTo(20)
        }
        
        let titleView = UIView()
        titleView.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.10, alpha:1.0)
        view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(40)
        }
        
        let navTitle = UILabel()
        navTitle.text = "My Crowd"
        
        (UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])).tintColor = UIColor(red:0.86, green:0.23, blue:0.47, alpha:1.0)
        
        navTitle.textColor = UIColor(red:0.86, green:0.23, blue:0.47, alpha:1.0)
        navTitle.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.10, alpha:1.0)
        
        titleView.addSubview(navTitle)
        navTitle.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(titleView.snp.top).offset(10)
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleSync))
        navTitle.addGestureRecognizer(gestureRecognizer)
        
        self.tableView.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.10, alpha:1.0)
        
        view.addSubview(tableView)
        
        let backView = UIView(frame: self.tableView.bounds)
        backView.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.10, alpha:1.0)
        self.tableView.backgroundView = backView
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor(red:0.09, green:0.09, blue:0.10, alpha:1.0)
        tableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: PlaylistTableViewCell.reuseID)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.10, alpha:1.0)
        searchController.searchBar.barTintColor = UIColor(red:0.09, green:0.09, blue:0.10, alpha:1.0)
        
        
        let controlView = UIView()
        controlView.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.10, alpha:1.0)
        view.addSubview(controlView)
        controlView.snp.makeConstraints { make in
            make.bottom.equalTo(view)
            make.height.equalTo(75)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.bottom.equalTo(controlView.snp.top)
            make.top.equalTo(navTitle.snp.bottom).offset(8)
        }
        
        let playView = UIButton()
        let playString = "https://s14.postimg.org/hx7cold9t/play.png"
        let playUrl = URL(string: playString)
        let playData = try? Data(contentsOf: playUrl!)
        playView.setBackgroundImage(UIImage(data: playData!), for: .normal)
        
        controlView.addSubview(playView)
        playView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.bottom.equalTo(view).offset(-15)
            make.centerX.equalTo(tableView.snp.centerX)
        }
        
        let leftView = UIButton()
        let leftString = "https://s14.postimg.org/oia2bzx75/back.png"
        let leftUrl = URL(string: leftString)
        let leftData = try? Data(contentsOf: leftUrl!)
        leftView.setBackgroundImage(UIImage(data: leftData!), for: .normal)
        
        controlView.addSubview(leftView)
        leftView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(40)
            make.centerY.equalTo(controlView).offset(-3)
            make.right.equalTo(playView.snp.left).offset(-15)
        }
        
        let rightView = UIButton()
        let rightString = "https://s14.postimg.org/bnln1o2o1/forward.png"
        let rightUrl = URL(string: rightString)
        let rightData = try? Data(contentsOf: rightUrl!)
        rightView.setBackgroundImage(UIImage(data: rightData!), for: .normal)
        
        controlView.addSubview(rightView)
        rightView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(40)
            make.centerY.equalTo(controlView).offset(-3)
            make.left.equalTo(playView.snp.right).offset(15)
        }
        
        playView.addTarget(self, action: #selector(startPlaying), for: .touchUpInside)
        leftView.addTarget(self, action: #selector(goToBeginning), for: .touchUpInside)
        rightView.addTarget(self, action: #selector(nextSong), for: .touchUpInside)
        
        let controlRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleSync))
        controlView.addGestureRecognizer(controlRecognizer)
        
        syncListener()
    }
    
    func goToBeginning() {
        let songRef = self.ref.child("song")
        songRef.updateChildValues(["offset": 0])
        toggleSync()
        master = true
    }
    
    func toggleSync() {
        master = false
        let syncToggleRef = self.ref.child("sync")
        syncToggleRef.observeSingleEvent(of: FIRDataEventType.value, with: { result in
            syncToggleRef.setValue(["sync": ProcessInfo.processInfo.globallyUniqueString])

        })
    }
    
    func syncListener() {
        let syncToggleRef = self.ref.child("sync")
        syncToggleRef.observe(FIRDataEventType.value, with: { result in
            self.startPlaying()
        })
    }
    
    func startPlaying() {
        if let trackUri = playTracks.first?.uri.absoluteString {
            if(playTracks.count > 0) {
                let songRef = self.ref.child("song")
                songRef.updateChildValues(["currentSong": trackUri])
                songRef.observeSingleEvent(of: FIRDataEventType.value, with: { snapshot in
                    if let song = snapshot.value as? [String: AnyObject] {
                        if let offset = song["offset"] as? Double {
                            self.playWithOffset(offset: Double(Int(offset)), trackUri: trackUri)
                        } else {
                            self.master = true
                            songRef.updateChildValues(["offset": 0])
                            self.playWithOffset(offset: 0, trackUri: trackUri)
                        }
                    } else {
                        songRef.updateChildValues(["offset": 0])
                        self.master = true
                        self.playWithOffset(offset: 0, trackUri: trackUri)
                    }
                })
            }
        }
    }
    
    func playWithOffset(offset: TimeInterval, trackUri: String) {
        player?.playSpotifyURI(trackUri, startingWith: 0, startingWithPosition: offset, callback: { error -> Void in
            if(error != nil) {
                print("Error playing Spotify URI", error)
                return
            }
            print("playing music")
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String) {
        let accessToken = UserDefaults.standard.object(forKey: "token") as! String
        SPTSearch.perform(withQuery: searchText, queryType: SPTSearchQueryType.queryTypeTrack, offset: 0, accessToken: accessToken, market: nil, callback: { error, result -> Void in
            let list = result as? SPTListPage
            if let items = list?.items as? [SPTPartialTrack] {
                let tracks: [Track] = items.map { track in
                    let artists: [String] = track.artists.map { artist in
                        if let artistObject = artist as? SPTPartialArtist {
                            if let name = artistObject.name {
                                return name
                            }
                        }
                        return ""
                    }
                    return Track(name: track.name, uri: track.playableUri, artists: artists, coverArt: track.album.smallestCover.imageURL, albumName: track.album.name, firebaseID: "N/A", index: -1)
                }
                self.searchTracks = tracks
                self.tableView.reloadData()
            }
        })
    }
    
}

extension PlaylistViewController: SPTAudioStreamingPlaybackDelegate {
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
        nextSong()
    }
    
    func nextSong() {
        self.ref.child("crowds").child(crowdID).child("songs").child((playTracks.first?.firebaseID)!).removeValue()
        playTracks.remove(at: 0)
        tableView.reloadData()
        let songRef = self.ref.child("song")
        if let trackUri = playTracks.first?.uri.absoluteString {
            songRef.setValue(["currentSong": trackUri])
        }
        toggleSync()
        master = true
        startPlaying()
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
        if master {
            let songRef = self.ref.child("song")
            songRef.updateChildValues(["offset": position])
        }
    }
    
}

extension PlaylistViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}

extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var tracks: [Track]
        tracks = searchActive ? searchTracks : playTracks
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableViewCell.reuseID, for: indexPath) as! PlaylistTableViewCell
        
        var tracks: [Track]
        tracks = searchActive ? searchTracks : playTracks
        
        cell.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.10, alpha:1.0)
        var artist = ""
        let album = "• "
        
        let url = tracks[indexPath.item].coverArt
        cell.albumArt.sd_setImage(with: url)
        
        cell.songLabel.text = tracks[indexPath.item].name
        cell.songLabel.font = UIFont(name:"Avenir", size:16)
        cell.songLabel.textColor = UIColor .white
        
        for name in tracks[indexPath.item].artists {
            artist += name
            artist += " "
        }
        
        cell.artistAlbumLabel.text = artist + album + tracks[indexPath.item].albumName
        cell.artistAlbumLabel.font = UIFont(name:"Avenir", size:12)
        cell.artistAlbumLabel.textColor = UIColor .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if searchActive {
            let crowdRef = self.ref.child("crowds").child(crowdID).child("songs")
            let newSong = crowdRef.childByAutoId()
            let track = searchTracks[indexPath.row]
            searchController.dismiss(animated: true, completion: nil)
            if playTracks.count > 0 {
                newSong.setValue(["name": track.name, "uri": track.uri.absoluteString, "artists": track.artists, "coverArt": track.coverArt.absoluteString, "albumName": track.albumName, "index": (playTracks.last?.index)! + 1])
            } else {
                newSong.setValue(["name": track.name, "uri": track.uri.absoluteString, "artists": track.artists, "coverArt": track.coverArt.absoluteString, "albumName": track.albumName, "index": 1])
            }
        }
    }
}


