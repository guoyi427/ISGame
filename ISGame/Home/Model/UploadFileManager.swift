//
//  UploadFileManager.swift
//  ISGame
//
//  Created by kokozu on 2017/4/28.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import Foundation
import Alamofire

class UploadFileManager: NSObject {
    static let instance = UploadFileManager()
    
    
    func updateFile(data:Data) {
        let urlString = "\(Host)/upload"
        
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(data, withName: "File", fileName: "demo.caf", mimeType: "audio/mpeg")
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
}
