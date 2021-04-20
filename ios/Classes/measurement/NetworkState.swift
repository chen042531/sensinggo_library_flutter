//
//  NetworkState.swift
//  sensingGo_flutter
//
//  Created by ycchen on 2020/12/5.
//

import Foundation
import Network
@available(iOS 12.0, *)
public class NetworkState {
    public  let monitor = NWPathMonitor()
    public init(){}
    public func status (values: ((String) -> ())? ){
        var stat: String!
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { path in
           if path.status == .satisfied {
              print("connected")
              stat = "connected"
           } else {
              print("no connection")
              stat = "no connection"
           }
           if values != nil{
              values!( stat )
           }
           
        }
    }
    public func type (values: ((String) -> ())? ){
        var type:String!
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { path in
           if path.usesInterfaceType(.wifi) {
              print("cnnected")
              type = "WIFI"
              
           } else {
              print("no connection")
              type = "CELLULAR"
           }
            if values != nil{
               values!( type )
            }
        }
        
    }
}
