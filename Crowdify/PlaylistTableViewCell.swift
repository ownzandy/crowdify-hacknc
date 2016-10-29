//
//  PlaylistTableViewCell.swift
//  Crowdify
//
//  Created by David Yang on 10/29/16.
//  Copyright © 2016 Andy Wang. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {
    
    static let reuseID = String(describing: self)
    var songLabel = UILabel()
    var artistLabel = UILabel()
    var albumLabel = UILabel()
    private let leftRightSpacing: CGFloat = 3
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        addSubview(songLabel)
        addSubview(artistLabel)
        addSubview(albumLabel)
        songLabel.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.top.equalTo(self)
        }
        artistLabel.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.bottom.equalTo(self)
        }
        albumLabel.snp.makeConstraints { make in
            make.left.equalTo(artistLabel.snp.right).offset(leftRightSpacing)
            make.bottom.equalTo(self)
        }
    }

}
