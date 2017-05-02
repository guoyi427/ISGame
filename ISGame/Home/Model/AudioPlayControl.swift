//
//  AudioPlayControl.swift
//  ISGame
//
//  Created by kokozu on 2017/4/28.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayControl: NSObject {
    static let instance = AudioPlayControl()
    var _player:AVAudioPlayer?
    
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
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            debugPrint(error)
        }
        
        _player?.numberOfLoops = 0
        _player?.prepareToPlay()
        
        _player?.play()
    }
}
