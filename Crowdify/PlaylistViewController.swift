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
    
    var playTracks: [Track] = []
    var searchTracks: [Track] = []
    let searchController = UISearchController(searchResultsController: nil)
    let tableView = UITableView()
    let navBar = UINavigationBar()
    var ref = FIRDatabase.database().reference()
    var searchActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let crowdRef = self.ref.child("crowds").child("crowdID")
        
        crowdRef.observe(FIRDataEventType.value, with: { snapshot in
            if let tracks = snapshot.value as? [String: AnyObject] {
                var newTracks: [Track] = []
                for (_, value) in tracks {
                    if let track = value as? [String: AnyObject] {
                        newTracks.append(Track(name: track["name"] as! String,
                                               uri: URL(string: track["uri"] as! String)!,
                                               artists: track["artists"] as! [String],
                                               coverArt: URL(string: track["coverArt"] as! String)!,
                                               albumName: track["albumName"] as! String))
                    }
                }
                print(newTracks)
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
            make.left.right.bottom.equalTo(view)
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
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
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

extension PlaylistViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}

extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableViewCell.reuseID, for: indexPath) as! PlaylistTableViewCell
        var artist = ""
        let album = "• "
        
        let url = searchTracks[indexPath.item].coverArt
        cell.albumArt.sd_setImage(with: url)
        
        cell.songLabel.text = searchTracks[indexPath.item].name
        cell.songLabel.font = UIFont(name:"Avenir", size:16)
        for name in searchTracks[indexPath.item].artists {
            artist += name
            artist += " "
        }
        cell.artistLabel.text = artist
        cell.artistLabel.font = UIFont(name:"Avenir", size:12)
        cell.albumLabel.text = album + searchTracks[indexPath.item].albumName
        cell.albumLabel.font = UIFont(name:"Avenir", size:12)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let crowdRef = self.ref.child("crowds").child("crowdID")
        let newSong = crowdRef.childByAutoId()
        let track = searchTracks[indexPath.row]
        newSong.setValue(["name": track.name, "uri": track.uri.absoluteString, "artists": track.artists, "coverArt": track.coverArt.absoluteString, "albumName": track.albumName])
    }
}
