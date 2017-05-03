//
//  AudioPlayControl.swift
//  ISGame
//
//  Created by kokozu on 2017/4/28.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire

class AudioPlayControl: NSObject {
    static let instance = AudioPlayControl()
    var _player:AVAudioPlayer?
    fileprivate let _filePath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first

    override init() {
       
    }
    
    func play(path:String) {
        do {
            _player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        } catch {
            debugPrint(error)
        }
        
        guard _player != nil else {
            debugPrint("player setup error")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            debugPrint(error)
        }
        
        _player?.numberOfLoops = 0
        _player?.prepareToPlay()
        
        _player?.play()
    }
    
    func play(url:String) {
        debugPrint("download url: " + url)
        
        let fileName = url.components(separatedBy: "/").last
        let localPath = self._filePath! + "/" + fileName!
        
        if FileManager.default.fileExists(atPath: localPath) {
            self.play(path: localPath)
        } else {
            let destination: DownloadRequest.DownloadFileDestination = {
                [unowned self] _, _ in
                let libraryURL = URL(fileURLWithPath: self._filePath!, isDirectory: true)
                let fileURL = libraryURL.appendingPathComponent(fileName!)
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            Alamofire.download(url, to: destination).responseData { [unowned self] (response) in
                if let data = response.result.value {
                    debugPrint("data: \(data.count)")
                    
                    self.play(path: localPath)
                }
            }
        }
        
        
        /*
        Alamofire.request(url).responseData { [unowned self] (response) in
            if let data = response.result.value {
                debugPrint(data.count)
                
                let path = self._filePath?.appending("/demo.caf")
                
                do {
                    let url = URL(fileURLWithPath: path!)
                    try data.write(to: url)
                } catch {
                    debugPrint(error)
                }
                
                self.play(path: path!)
            }
        }
         */
    }
}
