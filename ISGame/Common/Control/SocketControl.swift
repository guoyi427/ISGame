//
//  SocketControl.swift
//  ISGame
//
//  Created by kokozu on 2017/4/20.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import Foundation
import Starscream

let host = "wx://192.168.28.71:8282"

class SocketControl {
    
    static let instance = SocketControl()
    fileprivate let _socket = WebSocket(url: URL(string:host)!, protocols: ["ISGame"])
    fileprivate var _uid:String?
    
    init() {
        _socket.delegate = self
    }
    
    func connectHost(uid:String) {
        if _socket.isConnected == false {
            _uid = uid
            _socket.connect()
        }
    }
    
    func sendTextMessage(text:String) {
        
    }
}

extension SocketControl: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocket) {
        debugPrint("socket did connect")
        //  登陆消息
        guard let uid = _uid else {
            debugPrint("uid is empty")
            return
        }
        let loginMessage:[String:Any] = ["code": 10, "message": "login", "uid": uid]
        
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
