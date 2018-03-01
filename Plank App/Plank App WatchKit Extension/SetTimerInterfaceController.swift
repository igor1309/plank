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
    
    let maxTimer = 600
    let timerDelay = 3.0
    var work: DispatchWorkItem?
    
    var timer: Int {
        get {
            return UserDefaults.standard.integer(forKey: "Timer")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Timer")
        }
    }
    
    private var job: DispatchWorkItem = DispatchWorkItem(block: {})
    
    @IBOutlet var timerLabel: WKInterfaceLabel!
    @IBOutlet var prevMaxTimer: WKInterfaceLabel!
    @IBOutlet var setupGroup: WKInterfaceGroup!
    @IBOutlet var countdownGroup: WKInterfaceGroup!
    @IBOutlet var countdownLabel: WKInterfaceLabel!
    
    @IBAction func minusTimer() {
        if timer > 5 {
            timer -= 5
        } else {
            timer = 5
        }
        
        setTimer()
    }
    
    @IBAction func plusTimer() {
        if timer < maxTimer {
            timer += 5
        } else {
            timer = maxTimer
        }
        
        setTimer()
    }
    
    private func setTimer() {
        timerLabel.setText(String(Int(timer)))
    }
    
    @IBAction func startButtonTap() {
        
        setupGroup.setHidden(true)
        countdownGroup.setHidden(false)
        
        self.animate(withDuration: timerDelay) {
            self.countdownLabel.setAlpha(0)
        }
        
        work = DispatchWorkItem(block: {
            self.pushController(withName: "Timer",
                                context: self.timer)
        })
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + timerDelay,
            execute: work!)
    }
    
    @IBAction func stopCountdownButton() {
        
        work?.cancel()
        
        countdownLabel.setAlpha(1)
        countdownGroup.setHidden(true)
        setupGroup.setHidden(false)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        crownSequencer.delegate = self
        setTimer()
    }
    
    override func willActivate() {
        crownSequencer.focus()
        self.countdownLabel.setAlpha(1)
        setupGroup.setHidden(false)
        countdownGroup.setHidden(true)
    }
}

extension SetTimerInterfaceController: WKCrownDelegate {
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?,
                        rotationalDelta: Double) {
        
        timer += Int(1000 * rotationalDelta)
        timer = Int(round(Double(timer / 5)) * 5)
        
        if timer < 5 {
            timer = 5
        } else if timer > maxTimer {
            timer = maxTimer
        }
        
        setTimer()
    }
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        
    }
}
