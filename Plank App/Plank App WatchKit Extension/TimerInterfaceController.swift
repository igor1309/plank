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
    
    var timer: TimeInterval = 0
    var timer: Timer()
    @IBOutlet var timeToGo: WKInterfaceTimer!
    @IBOutlet var timePassed: WKInterfaceTimer!
    
    @IBAction func stopTimer() {
        
        timeToGo.stop()
        timePassed.stop()

        //FIXME: setup timer: Timer
        
        //FIXME: передать значение таймера
        pushController(withName: "Finish", context: timePassed)

    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let timer = context as? TimeInterval {
            self.timer = timer
        }
        
        
        let date = Date(timeIntervalSinceNow: timer)

        timeToGo.setDate(date)
        timeToGo.start()
        timePassed.start()
    }


}
