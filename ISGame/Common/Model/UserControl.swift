//
//  UserControl.swift
//  ISGame
//
//  Created by kokozu on 2017/4/24.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import Foundation

class UserControl {
    static let shared = UserControl()
    
    fileprivate let _userDefaults:UserDefaults = UserDefaults.standard
    fileprivate let Key_token = "game_token"
    fileprivate let Key_uid = "game_uid"
    fileprivate var _uid:String
    fileprivate var _token:String
    
    init() {
        _uid = ""
        _token = ""
    }
    
    func save(token:String) {
        _userDefaults.set(token, forKey: Key_token)
        _token = token
    }
    
    func save(uid:String) {
        _userDefaults.set(uid, forKey: Key_uid)
        _uid = uid
    }
    
    func getToken() -> String {
        if _token == "" , let s_token = _userDefaults.object(forKey: Key_token) as? String {
            _token = s_token
        }
        return _token
    }
    
    func getUid() -> String {
        if _uid == "", let s_uid = _userDefaults.object(forKey: Key_uid) as? String {
            _uid = s_uid
        }
        return _uid
    }
    
    func clearup() {
        _token = ""
        _uid = ""
        _userDefaults.removeObject(forKey: Key_uid)
        _userDefaults.removeObject(forKey: Key_token)
    }
}
