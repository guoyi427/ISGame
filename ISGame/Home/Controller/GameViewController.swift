//
//  GameViewController.swift
//  ISGame
//
//  Created by kokozu on 2017/4/26.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    let _textField = UITextField(frame: CGRect(x: 10, y: 80, width: 200, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        _textField.placeholder = "输入内容"
        view.addSubview(_textField)
        
        let sendButton = UIButton(type: .custom)
        sendButton.frame = CGRect(x: 100, y: 80, width: 50, height: 30)
        sendButton.setTitle("send", for: .normal)
        sendButton.backgroundColor = UIColor.green
        sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        view.addSubview(sendButton)
        
        
    }
}

extension GameViewController {
    @objc fileprivate func sendButtonAction() {
        
    }
}
