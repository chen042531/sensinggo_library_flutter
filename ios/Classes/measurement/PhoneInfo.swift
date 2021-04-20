//
//  PhoneInfo.swift
//  sensingGo_flutter
//
//  Created by ycchen on 2020/12/5.
//

import Foundation
public class PhoneInfo{
    public init(){}
   
    public func receiveBatteryLevel()->Float {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel*100
    
        print("batteryLevelhaha", batteryLevel)
        return batteryLevel
    }
}
