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

class EditorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rangeSlider = MARKRangeSlider(frame: CGRect.zero)
        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueDidChange), for: .valueChanged)
        rangeSlider.setMinValue(0.0, maxValue: 1.0)
        rangeSlider.setLeftValue(0.2, rightValue: 0.7)
        rangeSlider.minimumDistance = 0.2
        view.addSubview(rangeSlider)

    }
    
    func rangeSliderValueDidChange(_ slider: MARKRangeSlider) {
        print(String(format: "%0.2f - %0.2f", slider.leftValue, slider.rightValue))
    }
    
    override func viewDidLayoutSubviews() {
        <#code#>
    }
    
}
