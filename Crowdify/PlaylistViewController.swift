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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player?.playbackDelegate = self
        
        let crowdRef = self.ref.child("crowds").child(crowdID).child("songs").queryOrdered(byChild: "index")
        
        crowdRef.observe(FIRDataEventType.value, with: { snapshot in
            if let tracks = snapshot.value as? [String: AnyObject] {
                let sortedTracks = tracks.sorted {
                    return ($0.value["index"] as! Int) < ($1.value["index"] as! Int)
                }
                var newTracks: [Track] = []
                for (_, value) in sortedTracks {
                    if let track = value as? [String: AnyObject] {
                        newTracks.append(Track(name: track["name"] as! String,
                                               uri: URL(string: track["uri"] as! String)!,
                                               artists: track["artists"] as! [String],
                                               coverArt: URL(string: track["coverArt"] as! String)!,
                                               albumName: track["albumName"] as! String))
                    }
                }
                self.playTracks = newTracks
                self.tableView.reloadData()
            }
        })

        view.addSubview(navBar)
        navBar.backgroundColor = UIColor.blue
        navBar.snp.makeConstraints { make in
            make.top.width.equalTo(view)
            make.height.equalTo(50)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-100)
            make.top.equalTo(navBar.snp.bottom)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: PlaylistTableViewCell.reuseID)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        let playView = UIView()
        playView.backgroundColor = UIColor.black
        view.addSubview(playView)
        playView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.bottom.left.right.equalTo(view)
        }
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(startPlaying))
        playView.addGestureRecognizer(gestureRecognizer)
    }
    
    func startPlaying() {
        if(playTracks.count > 0) {
            print(playTracks.first?.uri.absoluteString)
            player?.playSpotifyURI(playTracks.first?.uri.absoluteString, startingWith: 0, startingWithPosition: 0, callback: { error -> Void in
                if(error != nil) {
                    print("Error playing Spotify URI", error)
                    return
                }
                print("playing music")
            })
        }
            
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
                    return Track(name: track.name, uri: track.playableUri, artists: artists, coverArt: track.album.smallestCover.imageURL, albumName: track.album.name)
                }
                self.searchTracks = tracks
                self.tableView.reloadData()
            }
        })
    }
    
}

extension PlaylistViewController: SPTAudioStreamingPlaybackDelegate {
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {
        let crowdRef = self.ref.child("crowds").child(crowdID)
        crowdRef.observeSingleEvent(of: FIRDataEventType.value, with: { snapshot in
            let currentTime = Date().timeIntervalSince1970
            if let crowd = snapshot.value as? [String: AnyObject], let uri = trackUri {
                if let currentSong = crowd["currentSong"] as? String, let time = crowd["currentTime"] as? Double {
                    if(currentSong == uri) {
                        print(currentTime - time)
                        self.player?.seek(to: currentTime - time, callback: { error in
                            if(error != nil) {
                                print("errored when seeking", error)
                                return
                            }
                            print("successfully sync'd")
                            return
                        })
                    }
                }
                crowdRef.updateChildValues(["currentSong": trackUri!, "currentTime": currentTime])
            }
        })
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
        
        cell.backgroundColor = UIColor .gray
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
        if searchActive {
            let crowdRef = self.ref.child("crowds").child(crowdID).child("songs")
            let newSong = crowdRef.childByAutoId()
            let track = searchTracks[indexPath.row]
            newSong.setValue(["name": track.name, "uri": track.uri.absoluteString, "artists": track.artists, "coverArt": track.coverArt.absoluteString, "albumName": track.albumName, "index": playTracks.count + 1])
        }
    }
}
