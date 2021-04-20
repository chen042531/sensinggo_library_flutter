
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class SensingGoFlutter {

  static const MethodChannel mChannel = const MethodChannel('sensingGo_flutter');
  ///////////// same
  static Future<dynamic> get wifi async {
    final Map wifiInfo = await mChannel.invokeMethod('plugins.flutter.io/wifi');
    return wifiInfo;
  }
  static const EventChannel locationChannel = EventChannel("plugins.flutter.io/location");
  static Stream<dynamic> get location {
    return locationChannel.receiveBroadcastStream();
  }
  static const EventChannel eventAccChannel = EventChannel("plugins.flutter.io/sensors/acc");
  static Stream<dynamic> get accEvents {

    return eventAccChannel.receiveBroadcastStream();

  }
  static const EventChannel eventMagChannel = EventChannel("plugins.flutter.io/sensors/magmeter");
  static Stream<dynamic> get magmeterEvents {

    return eventMagChannel.receiveBroadcastStream();

  }
  static Future<Null> writeFile(info) async {
    var sendMap = <String, dynamic> {
      "info":info
    };
    String value;
    try {
      value = await mChannel.invokeMethod('plugins.flutter.io/writeFile', sendMap);
    }catch (e) {
      print(e);
    }
  }
  static Future<Null> writeFile_blank() async {
    try {
     await mChannel.invokeMethod('plugins.flutter.io/writeFile_blank');
    }catch (e) {
      print(e);
    }
  }
  static Future<Null> sendFile() async {
    try {
      await mChannel.invokeMethod('plugins.flutter.io/send');
    }catch (e) {
      print(e);
    }
  }
  // static Future<Null> writeFile(info) async {
  //   Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
  //   String appDocumentsPath = appDocumentsDirectory.path; // 2
  //   String filePath = '$appDocumentsPath/test.txt'; // 3
  //   new File(filePath).writeAsStringSync(info, mode: FileMode.append);
  // }
  // static Future<Null> readFile() async {
  //   Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
  //   String appDocumentsPath = appDocumentsDirectory.path; // 2
  //   String filePath = '$appDocumentsPath/test.txt'; // 3
  //   new File(filePath).readAsString().then((String contents) {
  //     print(contents);
  //   });
  // }
  //iOS
  static const EventChannel networkstateChannel_ios = EventChannel("plugins.flutter.io/networkstate_ios");
  static Stream<dynamic> get networkstateEvents_ios {
    // return _sensing;

    return networkstateChannel_ios.receiveBroadcastStream();

  }
  static Future<dynamic> get phoneInfo_ios async {
    // ios getBatteryLevel
    final Map phoneInfo_ios = await mChannel.invokeMethod('plugins.flutter.io/phoneInfo_ios');
    // print(phoneInfo_ios['BatteryLevel']);
    return phoneInfo_ios;
  }

  static Future<dynamic> get cellular_ios async {
    final Map cellular_ios = await mChannel.invokeMethod('plugins.flutter.io/cellular_ios');
    // print(cellular_ios['cellular']);
    return cellular_ios;
  }
  static const EventChannel eventgyrometerChannel = EventChannel("plugins.flutter.io/sensors/gyrometer");
  static Stream<dynamic> get gyrometerEvents_ios {
    return eventgyrometerChannel.receiveBroadcastStream();
  }
  static const EventChannel eventaltitudeChannel = EventChannel("plugins.flutter.io/sensors/altitude");
  static Stream<dynamic> get altitudeEvents_ios {
    // return _sensing;
    return eventaltitudeChannel.receiveBroadcastStream();

  }

  //Android
  static Future<dynamic> get networkstate async {
    final Map networkstate = await mChannel.invokeMethod('plugins.flutter.io/networkstate');
    return networkstate;
  }
  static Future<dynamic> get phoneInfo async {
    final Map phoneInfo = await mChannel.invokeMethod('plugins.flutter.io/phoneInfo');
    return phoneInfo;
  }
  static const EventChannel locationGChannel = EventChannel("plugins.flutter.io/location_gps");
  static Stream<dynamic> get locationG {
    return locationGChannel.receiveBroadcastStream();
  }
  static const EventChannel batteryStateChannel = EventChannel("plugins.flutter.io/batteryState");
  static Stream<dynamic> get batteryState {
    return batteryStateChannel.receiveBroadcastStream();

  }
  static const EventChannel screenStateChannel = EventChannel("plugins.flutter.io/screenState");
  static Stream<dynamic> get screenState {
    return screenStateChannel.receiveBroadcastStream();

  }
  static const EventChannel phonestateChannel = EventChannel("plugins.flutter.io/phoneState");
  static Stream<dynamic> get phonestate {
    return phonestateChannel.receiveBroadcastStream();

  }
  static const EventChannel cellularinfoChannel = EventChannel("plugins.flutter.io/cellularInfo");
  static Stream<dynamic> get cellularinfo {
    // return _sensing;

    return cellularinfoChannel.receiveBroadcastStream();

  }

  static const EventChannel eventProxiChannel = EventChannel("plugins.flutter.io/sensors/proxi");
  static Stream<dynamic> get proxiEvents {
    // return _sensing;
    return eventProxiChannel.receiveBroadcastStream();

  }
  static const EventChannel eventLightChannel = EventChannel("plugins.flutter.io/sensors/light");
  static Stream<dynamic> get lightEvents {
    // return _sensing;
    return eventLightChannel.receiveBroadcastStream();

  }


}
