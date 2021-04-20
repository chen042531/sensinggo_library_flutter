//
//  SensorInfo.swift
//  sensinggo_lib
//
//  Created by ycchen on 2020/11/28.
//

import Foundation
import CoreMotion
import NMSSH

public class sensorInfo{
    var manager = CMMotionManager()
    var altimeter = CMAltimeter()
    public init(){
        
    }
    public func getAccelerometerValues (values: ((Double, Double, Double) -> ())? ){
        print("rrrrrrrrrr")
            var valX: Double!
            var valY: Double!
            var valZ: Double!
        if manager.isAccelerometerAvailable  {
            manager.accelerometerUpdateInterval = 0.5
            manager.startAccelerometerUpdates(to: OperationQueue(), withHandler: {
                    (data, error) in
                    
                    
                    valX = data!.acceleration.x
                    valY = data!.acceleration.y
                    valZ = data!.acceleration.z
    //                print(valX)
                    if values != nil{
                        values!( valX,valY, valZ)
                    }
//                    self.delegate?.retrieveAccelerometerValues(x: valX, y: valY, z: valZ)
                })
            } else {
                print("The Accelerometer is not available")
            }
        }
 
    public func getMagnetometerValues (values: ((Double, Double, Double) -> ())? ){
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.isMagnetometerAvailable  {
            
            manager.startMagnetometerUpdates(to: OperationQueue(), withHandler: {
                    (data, error) in
                    
                    
                    valX = data!.magneticField.x
                    valY = data!.magneticField.y
                    valZ = data!.magneticField.z
    //                print(valX)
                    if values != nil{
                        values!( valX,valY, valZ)
                    }
//                    self.delegate?.retrieveAccelerometerValues(x: valX, y: valY, z: valZ)
                })
            } else {
                print("The Magnetometer is not available")
            }
        
    }
    public func getAltitudeValues (values: ((Double, Double) -> ())? ){
        var relativeAltitude: Double!
        var pressure: Double!
      
        if CMAltimeter.isRelativeAltitudeAvailable()  {
            
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue(), withHandler: {
                    (data, error) in
                    
                    
                relativeAltitude = data!.relativeAltitude.doubleValue
                pressure = data!.pressure.doubleValue
                   
    //                print(valX)
                    if values != nil{
                        values!( relativeAltitude,pressure)
                    }
//                    self.delegate?.retrieveAccelerometerValues(x: valX, y: valY, z: valZ)
                })
            } else {
                print("The Altitude is not available")
            }
        
    }
    public func getGyroscopeValues(values: ((Double, Double, Double) -> ())? ){
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
      
        if manager.isGyroAvailable  {
         
            manager.startGyroUpdates(to: OperationQueue(), withHandler: {
                    (data, error) in
                    
                    
                    valX = data!.rotationRate.x
                    valY = data!.rotationRate.y
                    valZ = data!.rotationRate.z
    //                print(valX)
                    if values != nil{
                        values!(valX,valY, valZ)
                    }
//                    self.delegate?.retrieveAccelerometerValues(x: valX, y: valY, z: valZ)
                })
            } else {
                print("The Gyro is not available")
            }
    }
    public func stopAcc(){
        manager.stopAccelerometerUpdates()
    }
    public func stopMag(){
        manager.startMagnetometerUpdates()
    }
    public func stopAlt(){
        altimeter.stopRelativeAltitudeUpdates()
    }
    public func stopGyro(){
        manager.stopGyroUpdates()
    }
  
}
