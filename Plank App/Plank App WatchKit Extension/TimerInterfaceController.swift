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
    
    var timer: Int = 0
    
    @IBAction func stopTimer() {
        //FIXME: передать значение таймера
        presentController(withName: "Finish", context: timer)

    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let timer = context as? Int {
            self.timer = timer
        }
    }


}
