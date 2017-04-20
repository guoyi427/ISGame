//
//  LoginViewController.swift
//  ISGame
//
//  Created by 郭毅 on 2017/4/15.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let wechatLoginButton = UIButton(type: .custom)
        wechatLoginButton.backgroundColor = UIColor.green
        wechatLoginButton.setTitle("微信登陆", for: .normal)
        wechatLoginButton.addTarget(self, action: #selector(wechatLoginButtonAction), for: .touchUpInside)
        view.addSubview(wechatLoginButton)
        wechatLoginButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-40)
            make.height.equalTo(40)
        }
    }
}

//MARK: Button Action
extension LoginViewController {
    @objc fileprivate func wechatLoginButtonAction() {
        SocketControl.instance.connectHost(uid: "1")
        
    }
}
