//
//  HomeViewController.swift
//  ISGame
//
//  Created by 郭毅 on 2017/4/15.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.magenta
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 10, y: 100, width: 100, height: 40)
        button.backgroundColor = UIColor.yellow
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
        
        //  判断是否登陆了
        _judgeLogin()
        
        SocketControl.instance.connectHost()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    fileprivate func _judgeLogin() {
        if UserControl.shared.getUid() == "" {
            let loginVC = LoginViewController()
            let navi = UINavigationController(rootViewController: loginVC)
            loginVC.navigationController?.setNavigationBarHidden(true, animated: false)
            self.present(navi, animated: true, completion: nil)
        }
    }
    
}

//MARK: Button Action
extension HomeViewController {
    func buttonAction() {
        let imageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "demo"))
        let urlString = "http://localhost:8080/upload"
        
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(imageData!, withName: "File", fileName: "demo.png", mimeType: "image/png")
        }, to: urlString) { (encodingResult) in
            switch encodingResult {
            case .failure(let error):
                debugPrint(error)
            case .success(request: let uploadRequest, streamingFromDisk: _, streamFileURL: _):
                uploadRequest.responseJSON(completionHandler: { (json) in
                    if let n_value = json.value {
                        debugPrint(n_value)
                    }
                })
            }
        }
    }
    
    func sendMessage() {
        SocketControl.instance.sendTextMessage(text: "嗯嗯", to: "999")
    }
}
