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
    fileprivate let Key_name = "game_name"
    fileprivate var _uid:String = ""
    fileprivate var _token:String = ""
    fileprivate var _name:String = ""
    
    init() {

    }
    
    func save(token:String) {
        _userDefaults.set(token, forKey: Key_token)
        _token = token
    }
    
    func save(uid:String) {
        _userDefaults.set(uid, forKey: Key_uid)
        _uid = uid
    }
    
    func save(name: String) {
        _userDefaults.set(name, forKey: Key_name)
        _name = name
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
    
    func getName() -> String {
        if _name == "", let s_name = _userDefaults.object(forKey: Key_name) as? String {
            _name = s_name
        }
        return _name
    }
    
    func clearup() {
        _token = ""
        _uid = ""
        _name = ""
        _userDefaults.removeObject(forKey: Key_uid)
        _userDefaults.removeObject(forKey: Key_token)
        _userDefaults.removeObject(forKey: Key_name)
    }
}
