//
//  FinishInterfaceController.swift
//  Plank App WatchKit Extension
//
//  Created by Igor Malyarov on 26.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import WatchKit
import Foundation


class FinishInterfaceController: WKInterfaceController {
    
    var timer: TimeInterval = 0
    @IBOutlet var finishLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        if let timer = context as? TimeInterval {
            self.timer = timer
        }
        
        print(timer)
        finishLabel.setText("Ура! \(Int(timer))")
        
    }

    @IBAction func finishButtonTap() {
        
        //FIXME: save data
        //save last, count max and max times
        // последний, максимум и сколько раз был максимум
        
        popToRootController()
    }
    
}
