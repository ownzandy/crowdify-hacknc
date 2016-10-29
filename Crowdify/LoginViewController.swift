//
//  LoginViewController.swift
//  Crowdify
//
//  Created by Andy Wang on 10/29/16.
//  Copyright © 2016 Andy Wang. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        view.addSubview(button)
        button.backgroundColor = UIColor.blue
        button.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.centerY.equalTo(view)
        }
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    func login() {
        let loginURL = SPTAuth.loginURL(forClientId: "1e6187fb28dd41308bf132bec985eb76", withRedirectURL: URL(string: "crowdify-hacknc://callback"), scopes: [SPTAuthStreamingScope], responseType: "token")
        UIApplication.shared.open(loginURL!, options: [:], completionHandler: nil)
    }
    


}
