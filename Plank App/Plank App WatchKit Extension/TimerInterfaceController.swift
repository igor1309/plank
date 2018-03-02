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
        
        if let timeInterval = context as? TimeInterval {
            self.timeInterval = timeInterval
        } else {
            self.timeInterval = 50
        }
        
        let date = Date(timeIntervalSinceNow: timeInterval)
        
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval,
                                     repeats: false) { _ in
                                        self.timerDone()
        }
        
        timePassed.start()
        timeToGo.setDate(date)
        timeToGo.start()
    }

    @objc func timerDone() { stopTimersAndSaveData() }
    
    func stopTimersAndSaveData() {
        
        timeToGo.stop()
        timePassed.stop()
        
        timeLapsed = Int(timeInterval - timer.fireDate.timeIntervalSinceNow)
        print("func stopTimersAndSaveData timeIntervalSinceNow \(timer.fireDate.timeIntervalSinceNow)s")
        timer.invalidate()
        
        // save Last and Max Data
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(timeLapsed, forKey: "LastTimer")
        
        let max = userDefaults.integer(forKey: "Max")
        let maxTimes = userDefaults.integer(forKey: "MaxTimes")
        if timeLapsed > max {
            UserDefaults.standard.set(timeLapsed, forKey: "Max")
            UserDefaults.standard.set(1, forKey: "MaxTimes")
        } else if timeLapsed == max {
            UserDefaults.standard.set(maxTimes + 1, forKey: "MaxTimes")
        }
        
        
        //FIXME: передать значение таймера
        pushController(withName: "Finish", context: timeLapsed)
        
    }
}
