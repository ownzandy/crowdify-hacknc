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

class PlaylistViewController: UIViewController {
    
    var searchTracks: [Track] = []
    let searchController = UISearchController(searchResultsController: nil)
    let tableView = UITableView()
    let navBar = UINavigationBar()
    var ref = FIRDatabase.database().reference()
    let searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
//        let crowdRef = self.ref.child("crowds").child("crowdID")
//        let newSong = crowdRef.childByAutoId()
//        newSong.setValue(["hi": "bye", "dude": "true"])
//        
//        
//        let refHandle = usersRef.observe(FIRDataEventType.value, with: { (snapshot) in
//            let postDict = snapshot.value as! [String : AnyObject]
//            print(postDict)
//        })

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
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func filterContentForSearchText(searchText: String) {
        let accessToken = UserDefaults.standard.object(forKey: "token") as! String
        SPTSearch.perform(withQuery: searchText, queryType: SPTSearchQueryType.queryTypeTrack, offset: 0, accessToken: accessToken, market: nil, callback: { error, result -> Void in
            let list = result as? SPTListPage
            if let items = list?.items as? [SPTPartialTrack] {
                let tracks: [Track] = items.map { track in
                    let artists: [String] = track.artists.map { artist in
                        let artistObject = artist as? SPTPartialArtist
                        return artistObject!.name!
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
        
        let url = searchTracks[indexPath.item].coverArt
        cell.albumArt.sd_setImage(with: url)
        
        cell.songLabel.text = searchTracks[indexPath.item].name
        for name in searchTracks[indexPath.item].artists {
            artist += name
            artist += " "
        }
        cell.artistLabel.text = artist
        cell.albumLabel.text = searchTracks[indexPath.item].albumName
        return cell
    }
    
    
}
