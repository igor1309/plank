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

    @IBAction func finishButtonTap() {
        //FIXME: разобраться с навигацией и понять, как убивать ненужные InterfaceController
        self.dismiss()
    }
    
}
