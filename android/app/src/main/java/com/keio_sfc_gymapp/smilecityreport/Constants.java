package com.keio_sfc_gymapp.smilecityreport;

import android.content.Context;
import android.content.SharedPreferences;

import java.util.UUID;

public class Constants {
    static final String IS_STUDY = "isStudy";
    static final String IN_PROGRESS = "Initializing AWARE...";
    static final String INIT_CHNL_ID = "init_chnl_id";
    static final int INIT_NOTIF_ID = 1234;
    static final String TAG = "smile_x";
    static final String CONFIG_BASE_PATH = "com.smilex.gymapp.preference";
    static final String ACTION_FIRST_RUN = "ACTION_FIRST_RUN";
    static final String ACTION_IS_STUDY = "ACTION_IS_STUDY";
    static final String FLUTTER_IS_STUDY = "FLUTTER_IS_STUDY";
    static final String STUDY_LINK = "https://aware.keio-sfc-gymapp.com/index.php/webservice/index/1/hjkmKPb7nM";

    static public String getDeviceId(Context context){
        SharedPreferences sharedPref = context.getSharedPreferences(Constants.CONFIG_BASE_PATH, Context.MODE_PRIVATE);
        String deviceId = sharedPref.getString(Constants.CONFIG_BASE_PATH+".device_id", null);
        if (deviceId == null) {
            String newDeviceId = UUID.randomUUID().toString();
            SharedPreferences.Editor editor = sharedPref.edit();
            editor.putString(CONFIG_BASE_PATH+".device_id", newDeviceId);
            editor.commit();
            return newDeviceId;
        }else{
            return deviceId;
        }
    }
}