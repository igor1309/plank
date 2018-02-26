//
//  CountDownInterfaceController.swift
//  Plank App WatchKit Extension
//
//  Created by Igor Malyarov on 26.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import WatchKit
import Foundation


class CountDownInterfaceController: WKInterfaceController {
    
    var timer: Int?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let timer = context as? Int {
            self.timer = timer
        }
    
        
        self.dismiss()
        presentController(withName: "CountDown", context: timer)
        
        //FIXME: delay and animate
        let duration = 1.0
        let delay = DispatchTime.now() + duration

        

        DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
            // 5
//            self?.dismiss()
        }

    }
}
