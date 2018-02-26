//
//  SetTimerInterfaceController.swift
//  Plank App
//
//  Created by Igor Malyarov on 26.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import WatchKit
import Foundation


class SetTimerInterfaceController: WKInterfaceController {
    
    var timer: Int = 120
    
    @IBOutlet var timerLabel: WKInterfaceLabel!
    
    @IBAction func minusTimer() {
        if timer > 5 {
            timer -= 5
            setTimer()
        }
    }
    
    @IBAction func plusTimer() {
        if timer < 500 {
            timer += 5
            setTimer()
        }
    }
    
    private func setTimer() {
        timerLabel.setText(String(Int(timer)))
        UserDefaults.standard.set(timer,
                                  forKey: "Timer")
    }
    
    @IBAction func startButtonTap() {
        presentController(withName: "CountDown", context: timer)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let userDefaults = UserDefaults.standard
        timer = userDefaults.integer(forKey: "Timer")
        setTimer()
    }

}
