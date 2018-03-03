//
//  File.swift
//  Plank App
//
//  Created by Igor Malyarov on 03.03.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import Foundation
import HealthKit

let energyType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
let hrType:HKQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
//FIXME: какие параметры можно считывать и записывать для упражнения Планка?

class HealthDataService {
    
    internal let healthKitStore: HKHealthStore = HKHealthStore()
    
    init() {}
    
    /// This function asks HealthKit for authorization to read and write to the health store
    func authorizeHealthKitAccess(_ completion: ((_ success:Bool, _ error:Error?) -> Void)!) {
        let typesToShare = Set(
            [HKObjectType.workoutType(),
             energyType,
             hrType
            ])
        let typesToSave = Set([
            energyType,
            hrType
            ])
        
        healthKitStore.requestAuthorization(toShare: typesToShare, read: typesToSave) { (success, error) in
            completion(success, error)
        }
    }

}
