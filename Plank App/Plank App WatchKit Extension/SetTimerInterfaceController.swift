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
    
    var timer: Int {
        get {
            return UserDefaults.standard.integer(forKey: "Timer")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Timer")
        }
    }

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
    }
    
    @IBAction func startButtonTap() {
        presentController(withName: "CountDown", context: timer)
        //FIXME: if return is ok
        if true {
            pushController(withName: "Timer", context: self.timer)
        }

    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        setTimer()
    }
}
