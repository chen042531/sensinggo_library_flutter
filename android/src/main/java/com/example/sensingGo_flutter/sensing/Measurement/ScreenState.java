package com.example.sensingGo_flutter.sensing.Measurement;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;

public class ScreenState extends BroadcastReceiver {


    public static String screen_state = "on";

    public Context mContext;
    private EventChannel.EventSink eve;

    public ScreenState(Context mContext) {
        this.mContext = mContext;
    }
    public void start(EventChannel.EventSink events) {
        this.eve = events;
        IntentFilter intentFilter = new IntentFilter(Intent.ACTION_SCREEN_ON);
        intentFilter.addAction(Intent.ACTION_SCREEN_OFF);
        mContext.registerReceiver(this, intentFilter);
    }
    public void stop() {
        mContext.unregisterReceiver(this);
    }
    @Override
    public void onReceive(Context context, Intent intent) {


        String action = intent.getAction();
        if (Intent.ACTION_SCREEN_ON.equals(action)) {
            screen_state = "on";
        }
        else if (Intent.ACTION_SCREEN_OFF.equals(action)) {
            screen_state = "off";
        }
        HashMap<String, String> ScreenStateMap = new HashMap<String, String>();
        ScreenStateMap.put("screen_state",String.valueOf(screen_state));
        eve.success(ScreenStateMap);
    }
}
