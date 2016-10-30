//
//  PlaylistTableViewCell.swift
//  Crowdify
//
//  Created by David Yang on 10/29/16.
//  Copyright © 2016 Andy Wang. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {
    
    static let reuseID = "PlaylistTableViewCell"
    var albumArt = UIImageView()
    var songLabel = UILabel()
    var artistAlbumLabel = UILabel()
    private let leftRightSpacing: CGFloat = 10
    private let songTopSpacing: CGFloat = 15
    private let topBottomSpacing: CGFloat = 5
    private let offset: CGFloat = 90
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        addSubview(albumArt)
        addSubview(songLabel)
        addSubview(artistAlbumLabel)
        albumArt.snp.makeConstraints { make in
            make.left.equalTo(self).offset(leftRightSpacing)
            make.top.equalTo(self).offset(topBottomSpacing)
        }
        songLabel.snp.makeConstraints { make in
            make.left.equalTo(albumArt.snp.right).offset(leftRightSpacing)
            make.top.equalTo(self).offset(songTopSpacing)
            make.width.equalTo(UIScreen.main.bounds.width - offset)
        }
        artistAlbumLabel.snp.makeConstraints { make in
            make.left.equalTo(albumArt.snp.right).offset(leftRightSpacing)
            make.top.equalTo(songLabel.snp.bottom).offset(topBottomSpacing)
            make.width.equalTo(UIScreen.main.bounds.width - offset)
        }
    }

}
