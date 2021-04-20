package com.example.sensingGo_flutter.sensing.Measurement;


import android.Manifest;
import android.app.ActivityManager;
import android.content.Context;
import android.content.pm.PackageManager;
import android.hardware.SensorManager;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.widget.TextView;

import androidx.core.content.ContextCompat;

import com.example.sensingGo_flutter.sensing.Data.DataListener;
import com.example.sensingGo_flutter.sensing.Data.DataListenerInterface;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.lang.ref.WeakReference;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;

import static android.content.Context.ACTIVITY_SERVICE;
import static android.content.Context.SENSOR_SERVICE;

public class PhoneState  extends PhoneStateListener {
    private Context mContext;
    private EventChannel.EventSink eve;
    HashMap<String, String> PhoneStateMap = new HashMap<String, String>();
    public static String phoneState = "IDLE"; //IDLE, OFFHOOK, RINGING
    public static String callState = "IDLE"; //Callout, ""Callin"", RINGING
    public static String callID = "null";
    public static String startCallTime, endCallTime;

    public static int callNum = 0, callExcessNum = 0;
    public static long callStartAt = 0, callHoldingTime = 0, excessLife = 0;
    public static double avgCallHoldTime = 0, avgExcessLife = 0;
    public static double ttlCallHoldTime = 0, ttlExcessLife = 0;
    public static boolean FirstCallCell = false;

    private TelephonyManager teleManger;
    public PhoneState (Context context) {
        initBfRun();
        this.mContext = context;
        teleManger = (TelephonyManager) mContext.getSystemService(Context.TELEPHONY_SERVICE);
    }
    public void start(EventChannel.EventSink events) {
        this.eve = events;
        teleManger.listen(this, LISTEN_CALL_STATE);
    }
    public void stop() {
        teleManger.listen(this, LISTEN_NONE);
    }
    @Override
    public void onCallStateChanged(final int state, String incomingNumber) {
        super.onCallStateChanged(state, incomingNumber);
        switch (state) {
            case TelephonyManager.CALL_STATE_IDLE:
                // OFFHOOK: At least one call exists that is dialing, active, or on hold, and no calls are ringing or waiting.
                if (phoneState.equals("OFFHOOK")) {
                    callHoldingTime = System.currentTimeMillis() - callStartAt;
                    ttlCallHoldTime = ttlCallHoldTime + callHoldingTime;
                }
                phoneState = "IDLE";
                phoneState = "IDLE";
                callState = "IDLE";
                FirstCallCell = false;
                break;

            case TelephonyManager.CALL_STATE_OFFHOOK:
                if (phoneState.equals("IDLE")) {
                    callState = "Callout";
                    Log.i("phoneState","Callout");
                }
                if (phoneState.equals("RINGING")) {
                    callState = "Callin";
                    Log.i("phoneState","Callin");
                }
                callNum = callNum + 1;
                callStartAt = System.currentTimeMillis();
                FirstCallCell = true;
                phoneState = "OFFHOOK";
                break;

            case TelephonyManager.CALL_STATE_RINGING:
                phoneState = "RINGING";
                callState = "RINGING";
                break;
        }
        PhoneStateMap.put("phoneState", String.valueOf(PhoneState.phoneState));
        PhoneStateMap.put("callState", String.valueOf(PhoneState.callState));
        PhoneStateMap.put("callID", String.valueOf(PhoneState.callID));
        PhoneStateMap.put("startCallTime", String.valueOf(PhoneState.startCallTime));
        PhoneStateMap.put("endCallTime", String.valueOf(PhoneState.endCallTime));
        PhoneStateMap.put("callNum", String.valueOf(PhoneState.callNum));
        PhoneStateMap.put("callExcessNum", String.valueOf(PhoneState.callExcessNum));
        PhoneStateMap.put("callStartAt", String.valueOf(PhoneState.callStartAt));
        PhoneStateMap.put("callHoldingTime", String.valueOf(PhoneState.callHoldingTime));
        PhoneStateMap.put("avgCallHoldTime", String.valueOf(PhoneState.avgCallHoldTime));
        PhoneStateMap.put("avgExcessLife", String.valueOf(PhoneState.avgExcessLife));
        PhoneStateMap.put("ttlExcessLife", String.valueOf(PhoneState.ttlExcessLife));
        PhoneStateMap.put("ttlCallHoldTime", String.valueOf(PhoneState.ttlCallHoldTime));
        PhoneStateMap.put("FirstCallCell", String.valueOf(PhoneState.FirstCallCell));

        eve.success(PhoneStateMap);

    }

    public static void calculateAvg() {
        if (callNum != 0) {
            avgCallHoldTime = ttlCallHoldTime / callNum;
        }
        if (callExcessNum != 0) {
            avgExcessLife = ttlExcessLife / callExcessNum;
        }
    }

    private void initBfRun() {
        avgCallHoldTime = 0;
        avgExcessLife = 0;
        callNum = 0;
        callExcessNum = 0;
        callStartAt = 0;
        callHoldingTime = 0;
        excessLife = 0;
        ttlCallHoldTime = 0;
        ttlExcessLife = 0;
        FirstCallCell = false;
    }
}
