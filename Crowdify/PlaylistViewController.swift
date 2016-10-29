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
    
    var searchTracks: [Track] = []
    let searchController = UISearchController(searchResultsController: nil)
    let tableView = UITableView()
    let navBar = UINavigationBar()
    var ref = FIRDatabase.database().reference()
    var searchActive: Bool = false
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75.0;//Choose your custom row height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableViewCell.reuseID, for: indexPath) as! PlaylistTableViewCell
        cell.backgroundColor = UIColor .gray
        var artist = ""
        let album = "• "
        
        let url = searchTracks[indexPath.item].coverArt
        cell.albumArt.sd_setImage(with: url)
        
        cell.songLabel.text = searchTracks[indexPath.item].name
        cell.songLabel.font = UIFont(name:"Avenir", size:16)
        cell.songLabel.textColor = UIColor .white
        for name in searchTracks[indexPath.item].artists {
            artist += name
            artist += " "
        }
        cell.artistAlbumLabel.text = artist + album + searchTracks[indexPath.item].albumName
        cell.artistAlbumLabel.font = UIFont(name:"Avenir", size:12)
        cell.artistAlbumLabel.textColor = UIColor .white
        return cell
    }
    
}
