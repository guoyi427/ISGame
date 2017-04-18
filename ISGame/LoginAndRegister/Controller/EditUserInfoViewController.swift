//
//  EditUserInfoViewController.swift
//  ISGame
//
//  Created by kokozu on 2017/4/18.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import UIKit

class EditUserInfoViewController: UIViewController {
    
    fileprivate let _headImageView = UIImageView(image: #imageLiteral(resourceName: "DefultHeadImage"))
    fileprivate let _nickNameLabel = UITextField()
    fileprivate let _genderManButton = UIButton(type: .custom)
    fileprivate let _genderWomanButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        _headImageView.isUserInteractionEnabled = true
        _headImageView.layer.cornerRadius = 75
        _headImageView.layer.masksToBounds = true
        view.addSubview(_headImageView)
        _headImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(50)
            make.size.equalTo(CGSize(width: 150, height: 150))
        }
        
        _nickNameLabel.placeholder = "请输入昵称"
        _nickNameLabel.font = UIFont.systemFont(ofSize: 15)
        _nickNameLabel.textColor = UIColor.csBlack()
        view.addSubview(_nickNameLabel)
        _nickNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(30)
            make.top.equalTo(_headImageView.snp.bottom).offset(30)
            make.right.equalTo(self.view).offset(30)
            make.height.equalTo(18)
        }
    }
}
