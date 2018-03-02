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
    
    private var timer: Timer!
    private var timeLapsed: Int = 0
    
    @IBOutlet var timeToGo: WKInterfaceTimer!
    @IBOutlet var timePassed: WKInterfaceTimer!
    
    @IBAction func stopTimer() {
        
        timeToGo.stop()
        timePassed.stop()

        timeLapsed = Int(timer.fireDate.timeIntervalSinceNow)
        print("timeIntervalSinceNow \(timer.fireDate.timeIntervalSinceNow)")
        timer.invalidate()
        
        //FIXME: setup timer: Timer
        
        //FIXME: передать значение таймера
        pushController(withName: "Finish", context: timeLapsed)

    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let timeInterval = context as? TimeInterval {
            
            print("time interval from setup \(timeInterval)")
            
            let date = Date(timeIntervalSinceNow: timeInterval)
            timeToGo.setDate(date)
            timeToGo.start()
       
            
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
                print("time is really DONE AS DEFINED IN BLOCK")
            }
            
            
            
//            timer = Timer.scheduledTimer(timeInterval: timeInterval,
//                                         target: self,
//                                         selector: #selector(TimerInterfaceController.timerDone),
//                                         userInfo: nil,
//                                         repeats: false)
//            timer.fire()
            
            timePassed.start()
        }
    }

    @objc func timerDone() {
        if timer.isValid {
            print("Timer Interval: \(timer.timeInterval)")
            print("Timer: \(timer)")
        } else {
            print("timer is DONE")
        }
        
    }

    // format seconds into string of hh:mm:ss
    //    https://makeapppie.com/2016/02/19/how-to-use-watch-timers-and-nstimers-in-watchos2-and-swift/
    func formatTimeInterval(timeInterval:TimeInterval) -> String {
        let secondsInHour = 3600
        let secondsInMinute = 60
        var time = Int(timeInterval)
        let hours = time / secondsInHour
        time = time % secondsInHour
        let minutes = time / secondsInMinute
        let seconds = time % secondsInMinute
        return String(format:"%02i:%02i:%02i",hours,minutes,seconds)
    }
}
