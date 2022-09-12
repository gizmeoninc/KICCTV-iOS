//
//  ScreenRecordingDetector.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 20/08/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import Foundation
import UIKit

let kScreenRecordingDetectorTimerInterval = 1.0
let kScreenRecordingDetectorRecordingStatusChangedNotification = "kScreenRecordingDetectorRecordingStatusChangedNotification"


class ScreenRecordingDetector: NSObject {
    
    static var shared = ScreenRecordingDetector()

    var lastRecordingState = Bool()
    var timer:Timer? = Timer()
    
    fileprivate override init(){
        self.lastRecordingState = false // initially the recording state is 'NO'. This is the default state.
        self.timer = nil
    }
    
    func isRecording() -> Bool{
        
        for screen in UIScreen.screens{
            
            if #available(iOS 11.0, *) {
                //print("isCaptured: ", screen.isCaptured)
                if (screen.responds(to: #selector(getter: screen.isCaptured))){
                    if let _ = screen.perform(#selector(getter: screen.isCaptured)){
                        return true
                    }
                    else if let _ = screen.mirrored{
                        return true // mirroring is active
                    }
                }
                else{
                    if let _ = screen.mirrored{
                        return true
                    }
                }
            }else {
                // Fallback on earlier versions
                if let _ = screen.mirrored{
                    return true
                }
            }
        }
        return false
    }
    
    func triggerDetectorTimer(){
        let detector = ScreenRecordingDetector.shared
        if let _ = detector.timer{
            self.stopDetectorTimer()
        }
        detector.timer = Timer.scheduledTimer(timeInterval: kScreenRecordingDetectorTimerInterval, target: detector, selector: #selector(checkCurrentRecordingStatus), userInfo: nil, repeats: true)
    }
    
    @objc func checkCurrentRecordingStatus(timer: Timer){
        let isRecording = self.isRecording()
        if isRecording != self.lastRecordingState{
            let center = NotificationCenter.default
            center.post(name: NSNotification.Name(kScreenRecordingDetectorRecordingStatusChangedNotification), object: nil, userInfo: nil)
        }
    }
    
    func stopDetectorTimer(){
        let detector = ScreenRecordingDetector.shared
        if let _ = detector.timer{
            detector.timer?.invalidate()
        }
        detector.timer = nil
    }
    
}

