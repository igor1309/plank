//
//  TimerInterfaceController.swift
//  Plank App WatchKit Extension
//
//  Created by Igor Malyarov on 26.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import WatchKit
import Foundation


class TimerInterfaceController: WKInterfaceController {
    
    private var timeInterval: TimeInterval = 0
    private var timer: Timer!
    private var timeLapsed: Int = 0
    
    @IBOutlet var timeToGo: WKInterfaceTimer!
    @IBOutlet var timePassed: WKInterfaceTimer!
    
    @IBAction func stopTimer() { stopTimersAndSaveData() }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        timePassed.start()
        if let timeInterval = context as? TimeInterval {
            
            self.timeInterval = timeInterval
            let date = Date(timeIntervalSinceNow: timeInterval)
       
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval,
                                         repeats: false) { _ in
                self.timerDone()
            }
            
            timeToGo.setDate(date)
            timeToGo.start()
        }
    }

    @objc func timerDone() { stopTimersAndSaveData() }
    
    func stopTimersAndSaveData() {
        
        timeToGo.stop()
        timePassed.stop()
        
        timeLapsed = Int(timeInterval - timer.fireDate.timeIntervalSinceNow)
        print("func stopTimersAndSaveData timeIntervalSinceNow \(timer.fireDate.timeIntervalSinceNow)s")
        timer.invalidate()
        
        //FIXME: save data
        UserDefaults.standard.set(timeLapsed, forKey: "Timer")
        
        
        //FIXME: передать значение таймера
        pushController(withName: "Finish", context: timeLapsed)
        
    }
}
