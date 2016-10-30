//
//  PlaylistTableViewCell.swift
//  Crowdify
//
//  Created by David Yang on 10/29/16.
//  Copyright © 2016 Andy Wang. All rights reserved.
//

import UIKit
import SnapKit

class GroupLocationViewCell: UITableViewCell {
    
    let myColorUtils = ColorUtils()
    static let reuseID = "GroupLocationViewCell"
    var groupLabel = UILabel()
    private let leftRightSpacing: CGFloat = 5
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(groupLabel)
        self.backgroundColor = myColorUtils.hexStringToUIColor(hex: "161619")
        groupLabel.textColor = myColorUtils.hexStringToUIColor(hex: "d0ced5")
        groupLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
        }
    }
    
}
