//
//  WechatManager.swift
//  ISGame
//
//  Created by kokozu on 2017/4/18.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import Foundation
import WatchKit

class WechatManager:NSObject {
    static fileprivate let instance = WechatManager()

    
    static func shared() -> WechatManager {
        return instance
    }
    
    func login(viewController:UIViewController, compelete:()->Void) {
        
    }
}
