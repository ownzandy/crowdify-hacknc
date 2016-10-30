//
//  EditorTableViewCell.swift
//  Crowdify
//
//  Created by Brian Lin on 10/29/16.
//  Copyright © 2016 Andy Wang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import MARKRangeSlider

class EditorTableViewCell: UITableViewCell {
    
    static let reuseID = "EditorTableViewCell"
    
    let rangeSlider = MARKRangeSlider(frame: CGRect.zero)
    let startLabel = UILabel(frame: CGRect.zero)
    let endLabel = UILabel(frame: CGRect.zero)
    var deviceName = UILabel()
    var deviceArt = UIImageView()
    var songDurationMS = 400000 // pass in
    
    
    var albumArt = UIImageView()
    var songLabel = UILabel()
    var artistLabel = UILabel()
    var albumLabel = UILabel()
    private let leftRightSpacing: CGFloat = 5
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(rangeSlider)
        addSubview(startLabel)
        addSubview(endLabel)
        //addSubview(deviceName)
        //albumArt.snp.makeConstraints { make in
        //    make.left.equalTo(self).offset(leftRightSpacing)
        //    make.top.equalTo(self)
        //}
        
        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueDidChange), for: .valueChanged)
        rangeSlider.setMinValue(0.0, maxValue: 1.0)
        rangeSlider.setLeftValue(0.0, rightValue: 1.0)
        rangeSlider.minimumDistance = 0.0
        let margin: CGFloat = 10.0
        rangeSlider.snp.makeConstraints { make in
            make.width.equalTo(self.bounds.width - 2.0 * margin)
            make.height.equalTo(51.0)
            make.centerX.equalTo(self.center.x+50) // TODO: find dynamically
            make.centerY.equalTo(self.center.y)
        }

        
        
        /*
        songLabel.snp.makeConstraints { make in
            make.left.equalTo(albumArt.snp.right).offset(leftRightSpacing)
            make.top.equalTo(self)
        }
        artistLabel.snp.makeConstraints { make in
            make.left.equalTo(albumArt.snp.right).offset(leftRightSpacing)
            make.bottom.equalTo(self)
        }
        albumLabel.snp.makeConstraints { make in
            make.left.equalTo(artistLabel.snp.right)
            make.bottom.equalTo(self)
        }*/
    }
    
    func rangeSliderValueDidChange(_ slider: MARKRangeSlider) {
        startLabel.text = self.percentToTime(percentage: slider.leftValue, durationMS: self.songDurationMS)
        endLabel.text = self.percentToTime(percentage: slider.rightValue, durationMS: self.songDurationMS)
    }
    
    func percentToTime(percentage: CGFloat, durationMS: Int) -> String {
        let totalMS = Int(Float(percentage) * Float(durationMS))
        let timeSec = totalMS / 1000
        let mins = timeSec / 60
        let secs = timeSec % 60
        let retval = String(mins) + ":" + ((secs<10) ? "0" : "") + String(secs)
        return retval
    }
    
}
