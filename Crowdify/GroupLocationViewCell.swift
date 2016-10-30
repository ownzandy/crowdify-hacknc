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
        groupLabel.snp.makeConstraints { make in
            make.left.equalTo(leftRightSpacing)
            make.top.equalTo(self)
        }
    }
    
}
