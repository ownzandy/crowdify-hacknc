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

class EditorViewController: UIViewController {
    let rangeSlider = RangeSlider(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(rangeSlider)
        
        rangeSlider.addTarget(self, action: Selector("rangeSliderValueChanged:"), for: .valueChanged)
        
        //let time = DispatchTime.now().rawValue//dispatch_time(dispatch_time_t(DispatchTime.now().rawValue), Int64(NSEC_PER_SEC))
        //ispatch_after(time, DispatchQueue.main, {//dispatch_get_main_queue()) {
        DispatchQueue.main.async {
            self.rangeSlider.trackHighlightTintColor = UIColor.purple
            self.rangeSlider.curvaceousness = 1.0
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
    }
}
