//
//  SocketControl.swift
//  ISGame
//
//  Created by kokozu on 2017/4/20.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import Foundation
import Starscream

let Socket_Host = "wx://192.168.36.66:8282/chat"

/*
 code
 */
enum SocketCode:Int {
    case Login      = 10
    case Logout
    
    case Chat       = 100
    case Group
    case System
    
    case CreatRoom  = 200
    case InRoom
    case OutRoom
    case QueryRoomList

    case QueryUserList = 300
}

class SocketControl {
    
    static let instance = SocketControl()
    fileprivate let _socket = WebSocket(url: URL(string:Socket_Host)!, protocols: ["ISGame"])
    fileprivate var _uid:String = ""
    fileprivate var _name:String = ""
    
    /// 查询在线用户成功回调
    fileprivate var _queryUserListCallback:(([SocketUserModel])->Void)?
    
    
    init() {
        _socket.delegate = self
    }
    
    /// 连接主机
    func connectHost() {
        _uid = UserControl.shared.getUid()
        _name = UserControl.shared.getName()
        
        if _uid == "" {
            debugPrint("uid empty can't connect socket")
            return
        }
        if _socket.isConnected == false {
            _socket.connect()
        } else {
            sendLoginMessage()
        }
    }
    
    /// 登陆消息
    func sendLoginMessage() {
        //  登陆消息
        if _uid == "" {
            debugPrint("uid is empty")
            return
        }
        let loginMessage:[String:Any] = ["code": SocketCode.Login.rawValue,
                                         "message": "login"]
        
        sendData(jsonDic: loginMessage)
    }
    
    /// 普通消息
    func sendTextMessage(text:String, to:String) {
        if _socket.isConnected == false || _uid == "" {
            return
        }
        let messageDic:[String: Any] = ["message":text,
                                        "to":to,
                                        "code":SocketCode.Chat.rawValue]
        sendData(jsonDic: messageDic)
    }
    
    /// 查询用户列表消息
    func queryUserList(complete:@escaping ([SocketUserModel])->Void) {
        let messageDic:[String:Any] = ["code":SocketCode.QueryUserList.rawValue]
        _queryUserListCallback = complete
        
        sendData(jsonDic: messageDic)
    }
}

//MARK: Room Methods
extension SocketControl {
    
    /// 创建房间
    func creatRoom() {
        let messageDic = ["code":SocketCode.CreatRoom.rawValue]
        sendData(jsonDic: messageDic)
    }

    /// 加入房间
    func inRoom(roomID:String) {
        let messageDic:[String:Any] = ["code":SocketCode.InRoom.rawValue, "room_id":roomID]
        sendData(jsonDic: messageDic)
    }
    
    /// 查询房间列表
    func queryRoomList() {
        let messageDic = ["code":SocketCode.QueryRoomList.rawValue]
        sendData(jsonDic: messageDic)
    }
}

//MARK: Private Methods
extension SocketControl {
    /// 统一处理发送信息， 加上默认字段
    fileprivate func sendData(jsonDic:[String:Any]) {
        do {
            var result = jsonDic
            result.updateValue(_uid, forKey: "uid")
            result.updateValue(_name, forKey: "name")
            
            let messageData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
            _socket.write(data: messageData, completion: {
                debugPrint("message send complete")
            })
        } catch {
            debugPrint(error)
        }

    }
}

//MARK: Delegate
extension SocketControl: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocket) {
        debugPrint("socket did connect")
        sendLoginMessage()
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        debugPrint("socket did disconnect \(String(describing: error?.localizedDescription))")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        debugPrint("socket did receive data \(data.count)")
        do {
            let jsonDic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            debugPrint(jsonDic)
            if let n_jsonDic = jsonDic as? [String:Any], let userList = n_jsonDic["userList"] as? [[String:String]] {
                var userModelList:[SocketUserModel] = []
                for userDic in userList {
                    let userModel = SocketUserModel(json: userDic)
                    userModelList.append(userModel)
                }
                
                if let complete = _queryUserListCallback {
                    complete(userModelList)
                }
            }
            
        } catch {
            debugPrint(error)
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        debugPrint("socket did recive message \(text)")
    }
}
