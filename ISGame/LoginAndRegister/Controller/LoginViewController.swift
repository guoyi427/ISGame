//
//  LoginViewController.swift
//  ISGame
//
//  Created by 郭毅 on 2017/4/15.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

let Host = "192.168.28.110"
class LoginViewController: UIViewController {
    
    var _wx_id = ""
    var _name = ""
    let _wx_id_textFieldTag = 100
    let _name_textFieldTag = 101
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let wx_id_textfield = UITextField(frame: CGRect(x: 10, y: 60, width: 300, height: 30))
        wx_id_textfield.textColor = UIColor.black
        wx_id_textfield.placeholder = "填写唯一标示或手机号"
        wx_id_textfield.delegate = self
        wx_id_textfield.tag = _wx_id_textFieldTag
        view.addSubview(wx_id_textfield)
        
        let name_textField = UITextField(frame: CGRect(x: 10, y: 100, width: 300, height: 30))
        name_textField.textColor = UIColor.black
        name_textField.placeholder = "第一次登陆，请输入昵称"
        name_textField.delegate = self
        name_textField.tag = _name_textFieldTag
        view.addSubview(name_textField)
        
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
        let para = ["wx_id":_wx_id,
                    "name":_name]
        let url = "http://\(Host):8080/wx_login"
        Alamofire.request(url, method: .get, parameters:para).responseJSON { [unowned self](response) in
            switch response.result {
            case .success(let result):
                if let resultDic = result as? [String: Any] {
                    debugPrint("login response = \(resultDic)")
                    if let s_token = resultDic["token"] as? String, let s_uid = resultDic["uid"] as? String {
                        UserControl.shared.save(token: s_token)
                        UserControl.shared.save(uid: s_uid)
                    }
                    self.dismiss(animated: true, completion: nil)
                }
                break
            case .failure(let error):
                debugPrint(error)
                break
            }
        }
        
    }
}

//MARK: TextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if let content = textField.text {
            if textField.tag == _wx_id_textFieldTag {
                _wx_id = content
            } else {
                _name = content
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
