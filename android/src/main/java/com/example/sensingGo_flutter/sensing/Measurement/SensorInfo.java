package com.example.sensingGo_flutter.sensing.Measurement;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.Handler;
import android.util.Log;
import android.widget.TextView;

import androidx.annotation.RequiresApi;

import com.example.sensingGo_flutter.sensing.Data.DataListener;
import com.example.sensingGo_flutter.sensing.Data.DataListenerInterface;
import com.example.sensingGo_flutter.sensing.Data.SGData;

import java.util.HashMap;
import java.util.Timer;
import java.util.TimerTask;

import io.flutter.plugin.common.EventChannel;

import static android.content.Context.SENSOR_SERVICE;

public class SensorInfo implements SensorEventListener {

    private SensorManager sensorManager;
    private EventChannel.EventSink eve;

    public static float[] gSensorValues = new float[3]; // triaxial acceleration
    public static float[] magneticValues = new float[3];
    public static int lightValue;
    private static int sensorInterval;
    public static String proximityValue;
    public static float pressureValue,pvalue;
    private float[] rMatrix = new float[9];    //rotation matrix

    // orientation values, [0]: Azimuth, [1]: Pitch, [2]: Roll
    public static float[] orienValue = new float[3];

 //    private SGData sg_data;
    public Context mContext;
    public  TextView tt;
    public DataListenerInterface dataListenerInterface;
    public SensorInfo(Context mContext) {
        this.mContext = mContext;
        this.sensorManager = (SensorManager)mContext.getSystemService(SENSOR_SERVICE);
        initBfRun();
    }
    private SensorInfo SensorInfo;

    private  void initBfRun() {
        SensorInfo = this;
        gSensorValues[0] = gSensorValues[1] = gSensorValues[2] = 10;
        magneticValues[0] = magneticValues[1] = magneticValues[2] = 0;
        orienValue[0] = orienValue[1] = orienValue[2] = 0;
        lightValue = -1;
        proximityValue = "near";
        pressureValue = 0;

    }
    public void stop() {
        // Accelerometer, Light, Proximity, Barometer, Magnetometer
        sensorManager.unregisterListener(this);
    }
    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    public void startService_acc(EventChannel.EventSink events) {
        this.eve = events;
        Sensor mAccelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        if (mAccelerometer == null){
            //No Accelerometer Sensor!
            Log.i("ssssss","No Accelerometer Sensor!");
        } else{
            sensorManager.registerListener(this, mAccelerometer,SensorManager.SENSOR_DELAY_FASTEST);
        }
    }
    public void startService_Proximity( EventChannel.EventSink events) {
        this.eve = events;
        Sensor mProximity = sensorManager.getDefaultSensor(Sensor.TYPE_PROXIMITY);
        if (mProximity == null){
            //No Proximity Sensor!
            Log.i("ssssss","No Proximity Sensor!");
        } else{
            sensorManager.registerListener(this, mProximity, SensorManager.SENSOR_DELAY_FASTEST);
        }

    }
    public void startService_LIGHT( EventChannel.EventSink events) {
        this.eve = events;
        Sensor mLight = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT);
        if (mLight == null){
            //No mLight Sensor!
            Log.i("ssssss","No mLight Sensor!");
        } else{
            sensorManager.registerListener(this, mLight, SensorManager.SENSOR_DELAY_FASTEST);
        }

    }
    public void startService_PRESSURE( EventChannel.EventSink events) {
        this.eve = events;
        Sensor mPressure = sensorManager.getDefaultSensor(Sensor.TYPE_PRESSURE);
        if (mPressure == null){
            //No mPressure Sensor!
            Log.i("ssssss","No mPressure Sensor!");
        } else{
            sensorManager.registerListener(this, mPressure, SensorManager.SENSOR_DELAY_FASTEST);
        }

    }
    public void startService_MAG( EventChannel.EventSink events) {
        this.eve = events;
        Sensor mMagnetic = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
        if (mMagnetic == null){
            //No mMagnetic Sensor!
            Log.i("ssssss","No mMagnetic Sensor!");
        } else{
            sensorManager.registerListener(this, mMagnetic, SensorManager.SENSOR_DELAY_FASTEST);
        }
    }
//    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
//    public void startService_GYRO( EventChannel.EventSink events) {
//        this.eve = events;
//        Sensor mMagnetic = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
//        if (mMagnetic == null){
//            //No mMagnetic Sensor!
//            Log.i("ssssss","No mMagnetic Sensor!");
//        } else{
//            sensorManager.registerListener(this, mMagnetic, SensorManager.SENSOR_DELAY_FASTEST);
//        }
//        Sensor mAccelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
//        if (mAccelerometer == null){
//            //No Accelerometer Sensor!
//            Log.i("ssssss","No Accelerometer Sensor!");
//        } else{
//            sensorManager.registerListener(this, mAccelerometer, sensorInterval,sensorInterval);
//        }
//    }

    @Override
    public void onSensorChanged(final SensorEvent event) {
        // TODO Auto-generated method stub
        switch (event.sensor.getType()) {
            case Sensor.TYPE_ACCELEROMETER:
                 HashMap<String, String> accMap = new HashMap<String, String>();
                accMap.put("X",String.valueOf(event.values[0]));
                accMap.put("Y",String.valueOf(event.values[1]));
                accMap.put("Z",String.valueOf(event.values[2]));
                eve.success(accMap);
                break;

            case Sensor.TYPE_PROXIMITY:
                eve.success(String.valueOf(event.values[0]));
                break;

            case Sensor.TYPE_LIGHT:
                eve.success(String.valueOf(event.values[0]));
                break;

            case Sensor.TYPE_PRESSURE:
                eve.success(String.valueOf(event.values[0]));
                break;

            case Sensor.TYPE_MAGNETIC_FIELD: // Measures the ambient geomagnetic field for all three physical axes (x, y, z) in 弮T.
                HashMap<String, String> magMap = new HashMap<String, String>();
                magMap.put("X",String.valueOf(event.values[0]));
                magMap.put("Y",String.valueOf(event.values[1]));
                magMap.put("Z",String.valueOf(event.values[2]));
                eve.success(magMap);
                break;
        }

    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
        // TODO Auto-generated method stub
    }
}
