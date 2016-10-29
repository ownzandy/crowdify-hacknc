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
    var songDurationMS = 10000 // TODO: take in as argument

    /*
    let rangeSlider = RangeSlider(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Individual slider
        view.addSubview(rangeSlider)
        view.addSubview(startLabel)
        view.addSubview(endLabel)
        
        startLabel.text = "0"
        endLabel.text = "100"
        /*
        startLabel.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.equalTo(rangeSlider).offset(rangeSlider.lowerValue)
            make.centerY.equalTo(rangeSlider).offset(-15)
        }
        
        endLabel.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.equalTo(rangeSlider).offset(50)
            make.centerY.equalTo(rangeSlider).offset(-15)
        }
        */
        rangeSlider.addTarget(self, action: "rangeSliderValueChanged:", for: .valueChanged)
        /*
        //let time = DispatchTime.now().rawValue//dispatch_time(dispatch_time_t(DispatchTime.now().rawValue), Int64(NSEC_PER_SEC))
        //ispatch_after(time, DispatchQueue.main, {//dispatch_get_main_queue()) {
        DispatchQueue.main.async {
            self.rangeSlider.trackHighlightTintColor = UIColor.purple
            self.rangeSlider.curvaceousness = 1.0
            //self.startLabel.center.x = CGFloat(self.rangeSlider.lowerValue)
        }
 */
    }
 
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueDidChange), for: .valueChanged)
        rangeSlider.setMinValue(0.0, maxValue: 1.0)
        rangeSlider.setLeftValue(0.2, rightValue: 0.7)
        rangeSlider.minimumDistance = 0.2
        view.addSubview(self.rangeSlider)
        
        startLabel.text = rangeSlider.leftValue.description
        endLabel.text = rangeSlider.rightValue.description
        
        view.addSubview(startLabel)
        view.addSubview(endLabel)
        
        startLabel.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.equalTo(rangeSlider.leftThumbView)
            make.centerY.equalTo(rangeSlider).offset(-20)
        }
        
        endLabel.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.equalTo(rangeSlider.rightThumbView)
            make.centerY.equalTo(rangeSlider).offset(30)
        }
 
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x: margin, y: margin + topLayoutGuide.length,
                                   width: width, height: 31.0)
    }
    
    func rangeSliderValueDidChange(_ slider: MARKRangeSlider) {
        print(String(format: "%0.2f - %0.2f", slider.leftValue, slider.rightValue))
    
        //startLabel.center.x = CGFloat(slider)
        //startLabel.center.x = CGFloat(slider.leftValue * 100)
        startLabel.text = slider.leftValue.description
        endLabel.text = slider.rightValue.description
    }
}
