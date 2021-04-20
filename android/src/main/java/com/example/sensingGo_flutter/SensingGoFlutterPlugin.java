package com.example.sensingGo_flutter;

import android.content.Context;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.example.sensingGo_flutter.sensing.Data.DataListener;
import com.example.sensingGo_flutter.sensing.FileMaker.writeFile;
import com.example.sensingGo_flutter.sensing.FileSender.sendData;
import com.example.sensingGo_flutter.sensing.Measurement.BatteryState;
import com.example.sensingGo_flutter.sensing.Measurement.CellularInfo;
import com.example.sensingGo_flutter.sensing.Measurement.LocationInfo;
import com.example.sensingGo_flutter.sensing.Measurement.NetworkState;
import com.example.sensingGo_flutter.sensing.Measurement.PhoneInfo;
import com.example.sensingGo_flutter.sensing.Measurement.PhoneState;
import com.example.sensingGo_flutter.sensing.Measurement.ScreenState;
import com.example.sensingGo_flutter.sensing.Measurement.SensorInfo;
import com.example.sensingGo_flutter.sensing.Measurement.WiFiInfo;

import java.io.IOException;
import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** SensingGoFlutterPlugin */
public class SensingGoFlutterPlugin implements FlutterPlugin, MethodCallHandler{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private static final String ACCELEROMETER_CHANNEL_NAME =
          "plugins.flutter.io/sensors/acc";
  private static final String MAGMETER_CHANNEL_NAME =
          "plugins.flutter.io/sensors/magmeter";
  private static final String PROXI_CHANNEL_NAME =
          "plugins.flutter.io/sensors/proxi";
  private static final String LIGHT_CHANNEL_NAME =
          "plugins.flutter.io/sensors/light";
  private static final String LOCATION_CHANNEL_NAME =
          "plugins.flutter.io/location";
  private static final String LOCATION_CHANNEL_GPS_NAME =
          "plugins.flutter.io/location_gps";
  private static final String CELLULARINFO_CHANNEL_NAME = "plugins.flutter.io/cellularInfo";
  private static final String PHONEINFO_CHANNEL_NAME = "plugins.flutter.io/phoneInfo";
  private static final String PHONESTATE_CHANNEL_NAME = "plugins.flutter.io/phoneState";
  private static final String BATTERYSTATE_CHANNEL_NAME = "plugins.flutter.io/batteryState";
  private static final String SCREENSTATE_CHANNEL_NAME = "plugins.flutter.io/screenState";
  private EventChannel accelerometerChannel, magmeterChannel, proxiChannel, lightChannel,locationChannel,locationChannel_gps,
          cellularInfoChannel,phoneStateChannel, batteryStateChannel,screenStateChannel;

  private SensorManager mSensorManager;

  private SensorEventListener sensorEventListener;
  private Context context;
  private static FlutterPluginBinding mflutterPluginBinding;


  private EventChannel.EventSink eve;
  private SensorInfo sensorInfo;
  private CellularInfo cellularInfo;
  private LocationInfo loc;
  private NetworkState networkState;
  private PhoneInfo phoneInfo;
  private PhoneState phoneState;
  private BatteryState batteryState;
  private ScreenState screenState;

  private WiFiInfo wifiInfo;
  HashMap<String, String> wifiInfoMap = new HashMap<String, String>();

  String Networktype;
  HashMap<String, String> NetworktypeMap = new HashMap<String, String>();
  HashMap<String, String> CellularMap = new HashMap<String, String>();
  HashMap<String, String> PhoneStateMap = new HashMap<String, String>();
  HashMap<String, String>  phoneInfoMap = new HashMap<String, String>();
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "sensingGo_flutter");
    channel.setMethodCallHandler(this);

    accelerometerChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), ACCELEROMETER_CHANNEL_NAME);
    magmeterChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), MAGMETER_CHANNEL_NAME);
    proxiChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), PROXI_CHANNEL_NAME);
    lightChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), LIGHT_CHANNEL_NAME);
    locationChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), LOCATION_CHANNEL_NAME);
    locationChannel_gps = new EventChannel(flutterPluginBinding.getBinaryMessenger(), LOCATION_CHANNEL_GPS_NAME);
//    phoneInfoChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), PHONEINFO_CHANNEL_NAME);
    phoneStateChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), PHONESTATE_CHANNEL_NAME);
    cellularInfoChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), CELLULARINFO_CHANNEL_NAME);
    batteryStateChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), BATTERYSTATE_CHANNEL_NAME);
    screenStateChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), SCREENSTATE_CHANNEL_NAME);
    sensorInfo =  new SensorInfo(context);
    phoneState = new PhoneState(context);
    screenState = new ScreenState(context);
    batteryState = new BatteryState(context);
    cellularInfo = new CellularInfo(context);
    wifiInfo = new WiFiInfo(context);

    networkState = new NetworkState(context);
    Networktype = networkState.getNetworkType();
    loc = new LocationInfo(context);

    batteryStateChannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object arguments, final EventChannel.EventSink events) {
        Log.i("phoneInfoChannel", "out");
        batteryState.start( events);
      }
      @Override
      public void onCancel(Object arguments) {
        batteryState.stop();
      }
    });
    screenStateChannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object arguments, final EventChannel.EventSink events) {
        screenState.start( events);
      }
      @Override
      public void onCancel(Object arguments) {
        screenState.stop();
      }
    });
    cellularInfoChannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object arguments, final EventChannel.EventSink events) {
        cellularInfo.start(events);
      }
      @Override
      public void onCancel(Object arguments) {
        cellularInfo.stop();
      }
    });
    phoneStateChannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object arguments, final EventChannel.EventSink events) {
        phoneState.start(events);
      }
      @Override
      public void onCancel(Object arguments) {
        phoneState.stop();
      }
    });
    locationChannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object arguments, final EventChannel.EventSink events) {
        loc.startNetwork_location(events);

      }

      @Override
      public void onCancel(Object arguments) {
        loc.stopNetwork_location();
      }
    });
    locationChannel_gps.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object arguments, final EventChannel.EventSink events) {
        loc.startGPS_location(events);

      }

      @Override
      public void onCancel(Object arguments) {
        loc.stopGPS_location();
      }
    });
    accelerometerChannel.setStreamHandler(
            new EventChannel.StreamHandler() {
              @RequiresApi(api = Build.VERSION_CODES.KITKAT)
              @Override
              public void onListen(Object arguments, final EventChannel.EventSink events) {
                sensorInfo.startService_acc(events);
              }

              @Override
              public void onCancel(Object arguments) {
                sensorInfo.stop();
              }
            }
    );
    magmeterChannel.setStreamHandler(
            new EventChannel.StreamHandler() {
              @Override
              public void onListen(Object arguments, final EventChannel.EventSink events) {
                sensorInfo.startService_MAG(events);
              }

              @Override
              public void onCancel(Object arguments) {
                sensorInfo.stop();
              }
            }
    );
    proxiChannel.setStreamHandler(
            new EventChannel.StreamHandler() {
              @Override
              public void onListen(Object arguments, final EventChannel.EventSink events) {
                sensorInfo.startService_Proximity(events);
              }

              @Override
              public void onCancel(Object arguments) {
                sensorInfo.stop();
              }
            }
    );
    lightChannel.setStreamHandler(
            new EventChannel.StreamHandler() {
              @Override
              public void onListen(Object arguments, final EventChannel.EventSink events) {
//                        events.success("hahah");
//                  Log.i("qqqqLocationIn","qqqqqrr");
                sensorInfo.startService_LIGHT(events);
              }

              @Override
              public void onCancel(Object arguments) {
                sensorInfo.stop();
              }
            }
    );


  }

  @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
      return;
    }
       if (call.method.equals("plugins.flutter.io/wifi")) {
//      double reading = getBarometer();
      Log.i("wifiInfoggg","qqqqqrr");
      wifiInfo.getWiFiInfo();
      wifiInfoMap.put("servingIP",String.valueOf(WiFiInfo.servingIP));
      wifiInfoMap.put("servingSSID",String.valueOf(WiFiInfo.servingSSID));
      wifiInfoMap.put("servingBSSID",String.valueOf(WiFiInfo.servingBSSID));
      wifiInfoMap.put("servingMAC",String.valueOf(WiFiInfo.servingMAC));
      wifiInfoMap.put("servingLevel",String.valueOf(WiFiInfo.servingLevel));
      result.success(wifiInfoMap);
      return;
    }
    if (call.method.equals("plugins.flutter.io/networkstate")) {
      NetworktypeMap.put("status",String.valueOf(networkState.isNetworkAvailable()));
      NetworktypeMap.put("type",String.valueOf(networkState.getNetworkType()));
      result.success(NetworktypeMap);
      return;
    }
    if (call.method.equals("plugins.flutter.io/phoneInfo")) {
      //        Log.d("dddddddd",phoneInfo.cpuInfo());
      try {
        phoneInfoMap.put("CPU",String.valueOf(phoneInfo.cpuInfo()));
      } catch (IOException e) {
        e.printStackTrace();
      }
      result.success(phoneInfoMap);
      return;
    }

    if (call.method.equals("plugins.flutter.io/writeFile")) {
      writeFile write_file = null;
      try {
        write_file = new writeFile(context);
      } catch (IOException e) {
        e.printStackTrace();
      }
      write_file.setUserID("android_flu");
      String info = call.argument("info");
      try {
        write_file.write2(info);
      } catch (IOException e) {
        e.printStackTrace();
      }
      return;
    }
    if (call.method.equals("plugins.flutter.io/sendFile")) {
      sendData s = new sendData(context);
      s.setUserID("android_flu");
      s.execute();
    }
    result.notImplemented();
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
