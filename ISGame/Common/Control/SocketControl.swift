//
//  SocketControl.swift
//  ISGame
//
//  Created by kokozu on 2017/4/20.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import Foundation
import Starscream

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
    weak var reciveGroupDelegate:SocketControlReceiveGroup?
    
    fileprivate let _socket = WebSocket(url: URL(string:Socket_Host)!, protocols: ["ISGame"])
    fileprivate var _uid:String = ""
    fileprivate var _name:String = ""
    
    /// 查询在线用户成功回调
    fileprivate var _queryUserListCallback:(([SocketUserModel])->Void)?
    fileprivate var _creatroomCallback:(([String:Any])->Void)?
    fileprivate var _queryRoomListCallback:(([[String:Any]])->Void)?
    fileprivate var _queryInRoomCallback:(([String:Any])->Void)?
    
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
        let dic:[String:Any] = ["code": SocketCode.Login.rawValue,
                                         "message": "login"]
        
        _sendData(jsonDic: dic)
    }
    
    /// 普通消息
    func sendTextMessage(text:String, to:String) {
        if _socket.isConnected == false || _uid == "" {
            return
        }
        let dic:[String: Any] = ["message":text,
                                        "to":to,
                                        "code":SocketCode.Chat.rawValue]
        _sendData(jsonDic: dic)
    }
    
    /// 查询用户列表消息
    func queryUserList(complete:@escaping ([SocketUserModel])->Void) {
        let messageDic:[String:Any] = ["code":SocketCode.QueryUserList.rawValue]
        _queryUserListCallback = complete
        
        _sendData(jsonDic: messageDic)
    }
}

//MARK: Room Methods
extension SocketControl {
    
    /// 创建房间
    func creatRoom(complete:@escaping ([String:Any])->Void) {
        _creatroomCallback = complete
        let dic = ["code":SocketCode.CreatRoom.rawValue]
        _sendData(jsonDic: dic)
    }

    /// 加入房间
    func inRoom(roomID:String, complete:@escaping ([String:Any])->Void) {
        _queryInRoomCallback = complete
        let dic:[String:Any] = ["code":SocketCode.InRoom.rawValue, "room_id":roomID]
        _sendData(jsonDic: dic)
    }
    
    /// 退出房间
    func outRoom(roomID:String) {
        let dic:[String:Any] = ["code":SocketCode.OutRoom.rawValue, "room_id":roomID]
        _sendData(jsonDic: dic)
    }
    
    /// 查询房间列表
    func queryRoomList(complete:@escaping ([[String:Any]])->Void) {
        _queryRoomListCallback = complete
        let dic = ["code":SocketCode.QueryRoomList.rawValue]
        _sendData(jsonDic: dic)
    }
    
    /// 发送群消息
    func sendGroupMessage(msg:String, roomID:String) {
        let messageDic = ["type":"text", "content": msg]
        let dic:[String:Any] = ["code":SocketCode.Group.rawValue,
                                "message":messageDic,
                                "room_id":roomID]
        _sendData(jsonDic: dic)
    }
}

//MARK: Private Methods
extension SocketControl {
    /// 统一处理发送信息， 加上默认字段
    fileprivate func _sendData(jsonDic:[String:Any]) {
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
    
    /// 统一处理接受消息
    fileprivate func _receiveData(jsonDic:[String:Any]) {
        if let codeInt = jsonDic["code"] as? Int, let code = SocketCode.init(rawValue: codeInt)  {
            switch code {
            case .QueryUserList:
                _analysisUserList(jsonDic: jsonDic)
                break
            case .Chat:
                break
            case .Group:
                if let messageDic = jsonDic["message"] as? [String:Any], let g_delegate = reciveGroupDelegate {
                    g_delegate.socketControlReceiveGroupMessage(messageDic: messageDic)
                }
                break
            case .CreatRoom:
                if let n_complete = _creatroomCallback {
                    n_complete(jsonDic)
                }
                break
            case .InRoom:
                if let n_complete = _queryInRoomCallback {
                    n_complete(jsonDic)
                }
                break
            case .OutRoom:
                break
            case .QueryRoomList:
                _analysisQueryRoomList(jsonDic: jsonDic)
                break
                
            default:
                break
            }
        } else {
            //  无code
            
        }
    }
    
    fileprivate func _analysisUserList(jsonDic:[String:Any]) {
        if let userList = jsonDic["message"] as? [[String:String]] {
            var userModelList:[SocketUserModel] = []
            for userDic in userList {
                let userModel = SocketUserModel(json: userDic)
                userModelList.append(userModel)
            }
            
            if let complete = _queryUserListCallback {
                complete(userModelList)
            }
        }
    }
    
    fileprivate func _analysisQueryRoomList(jsonDic:[String:Any]) {
        guard let roomList = jsonDic["message"] as? [[String:Any]] else {
            debugPrint("query room list error")
            return
        }
        if let complete = _queryRoomListCallback {
            complete(roomList)
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
            
            if let n_json = jsonDic as? [String:Any] {
                _receiveData(jsonDic: n_json)
            }
            
        } catch {
            debugPrint(error)
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        debugPrint("socket did recive message \(text)")
    }
}

protocol SocketControlReceiveGroup: class {
    func socketControlReceiveGroupMessage(messageDic:[String:Any])
}
