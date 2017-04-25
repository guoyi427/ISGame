//
//  SocketUserModel.swift
//  ISGame
//
//  Created by kokozu on 2017/4/25.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import Foundation

class SocketUserModel {
    var name: String = ""
    var uid: String = ""
    
    init(json:[String:String]) {
        if let n_name = json["name"] {
            name = n_name
        }
        
        if let n_uid = json["uid"] {
            uid = n_uid
        }
    }
}
