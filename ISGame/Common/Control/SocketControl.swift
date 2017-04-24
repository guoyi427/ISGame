//
//  SocketControl.swift
//  ISGame
//
//  Created by kokozu on 2017/4/20.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import Foundation
import Starscream

let host = "wx://192.168.28.110:8282/chat"

class SocketControl {
    
    static let instance = SocketControl()
    fileprivate let _socket = WebSocket(url: URL(string:host)!, protocols: ["ISGame"])
    fileprivate var _uid:String
    
    init() {
        _uid = ""
        _socket.delegate = self
    }
    
    func connectHost() {
        if _socket.isConnected == false {
            _uid = UserControl.shared.getUid()
            _socket.connect()
        }
    }
    
    func sendTextMessage(text:String, to:String) {
        if _socket.isConnected == false || _uid == "" {
            return
        }
        let messageDic:[String: Any] = ["uid":_uid,
                          "message":text,
                          "to":to,
                          "code":1]
        
        
    }
}

extension SocketControl: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocket) {
        debugPrint("socket did connect")
        //  登陆消息
        if _uid == "" {
            debugPrint("uid is empty")
            return
        }
        let loginMessage:[String:Any] = ["code": 10, "message": "login", "uid": _uid]
        
        do {
            let messageData = try JSONSerialization.data(withJSONObject: loginMessage, options: .prettyPrinted)
            _socket.write(data: messageData, completion: { 
                debugPrint("login message send complete")
            })
        } catch {
            debugPrint(error)
        }
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        debugPrint("socket did disconnect \(String(describing: error?.localizedDescription))")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        debugPrint("socket did receive data \(data.count)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        debugPrint("socket did recive message \(text)")
    }
}
