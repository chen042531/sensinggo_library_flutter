//
//  Location.swift
//  sensinggo_lib
//
//  Created by ycchen on 2020/11/28.
//

import Foundation
import CoreLocation
public class Location: NSObject, CLLocationManagerDelegate {
    
    var lm = CLLocationManager()
    var latitude:Double = 0
    var longitude:Double = 0
    var action: (Double,Double) -> Void
//    program:((Double,Double)->Void)
    public override init(){
        
        
        self.action = {(a,b)in }
        super.init()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.requestWhenInUseAuthorization()
        
    }
    public func getLocation (action: @escaping (Double,Double) -> Void ){
        self.action = action
        lm.startUpdatingLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            print("llll",latitude)
          
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            action(latitude,longitude)
         
        }
    }
    public func stop_loc(){
        lm.stopUpdatingLocation()
    }
    
}
