//
//  EditorViewController.swift
//  Crowdify
//
//  Created by Brian Lin on 10/29/16.
//  Copyright © 2016 Andy Wang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import MARKRangeSlider

let startLabel = UILabel(frame: CGRect.zero)
let endLabel = UILabel(frame: CGRect.zero)//init(origin: CGPoint.init(x: 20, y:20), size: CGSize.init(width: 10, height: 10)))

class EditorViewController: UIViewController {
    let rangeSlider = MARKRangeSlider(frame: CGRect.zero)
    
    // Placeholder values
    let deviceIDs = ["deviceZero", "deviceOne", "deviceTwo", "deviceThree", "deviceFour"]
    
    var songDurationMS = 400000 // TODO: take in as argument
    let songImage = "cat.jpg"
    let songTitle = "Shelter"
    let songArtists = ["Porter Robinson", "Madeon"]
    
    // Table stuff
    let tableView = UITableView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSongImage(imageName: self.songImage)
        self.addSongTitle(text: self.songTitle)
        self.addSongArtists(artists: self.songArtists)
        self.addTableView()
    }
    
    func addTableView(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view.center.y).offset(250)
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EditorTableViewCell.self, forCellReuseIdentifier: EditorTableViewCell.reuseID)
    }
    
    func addSongArtists(artists: [String]) {
        let artist = UILabel(frame: CGRect.zero)
        artist.text = artists.joined(separator: ", ")
        artist.font = UIFont(name:"HelveticaNeue", size: 16.0)
        artist.textColor = UIColor.gray
        view.addSubview(artist)
        artist.snp.makeConstraints { make in
            make.centerX.equalTo(view.center.x)
            make.centerY.equalTo(view.center.y).offset(200)
        }
    }
    
    func addSongTitle(text: String) {
        let title = UILabel(frame: CGRect.zero)
        title.text = text
        title.font = UIFont(name:"HelveticaNeue", size: 18.0)
        view.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerX.equalTo(view.center.x)
            make.centerY.equalTo(view.center.y).offset(180)
        }
    }
    
    func addSongImage(imageName: String) {
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.layer.borderWidth = 2.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 50.0 // TODO: get this value dynamically
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.top.equalTo(view).offset(50)
            make.centerX.equalTo(view)
        }
        view.addSubview(imageView)
    }
    
    func percentToTime(percentage: CGFloat, durationMS: Int) -> String {
        let totalMS = Int(Float(percentage) * Float(durationMS))
        let timeSec = totalMS / 1000
        let mins = timeSec / 60
        let secs = timeSec % 60
        let retval = String(mins) + ":" + ((secs<10) ? "0" : "") + String(secs)
        return retval
    }
    
    /*
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x: margin, y: view.center.y,
                                   width: width, height: 31.0)
    }*/
    
    func rangeSliderValueDidChange(_ slider: MARKRangeSlider) {
        startLabel.text = self.percentToTime(percentage: slider.leftValue, durationMS: self.songDurationMS)
        endLabel.text = self.percentToTime(percentage: slider.rightValue, durationMS: self.songDurationMS)
    }
    
}

extension EditorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditorTableViewCell.reuseID, for: indexPath) as! EditorTableViewCell
        
        //var artist = ""
        
        //let url = searchTracks[indexPath.item].coverArt
        //cell.albumArt.sd_setImage(with: url)
        
        //cell.songLabel.text = searchTracks[indexPath.item].name
        //for name in searchTracks[indexPath.item].artists {
        //    artist += name
        //    artist += " "
        //}
        //cell.artistLabel.text = artist
        //cell.albumLabel.text = searchTracks[indexPath.item].albumName
        return cell
    }
}
