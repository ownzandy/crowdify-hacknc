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
    var songDurationMS = 400000 // pass in
    
    var albumArt = UIImageView()
    var songLabel = UILabel()
    var artistLabel = UILabel()
    var albumLabel = UILabel()
    private let leftRightSpacing: CGFloat = 5
    
    let myColorUtils = ColorUtils()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.backgroundColor = myColorUtils.hexStringToUIColor(hex: "161619")
        addSubview(rangeSlider)
        addSubview(albumArt)
        //addSubview(startLabel)
        //addSubview(endLabel)
        //addSubview(deviceName)
        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueDidChange), for: .valueChanged)
        rangeSlider.setMinValue(0.0, maxValue: 1.0)
        rangeSlider.setLeftValue(0.0, rightValue: 1.0)
        rangeSlider.minimumDistance = 0.0
        let temp = rangeSlider.leftThumbImage
        let newWidth = (temp?.size.width)! / 2
        let newHeight = (temp?.size.height)! / 2
        let size = CGSize(width: newWidth, height: newHeight)

        /*UIGraphicsBeginImageContext(size)
        temp?.draw(in: CGRect(x: rangeSlider.leftThumbView.center.x, y: rangeSlider.leftThumbView.center.y, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        rangeSlider.leftThumbImage = newImage
        */
        let margin: CGFloat = 10.0
        rangeSlider.snp.makeConstraints { make in
            make.width.equalTo(self.bounds.width - 2.0 * margin)
            make.height.equalTo(51.0)
            make.centerX.equalTo(self.center.x+30) // TODO: find dynamically
            make.centerY.equalTo(self.center.y)
        }
        
        albumArt.snp.makeConstraints { make in
            make.left.equalTo(self).offset(leftRightSpacing)
            make.top.equalTo(self)
        }
        
        /*
        startLabel.text = self.percentToTime(percentage: rangeSlider.leftValue, durationMS: self.songDurationMS)
        endLabel.text = self.percentToTime(percentage: rangeSlider.rightValue, durationMS: self.songDurationMS)
        startLabel.font = UIFont(name:"HelveticaNeue", size: 12.0)
        startLabel.textColor = UIColor.lightGray
        endLabel.font = UIFont(name:"HelveticaNeue", size: 12.0)
        endLabel.textColor = UIColor.lightGray

        startLabel.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.equalTo(rangeSlider.leftThumbView).offset(30)
            make.centerY.equalTo(rangeSlider).offset(-10)
        }
        
        endLabel.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.equalTo(rangeSlider.rightThumbView).offset(30)
            make.centerY.equalTo(rangeSlider).offset(25)
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
