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

let startLabel = UILabel(frame: CGRect.zero)
let endLabel = UILabel(frame: CGRect.init(origin: CGPoint.init(x: 20, y:20), size: CGSize.init(width: 10, height: 10)))

class EditorViewController: UIViewController {
    let rangeSlider = RangeSlider(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Individual slider
        view.addSubview(rangeSlider)
        view.addSubview(startLabel)
        view.addSubview(endLabel)
        
        startLabel.text = "0"
        endLabel.text = "100"
        
        startLabel.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            //make.centerX.centerY.equalTo(view)
            //make.centerX.equalTo(view)
            make.centerX.equalTo(rangeSlider).offset(rangeSlider.lowerValue)
            make.centerY.equalTo(rangeSlider).offset(-15)
        }
        
        endLabel.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            //make.centerX.centerY.equalTo(view)
            make.centerX.equalTo(rangeSlider).offset(-50)
            make.centerY.equalTo(rangeSlider).offset(-15)
        }
        
        rangeSlider.addTarget(self, action: Selector("rangeSliderValueChanged:"), for: .valueChanged)
        
        //let time = DispatchTime.now().rawValue//dispatch_time(dispatch_time_t(DispatchTime.now().rawValue), Int64(NSEC_PER_SEC))
        //ispatch_after(time, DispatchQueue.main, {//dispatch_get_main_queue()) {
        DispatchQueue.main.async {
            self.rangeSlider.trackHighlightTintColor = UIColor.purple
            self.rangeSlider.curvaceousness = 1.0
            //self.startLabel.center.x = CGFloat(self.rangeSlider.lowerValue)
        }
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x: margin, y: margin + topLayoutGuide.length,
                                   width: width, height: 31.0)
    }
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
        
        startLabel.center.x = CGFloat(rangeSlider.lowerValue)
        startLabel.center.y = CGFloat(rangeSlider.upperValue)
    }
}
