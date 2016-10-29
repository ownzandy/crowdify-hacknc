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
    var songDurationMS = 400000 // TODO: take in as argument
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config rangeSlider
        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueDidChange), for: .valueChanged)
        rangeSlider.setMinValue(0.0, maxValue: 1.0)
        rangeSlider.setLeftValue(0.2, rightValue: 0.7)
        rangeSlider.minimumDistance = 0.0
        view.addSubview(self.rangeSlider)
        
        startLabel.text = self.percentToTime(percentage: rangeSlider.leftValue, durationMS: self.songDurationMS)
        endLabel.text = self.percentToTime(percentage: rangeSlider.rightValue, durationMS: self.songDurationMS)
        view.addSubview(startLabel)
        view.addSubview(endLabel)
        
        startLabel.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.equalTo(rangeSlider.leftThumbView).offset(30)
            make.centerY.equalTo(rangeSlider).offset(-30)
        }
        
        endLabel.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.equalTo(rangeSlider.rightThumbView).offset(30)
            make.centerY.equalTo(rangeSlider).offset(30)
        }
    }
    
    func percentToTime(percentage: CGFloat, durationMS: Int) -> String {
        let totalMS = Int(Float(percentage) * Float(durationMS))
        let timeSec = totalMS / 1000
        let mins = timeSec / 60
        let secs = timeSec % 60
        let retval = String(mins) + ":" + ((secs<10) ? "0" : "") + String(secs)
        return retval
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x: margin, y: margin + topLayoutGuide.length,
                                   width: width, height: 31.0)
    }
    
    func rangeSliderValueDidChange(_ slider: MARKRangeSlider) {
        startLabel.text = self.percentToTime(percentage: slider.leftValue, durationMS: self.songDurationMS)
        endLabel.text = self.percentToTime(percentage: slider.rightValue, durationMS: self.songDurationMS)
    }
}
