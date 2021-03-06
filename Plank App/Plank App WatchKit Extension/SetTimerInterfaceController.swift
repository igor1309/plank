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
    
    private let minTimerConstant = 15
    private let maxTimerConstant = 600
    private let timerDelayConstant = 1.0
    private let stepConstant = 5
    private let numOfMaxTimesConstant = 4
    private let motivationStepConstant = 10
    
    private var work: DispatchWorkItem?
    
    private var timer: Int {
        get {
            var lastTimer = UserDefaults.standard.integer(forKey: "LastTimer")
            if lastTimer < minTimerConstant {
                lastTimer = minTimerConstant
            }
            if lastTimer > maxTimerConstant {
                lastTimer = maxTimerConstant
            }
            var t = Double(lastTimer) / Double(stepConstant)
            t.round(.awayFromZero)
            t = t * Double(stepConstant)
            return Int(t)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LastTimer")
        }
    }
    
    private var job: DispatchWorkItem = DispatchWorkItem(block: {})
    
    @IBOutlet var timerLabel: WKInterfaceLabel!
    @IBOutlet var prevMaxTimer: WKInterfaceLabel!
    @IBOutlet var setupGroup: WKInterfaceGroup!
    @IBOutlet var countdownGroup: WKInterfaceGroup!
    @IBOutlet var countdownLabel: WKInterfaceLabel!
    
    @IBAction func minusTimer() {
        if timer > stepConstant {
            timer -= stepConstant
        } else {
            timer = stepConstant
        }
        
        setTimer()
    }
    
    @IBAction func plusTimer() {
        if timer < maxTimerConstant {
            timer += stepConstant
        } else {
            timer = maxTimerConstant
        }
        
        setTimer()
    }
    
    private func setTimer() {
        timerLabel.setText(String(timer))
        
    }
    
    @IBAction func startButtonTap() {
        
        setupGroup.setHidden(true)
        countdownGroup.setHidden(false)
        
        self.animate(withDuration: timerDelayConstant) {
            self.countdownLabel.setAlpha(0)
        }
        
        work = DispatchWorkItem(block: {
            self.pushController(withName: "Timer",
                                context: self.timer)
        })
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + timerDelayConstant,
            execute: work!)
    }
    
    @IBAction func stopCountdownButton() {
        if let work = work {
            work.cancel()
            countdownLabel.setAlpha(1)
            countdownGroup.setHidden(true)
            setupGroup.setHidden(false)
        }
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
        
        let max = UserDefaults.standard.integer(forKey: "Max")
        prevMaxTimer.setText("MAX: \(max)")
        
        if timer >= max {
            //FIXME: проверить MaxTimes — если больше определенного значения, то увеличить таймер
            //FIXME: лучше брать данные из HK и анализировать данные за последние 2 недели
            let maxTimes = UserDefaults.standard.integer(forKey: "MaxTimes")
            if maxTimes > numOfMaxTimesConstant {
                timer += motivationStepConstant
                print("включаем мотивацию сделать больше")
            }
        }
        
        setTimer()
    }
}

extension SetTimerInterfaceController: WKCrownDelegate {
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?,
                        rotationalDelta: Double) {
        
        timer += Int(1000 * rotationalDelta)
        timer = Int(round(Double(timer) / Double(stepConstant)) * Double(stepConstant))
        
        if timer < stepConstant {
            timer = stepConstant
        } else if timer > maxTimerConstant {
            timer = maxTimerConstant
        }
        
        setTimer()
    }
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        
    }
}
