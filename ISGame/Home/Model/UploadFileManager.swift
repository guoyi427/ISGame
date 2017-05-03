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
    var uploadCompleteClosure:(([String:Any])->Void)?
    
    func updateFile(data:Data, fileName:String) -> UploadFileManager {
        let urlString = "\(Host)/upload"
        
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(data, withName: "File", fileName: fileName, mimeType: "audio/x-caf")
        }, to: urlString, method: .post) { (encodingResult) in
            switch encodingResult {
            case .failure(let error):
                debugPrint(error)
            case .success(request: let uploadRequest, streamingFromDisk: _, streamFileURL: _):
                uploadRequest.responseJSON(completionHandler: { [unowned self] (json) in
                    if let n_value = json.value as? [String:Any] {
                        debugPrint(n_value)
                        if self.uploadCompleteClosure != nil {
                            self.uploadCompleteClosure!(n_value)
                        }
                    }
                })
            }
        }
        
        return self
    }
}
