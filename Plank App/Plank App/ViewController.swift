//
//  ViewController.swift
//  Plank App
//
//  Created by Igor Malyarov on 25.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let healthService:HealthDataService = HealthDataService()
        healthService.authorizeHealthKitAccess { (accessGranted, error) in
            DispatchQueue.main.async {
                if accessGranted {
                    print("HealthKit access granted!")
                    
                } else {
                    print("HealthKit access denied! \n\(String(describing: error))")
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

