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
        self.addButtons()
    }
    
    func addButtons() {
        let cancel = UIButton()
        let save = UIButton()
        view.addSubview(cancel)
        view.addSubview(save)
        let myColorUtils = ColorUtils()
        
        cancel.layer.borderColor = myColorUtils.hexStringToUIColor(hex: "d0ced5").cgColor
        cancel.layer.borderWidth = 2.0
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(myColorUtils.hexStringToUIColor(hex: "d0ced5"), for: .normal)
        cancel.layer.cornerRadius = 15.0
        cancel.snp.makeConstraints { make in
            make.width.equalTo(100.0)
            make.height.equalTo(30.0)
            make.centerX.equalTo(view.center.x).offset(80)
            make.bottom.equalTo(view).offset(-20)
        }
        cancel.addTarget(self, action: #selector(self.cancelButtonPressed), for: .touchUpInside)
        
        save.layer.borderColor = myColorUtils.hexStringToUIColor(hex: "dc3a79").cgColor
        save.layer.borderWidth = 2.0
        save.setTitle("Save", for: .normal)
        save.setTitleColor(myColorUtils.hexStringToUIColor(hex: "dc3a79"), for: .normal)
        save.layer.cornerRadius = 15.0
        save.snp.makeConstraints { make in
            make.width.equalTo(100.0)
            make.height.equalTo(30.0)
            make.centerX.equalTo(view.center.x).offset(300)
            make.bottom.equalTo(view).offset(-20)
        }
        save.addTarget(self, action: #selector(self.saveButtonPressed), for: .touchUpInside)
    }
    
    func saveButtonPressed() {
        print("Save button pressed!")
    }
    
    func cancelButtonPressed() {
        print("Cancel button pressed!")
    }
    
    func addTableView() {
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
}

extension EditorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditorTableViewCell.reuseID, for: indexPath) as! EditorTableViewCell        
        return cell
    }
}
