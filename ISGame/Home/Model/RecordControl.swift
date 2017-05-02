//
//  RecordControl.swift
//  ISGame
//
//  Created by kokozu on 2017/4/28.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import Foundation
import AVFoundation

class RecordControl: NSObject {
    static let instance = RecordControl()
    fileprivate let _filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    
    var _recorder:AVAudioRecorder?
    
    override init() {
        super.init()
       
    }
    
    func record() {
        guard _filePath != nil else {
            debugPrint("record save path error")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            debugPrint(error)
        }
        
        let url = URL(fileURLWithPath: _filePath!+"/recorder.caf")
        
        let settings:[String:Any] = [AVFormatIDKey:kAudioFormatLinearPCM,
                                     AVSampleRateKey:8000,
                                     AVNumberOfChannelsKey:1,
                                     AVLinearPCMBitDepthKey:8,
                                     AVLinearPCMIsFloatKey:true]
        
        do {
            _recorder = try AVAudioRecorder(url: url, settings: settings)
        } catch {
            debugPrint(error)
        }
        
        _recorder?.delegate = self
        _recorder?.isMeteringEnabled = true
        _recorder?.prepareToRecord()
        _recorder?.record()
    }
    
    func stop() {
        guard _recorder != nil else {
            debugPrint("recorder empty")
            return
        }
        _recorder?.stop()
    }
    
}

//MARK: Recorder Delegate
extension RecordControl: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        debugPrint(flag)
        if flag {
            AudioPlayControl.instance.play(path: _filePath!+"/recorder.caf")
            
            let url = URL(fileURLWithPath: _filePath!+"/recorder.caf")

            do {
                let recorderData = try Data.init(contentsOf: url)
                UploadFileManager.instance.updateFile(data: recorderData)
                
                
            } catch {
                debugPrint("error")
            }
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        debugPrint("error")
    }
}
