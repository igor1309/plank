//
//  TimerInterfaceController.swift
//  Plank App WatchKit Extension
//
//  Created by Igor Malyarov on 26.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class TimerInterfaceController: WKInterfaceController {
    
    private let minTimerConstant = 15
    private let maxTimerConstant = 600

    private var timeInterval: TimeInterval = 0
    private var timer: Timer!
    private var timeLapsed: Int = 0

    private let healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    private var hapticFeedbackTimer: Timer?
    
    @IBOutlet var timeToGo: WKInterfaceTimer!
    @IBOutlet var timePassed: WKInterfaceTimer!
    
    @IBAction func stopTimer() {
        stopTimersAndSaveData()
        
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let timeInterval = context as? TimeInterval {
            self.timeInterval = timeInterval
        } else {
            self.timeInterval = 50
        }
        
        let date = Date(timeIntervalSinceNow: self.timeInterval)
        
        timer = Timer.scheduledTimer(
            withTimeInterval: self.timeInterval,
            repeats: false) { _ in
                self.timerDone()
        }
        
        timePassed.start()
        timeToGo.setDate(date)
        timeToGo.start()
        
        startWorkout()
    }
    
    override func willActivate() {
        let healthService: HealthDataService = HealthDataService()
        
        healthService.authorizeHealthKitAccess { (success, error) in
            if success {
                print("SetTimerInterfaceController: willActivate: HealthKit authorization received.")
            } else {
                print("SetTimerInterfaceController: willActivate: HealthKit authorization denied!")
                if error != nil {
                    print("SetTimerInterfaceController: willActivate: error: \(String(describing: error))")
                }
            }
        }

    }
    
    private func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .coreTraining
        
        do {
            session = try HKWorkoutSession(configuration: configuration)
            
            session?.delegate = self as? HKWorkoutSessionDelegate
            healthStore.start(session!)
        }
        catch let error as NSError {
            // Perform proper error handling here...
            fatalError("*** Unable to create the workout session: \(error.localizedDescription) ***")
            print(error)
        }
    }

    @objc func timerDone() { stopTimersAndSaveData() }
    
    func stopTimersAndSaveData() {
        
        
        timeToGo.stop()
        timePassed.stop()
        
        timeLapsed = Int(timeInterval - timer.fireDate.timeIntervalSinceNow)
//        print("func stopTimersAndSaveData timeIntervalSinceNow \(timer.fireDate.timeIntervalSinceNow)s")
        timer.invalidate()
        
        // save Last and Max Data
        let userDefaults = UserDefaults.standard
        
        if timeLapsed > maxTimerConstant {
            timeLapsed = maxTimerConstant
        }
        userDefaults.set(timeLapsed, forKey: "LastTimer")
        
        //FIXME: лучше брать данные из HK и анализировать данные за последние 2 недели
        var max = userDefaults.integer(forKey: "Max")
        if max > maxTimerConstant {
            max = maxTimerConstant
        }
        let maxTimes = userDefaults.integer(forKey: "MaxTimes")
        if timeLapsed > max {
            UserDefaults.standard.set(timeLapsed, forKey: "Max")
            UserDefaults.standard.set(1, forKey: "MaxTimes")
        } else if timeLapsed == max {
            UserDefaults.standard.set(maxTimes + 1, forKey: "MaxTimes")
        }
        
        // haptic feedback
        WKInterfaceDevice.current().play(.success)
        
        healthStore.end(session!)

        // передать значение таймера
        pushController(withName: "Finish", context: timeLapsed)
    }
    
}
