import Flutter
import UIKit
import CoreMotion
import NMSSH

public class SwiftSensingGoFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let mChannel = FlutterMethodChannel(name: "sensingGo_flutter", binaryMessenger: registrar.messenger())
    
    let instance = SwiftSensingGoFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: mChannel)
//
    mChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: FlutterResult) -> Void in
      // Note: this method is invoked on the UI thread.
        var file_maker = fileMaker()
        var send_Data = sendData()
        if ("plugins.flutter.io/phoneInfo_ios" == call.method) {
            let phinfo = PhoneInfo()

            result(["BatteryLevel":String(phinfo.receiveBatteryLevel())]);
        }
        else if ("plugins.flutter.io/wifi" == call.method) {
            let wifi = WiFiInfo()
            result(["wifi_ssid":String(wifi.getWiFiSsid()!)]);
        }
        else if ("plugins.flutter.io/cellular_ios" == call.method) {
            let cellular = CellularInfo()
            print("cellular",cellular.getMNC())
            result(["MNC":String(cellular.getMNC()),
                    "CarrierName":String(cellular.getCarrierName()),
                    "MobileCountryCode":String(cellular.getMobileCountryCode())]);
        }
        else if ("plugins.flutter.io/writeFile" == call.method) {
            guard let args = call.arguments else{
                return
            }
            let myArgs = args as? [String: Any]
            let val1 = myArgs?["info"] as? String
//            print("tttttt", val1)
            file_maker.makeFile(val1: val1 ?? "no")
   
        }
        else if ("plugins.flutter.io/writeFile_blank" == call.method) {
            
            file_maker.makeFile_blank(val1:"")
   
        }
        else if ("plugins.flutter.io/send" == call.method) {
            print("tttttt", "send")
            send_Data.send()
   
        }
        else {
            result(FlutterMethodNotImplemented);
        }

    })
    let locationChannel = FlutterEventChannel(name: "plugins.flutter.io/location", binaryMessenger: registrar.messenger())
    locationChannel.setStreamHandler(locationChannelHandler())
    class locationChannelHandler: NSObject, FlutterStreamHandler {
        var loc = Location()
          public func onListen(withArguments arguments: Any?, eventSink events:  @escaping FlutterEventSink) -> FlutterError? {
        
                loc.getLocation(action: { (lng, lat) in
                                
                    events(["lng":String(lng),"lat":String(lat)])
              })
              return nil
          }

          public func onCancel(withArguments arguments: Any?) -> FlutterError? {
            loc.stop_loc()
            return nil
          }
      }
  
    let accelerometer = FlutterEventChannel(name: "plugins.flutter.io/sensors/accelerometer", binaryMessenger: registrar.messenger())
    accelerometer.setStreamHandler(accelerometerHandler())

    let magmeter = FlutterEventChannel(name: "plugins.flutter.io/sensors/magmeter", binaryMessenger: registrar.messenger())
    magmeter.setStreamHandler(magmeterHandler())
    
    let altitude = FlutterEventChannel(name: "plugins.flutter.io/sensors/altitude", binaryMessenger: registrar.messenger())
    altitude.setStreamHandler(altitudeHandler())
    let gyro = FlutterEventChannel(name: "plugins.flutter.io/sensors/gyrometer", binaryMessenger: registrar.messenger())
    gyro.setStreamHandler(gyroHandler())
   
    if #available(iOS 12.0, *) {
        let networkstate = FlutterEventChannel(name: "plugins.flutter.io/networkstate_ios", binaryMessenger: registrar.messenger())
        networkstate.setStreamHandler(networkstateHandler())
    } else {
        // Fallback on earlier versions
    }

  }
//
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
    
    @available(iOS 12.0, *)
    class networkstateHandler: NSObject, FlutterStreamHandler {
          let nState = NetworkState()
  //        let manager: CMMotionManager = CMMotionManager()
          public func onListen(withArguments arguments: Any?, eventSink events:  @escaping FlutterEventSink) -> FlutterError? {
  //            print("fuck")
                nState.status() { (X) -> () in
                    events({String(X)})
              }
              
              return nil
          }

          public func onCancel(withArguments arguments: Any?) -> FlutterError? {
              return nil
          }
      }
//
  class accelerometerHandler: NSObject, FlutterStreamHandler {
        let senInfo = sensorInfo()
//        let manager: CMMotionManager = CMMotionManager()
        public func onListen(withArguments arguments: Any?, eventSink events:  @escaping FlutterEventSink) -> FlutterError? {
            print("acc")
            senInfo.getAccelerometerValues() { (X, Y, Z) -> () in
                events(["X":String(X), "Y":String(Y), "Z":String(Z)])
            }
            
            return nil
        }

        public func onCancel(withArguments arguments: Any?) -> FlutterError? {
            senInfo.stopAcc()
            return nil
        }
    }
    class magmeterHandler: NSObject, FlutterStreamHandler {
          let senInfo = sensorInfo()
  //        let manager: CMMotionManager = CMMotionManager()
          public func onListen(withArguments arguments: Any?, eventSink events:  @escaping FlutterEventSink) -> FlutterError? {
              print("mag")
              senInfo.getMagnetometerValues() { (X, Y, Z) -> () in
//                print("mag")
                  events(["X":String(X), "Y":String(Y), "Z":String(Z)])
              }
              
              return nil
          }

          public func onCancel(withArguments arguments: Any?) -> FlutterError? {
            print("stop stop stop cancel")
            senInfo.stopMag()
            return nil
          }
      }
    class altitudeHandler: NSObject, FlutterStreamHandler {
          let senInfo = sensorInfo()
  //        let manager: CMMotionManager = CMMotionManager()
          public func onListen(withArguments arguments: Any?, eventSink events:  @escaping FlutterEventSink) -> FlutterError? {
              senInfo.getAltitudeValues() { (alt,press) -> () in
                  events(["alt":String(alt), "press":String(press)])
              }
              
              return nil
          }

          public func onCancel(withArguments arguments: Any?) -> FlutterError? {
            senInfo.stopAlt()
              return nil
          }
      }
    class gyroHandler: NSObject, FlutterStreamHandler {
          let senInfo = sensorInfo()
  //        let manager: CMMotionManager = CMMotionManager()
          public func onListen(withArguments arguments: Any?, eventSink events:  @escaping FlutterEventSink) -> FlutterError? {
              print("gyro")
              senInfo.getGyroscopeValues() { (X, Y, Z) -> () in
                  events(["X":String(X), "Y":String(Y), "Z":String(Z)])
              
              }
              
              return nil
          }

          public func onCancel(withArguments arguments: Any?) -> FlutterError? {
            senInfo.stopGyro()
            
              return nil
          }
      }
}
