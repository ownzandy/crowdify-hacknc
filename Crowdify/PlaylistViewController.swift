//
//  PlaylistViewController.swift
//  Crowdify
//
//  Created by Andy Wang on 10/29/16.
//  Copyright © 2016 Andy Wang. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PlaylistViewController: UIViewController {
    
    var searchTracks: [Track] = []
    let searchController = UISearchController(searchResultsController: nil)
    let tableView = UITableView()
    let navBar = UINavigationBar()
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        self.ref.child("users").setValue(["username": "hi"])

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

extension PlaylistViewController: UITableViewDelegate {
    
    
}
