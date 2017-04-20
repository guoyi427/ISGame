//
//  LoginViewController.swift
//  ISGame
//
//  Created by 郭毅 on 2017/4/15.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import UIKit
import SnapKit
import Starscream

class LoginViewController: UIViewController {
    
    var socket:WebSocket?
    let messageLabel = UILabel(frame: CGRect(x: 10, y: 100, width: 300, height: 300))
    let uid = "2020"
    let to = "1010"
    let host = "ws://192.168.28.71:8282"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        messageLabel.numberOfLines = 0
        messageLabel.textColor = UIColor.blue
        messageLabel.text = ""
        view.addSubview(messageLabel)
        
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
        
        let sendButton = UIButton(type: .custom)
        sendButton.frame = CGRect(x: 10, y: 100, width: 100, height: 30)
        sendButton.backgroundColor = UIColor.yellow
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        view.addSubview(sendButton)

    }
}

//MARK: Button Action
extension LoginViewController {
    @objc fileprivate func wechatLoginButtonAction() {
//        WechatManager.shared().login(viewController: self) { 
//            
//        }
//        navigationController?.pushViewController(EditUserInfoViewController(), animated: true)
       
        if socket == nil {
            socket = WebSocket(url: URL(string: host)!)
            socket?.delegate = self
            socket?.connect()
        }
    }
    
    @objc fileprivate func sendMessage() {
        let message:[String:Any] = ["message":"郭毅是最帅的", "code":0, "uid":uid, "to":to]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
            socket?.write(data: jsonData)
        } catch {
            debugPrint(error)
        }
    }
}

extension LoginViewController:WebSocketDelegate {
    func websocketDidConnect(socket: WebSocket) {
        debugPrint("did connect \(socket)")
        let loginMessage:[String:Any] = ["uid":uid, "message":"login", "code":10]
        do {
            let jsonDic = try JSONSerialization.data(withJSONObject: loginMessage, options: .prettyPrinted)
            socket.write(data: jsonDic)
        } catch {
            debugPrint(error)
        }
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        debugPrint("did disconnect")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        debugPrint("receive message \(text)")
        let newText = messageLabel.text?.appending("\(text)\n")
        messageLabel.text = newText
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        debugPrint("recevie data \(data)")
    }
}

