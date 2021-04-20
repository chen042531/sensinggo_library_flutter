import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sensingGo_flutter/sensingGo_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
void main() {

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PermissionStatus _permissionStatus;
  String _platformVersion = 'Unknown';
  String _sen = 'Unknown';
  StreamSubscription _streamSubscription;

  Future<void> requestPermission(Permission permission) async {

    final status = await permission.request();

    setState(() {
      // print(status);
      _permissionStatus = status;
      // print(_permissionStatus);
    });
  }


  @override
  void initState() {
    super.initState();
    requestPermission(Permission.location);
    requestPermission(Permission.storage);
    requestPermission(Permission.phone);


    Timer timer;
    int start = 0;
    int end = 0;
    bool first = true;
    int count = 0;
    int type = 0;

    int ROUND = 10;
    int val;
    // SensingGoFlutter.readFile();
    // SensingGoFlutter.writeFile_blank();
    SensingGoFlutter.sendFile();
    void _onaccEvent(Object event) {
      end = DateTime
          .now()
          .millisecondsSinceEpoch;
      val = end-start;
      _streamSubscription.cancel();
      print(val);
      if(count != ROUND){
        SensingGoFlutter.writeFile('$val');
        SensingGoFlutter.writeFile(',');
        count = count+1;
      }else{
        count = 0;
        SensingGoFlutter.writeFile('\n');
        print("typetype_ggggggggg");
        print(type);
        type = type+1;
      }
      //
      // if(type==8){
      //   timer.cancel();
      //   // SensingGoFlutter.sendFile();
      //   // initPlatformState();
      // }
    }

    timer = Timer.periodic(Duration(milliseconds: 500), (_) {

      if(type==0){
        first = true;
        start = DateTime.now().millisecondsSinceEpoch;
        Stream<dynamic> stream = SensingGoFlutter.accEvents;

        _streamSubscription = stream.listen(_onaccEvent);
      }
      else if(type==1){
        // if(count == 0) {
        //   SensingGoFlutter.writeFile('[');
        // }
        first = true;
        start = DateTime.now().millisecondsSinceEpoch;
        Stream<dynamic> stream = SensingGoFlutter.magmeterEvents;
        _streamSubscription = stream.listen(_onaccEvent);
      }
      else if(type==2){
        // if(count == 0) {
        //   SensingGoFlutter.writeFile('[');
        // }
        first = true;
        start = DateTime.now().millisecondsSinceEpoch;
        Stream<dynamic> stream = SensingGoFlutter.lightEvents;
        _streamSubscription = stream.listen(_onaccEvent);
      }

      //
      // else if(type==3){
      //
      //   first = true;
      //   start = DateTime.now().millisecondsSinceEpoch;
      //   Stream<dynamic> stream = SensingGoFlutter.screenState;
      //   _streamSubscription = stream.listen(_onaccEvent);
      // }
      else if(type==3){

        first = true;
        start = DateTime.now().millisecondsSinceEpoch;
        Stream<dynamic> stream = SensingGoFlutter.location;
        _streamSubscription = stream.listen(_onaccEvent);
      }
      else if(type==4){
        // if(count == 0) {
        //   SensingGoFlutter.writeFile('[');
        // }
        first = true;
        start = DateTime.now().millisecondsSinceEpoch;
        Stream<dynamic> stream = SensingGoFlutter.batteryState;
        _streamSubscription = stream.listen(_onaccEvent);
      }
      else if(type==5){
        // if(count == 0) {
        //   SensingGoFlutter.writeFile('[');
        // }
        first = true;
        start = DateTime.now().millisecondsSinceEpoch;
        Stream<dynamic> stream = SensingGoFlutter.proxiEvents;
        _streamSubscription = stream.listen(_onaccEvent);
      }


      else if(type==6){

        first = true;
        start = DateTime.now().millisecondsSinceEpoch;
        Stream<dynamic> stream = SensingGoFlutter.cellularinfo;
        _streamSubscription = stream.listen(_onaccEvent);
      }
      else if(type==7){

        first = true;
        start = DateTime.now().millisecondsSinceEpoch;
        Stream<dynamic> stream = SensingGoFlutter.phonestate;
        _streamSubscription = stream.listen(_onaccEvent);
      }
      else if(type==8){

        first = true;
        start = DateTime.now().millisecondsSinceEpoch;
        Stream<dynamic> stream = SensingGoFlutter.screenState;
        _streamSubscription = stream.listen(_onaccEvent);
      }
    });
  }


  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String sen;
    String wifi,battery,cellular;
    int start,end;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // platformVersion = await SensingGoFlutter.platformVersion;
      for (int i = 0; i < 3; i++) {
        start = DateTime.now().millisecondsSinceEpoch;
        // wifi = (await SensingGoFlutter.cellular_ios) as String;
        end = DateTime.now().millisecondsSinceEpoch;
        print(i);
        print(end-start);
      }
      for (int i = 0; i < 3; i++) {
        start = DateTime.now().millisecondsSinceEpoch;
        wifi = (await SensingGoFlutter.wifi) as String;
        end = DateTime.now().millisecondsSinceEpoch;
        print(i);
        print(end-start);
      }
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      // _sen =sen;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          // child: Text('Running on: $_platformVersion\n'),
          child: Text('Running on: $_sen\n'),
        ),

      ),
    );
  }

}
