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
        let loginScreen = UIImageView()
        view.addSubview(loginScreen)
        let loginString = "https://s13.postimg.org/55srmfeiv/home.png"
        let loginUrl = URL(string: loginString)
        loginScreen.sd_setImage(with: loginUrl)
        loginScreen.snp.makeConstraints { make in
            make.width.height.equalTo(view)
        }
        
        let button = UIButton()
        
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(60)
            make.centerX.equalTo(view)
            make.bottom.equalTo(loginScreen.snp.bottom).offset(-115)
        }
        
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    func login() {
        let loginURL = SPTAuth.loginURL(forClientId: "1e6187fb28dd41308bf132bec985eb76", withRedirectURL: URL(string: "crowdify-hacknc://callback"), scopes: [SPTAuthStreamingScope], responseType: "token")
        UIApplication.shared.open(loginURL!, options: [:], completionHandler: nil)
    }
    


}
