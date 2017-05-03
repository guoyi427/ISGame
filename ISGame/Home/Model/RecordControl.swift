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
    fileprivate let _filePath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
    fileprivate var _fileName = ""
    
    var _recorder:AVAudioRecorder?
    /// 录音完成
    var recorderCompleteClosure:((Data, String)->Void)?
    
    
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
        
        let timestampStr = String(format: "%.0f", arguments: [Date().timeIntervalSince1970*1000.0])
        _fileName = UserControl.shared.getUid()+"_"+timestampStr+".caf"
        let url = URL(fileURLWithPath: _filePath! + "/" + _fileName)
        
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
    
    func stop() -> RecordControl {
        guard _recorder != nil else {
            debugPrint("recorder empty")
            return self
        }
        _recorder?.stop()
        return self
    }
    
}

//MARK: Recorder Delegate
extension RecordControl: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        debugPrint(flag)
        if flag {
            let url = URL(fileURLWithPath: _filePath! + "/" + _fileName)

            do {
                let recorderData = try Data.init(contentsOf: url)
                if let complete = recorderCompleteClosure {
                    complete(recorderData, _fileName)
                }
            } catch {
                debugPrint("error")
            }
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        debugPrint("error")
    }
}
