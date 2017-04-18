//
//  LoginViewController.swift
//  ISGame
//
//  Created by 郭毅 on 2017/4/15.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let wechatLoginButton = UIButton(type: .custom)
        wechatLoginButton.setTitle("微信登陆", for: .normal)
        wechatLoginButton.addTarget(self, action: #selector(wechatLoginButtonAction), for: .touchUpInside)
        view.addSubview(wechatLoginButton)
    }
}

//MARK: Button Action
extension LoginViewController {
    @objc fileprivate func wechatLoginButtonAction() {
    
    }
}
