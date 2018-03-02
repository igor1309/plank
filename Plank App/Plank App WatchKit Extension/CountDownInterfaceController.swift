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
    
    private var timer: Int?

    @IBOutlet var countDown: WKInterfaceLabel!
    
    @IBAction func stopButtonTap() {
        popToRootController()
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let timer = context as? Int {
            self.timer = timer
        }
        //FIXME: delay and animate
        let duration = 3.0
        let delay = DispatchTime.now() + duration
        
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.countDown.setText("0")
            self.dismiss()
        }
    }
}
