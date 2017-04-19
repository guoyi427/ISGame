//
//  WechatManager.swift
//  ISGame
//
//  Created by kokozu on 2017/4/18.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import Foundation

class WechatManager:NSObject,WXApiDelegate {
    static fileprivate let instance = WechatManager()
    
    static func shared() -> WechatManager {
        return instance
    }
    
    func login(viewController:UIViewController, compelete:()->Void) {
        
        WXApi.registerApp("wx65f71c2ea2b122da")
        let req:SendAuthReq = SendAuthReq()
        req.scope = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
        req.state = "guoyi is good"
        req.openID = "0c806938e2413ce73eef92cc3"
        WXApi.sendAuthReq(req, viewController: viewController, delegate: self)

    }
    
    func onReq(_ req: BaseReq!) {
        
    }
    
    func onResp(_ resp: BaseResp!) {
        if let authResp = resp as? SendAuthResp {
            //
            debugPrint(authResp)
        }
    }
    
}
