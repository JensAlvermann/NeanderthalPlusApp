
//
//  Copyright 2010 Mirasense AG
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//

package com.mirasense.scanditsdk.plugin;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.util.Log;
import android.view.Display;
import android.view.Window;
import android.view.WindowManager;

import com.scandit.barcodepicker.OnScanListener;
import com.scandit.barcodepicker.ScanSession;
import com.scandit.barcodepicker.ScanSettings;
import com.scandit.base.util.JSONParseException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


/**
 * Activity integrating the barcode scanner.
 *
 */
public class ScanditSDKActivity extends Activity implements OnScanListener, SearchBarBarcodePicker.ScanditSDKSearchBarListener {
    
    public static final int CANCEL = 0;
    public static final int SCAN = 1;
    public static final int MANUAL = 2;

    private static ScanditSDKActivity sActiveActivity = null;

    private SearchBarBarcodePicker mBarcodePicker;
    private boolean mContinuousMode = false;

    private boolean mStartPaused = false;

    private boolean mLegacyMode = false;
    
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        JSONObject settings = null;
        Bundle options = null;
        Bundle overlayOptions = null;

        if (getIntent().getExtras().containsKey("settings")) {
            try {
                settings = new JSONObject(getIntent().getExtras().getString("settings"));
            } catch (JSONException e) {
                e.printStackTrace();
            }
            mLegacyMode = false;
        } else {
            mLegacyMode = true;
        }
        if (getIntent().getExtras().containsKey("options")) {
            options = getIntent().getExtras().getBundle("options");
        }
        if (getIntent().getExtras().containsKey("overlayOptions")) {
            overlayOptions = getIntent().getExtras().getBundle("overlayOptions");
        }

        initializeAndStartBarcodeRecognition(settings, options, overlayOptions);
    }
    
    @SuppressWarnings("deprecation")
    public void initializeAndStartBarcodeRecognition(
            JSONObject settings, Bundle options, Bundle overlayOptions) {
        // Switch to full screen.
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        requestWindowFeature(Window.FEATURE_NO_TITLE);

        ScanSettings scanSettings;
        if (mLegacyMode) {
            scanSettings = LegacySettingsParamParser.getSettings(options);
        } else {
            try {
                scanSettings = ScanSettings.createWithJson(settings);
            } catch (JSONParseException e) {
                Log.e("ScanditSDK", "Exception when creating settings");
                e.printStackTrace();
                scanSettings = ScanSettings.create();
            }
        }
        mBarcodePicker = new SearchBarBarcodePicker(this, scanSettings);
        mBarcodePicker.setOnScanListener(this);

        this.setContentView(mBarcodePicker);

        // Set all the UI options.
        PhonegapParamParser.updatePicker(mBarcodePicker, options, this);

        if (settings == null) {
            LegacyUIParamParser.updatePickerUI(this, mBarcodePicker, options);
        } else {
            UIParamParser.updatePickerUI(mBarcodePicker, overlayOptions);
            PhonegapParamParser.updatePicker(mBarcodePicker, overlayOptions, this);
        }

        if (options.containsKey(PhonegapParamParser.paramContinuousMode)) {
            mContinuousMode = options.getBoolean(PhonegapParamParser.paramContinuousMode);
        }

        if (options.containsKey(PhonegapParamParser.paramPaused)
                && options.getBoolean(PhonegapParamParser.paramPaused)) {
            mStartPaused = true;
        } else {
            mStartPaused = false;
        }
    }
    
    @Override
    protected void onPause() {
        sActiveActivity = null;
        // When the activity is in the background immediately stop the
        // scanning to save resources and free the camera.
        mBarcodePicker.stopScanning();
        super.onPause();
    }
    
    @Override
    protected void onResume() {
        // Once the activity is in the foreground again, restart scanning.
        mBarcodePicker.startScanning(mStartPaused);
        sActiveActivity = this;
        super.onResume();
    }

    public void pauseScanning() {
        mBarcodePicker.pauseScanning();
    }

    public void resumeScanning() {
        mBarcodePicker.resumeScanning();
        mStartPaused = false;
    }

    public void stopScanning() {
        mBarcodePicker.stopScanning();
    }

    public void startScanning() {
        mBarcodePicker.startScanning();
        mStartPaused = false;
    }
    
    public void switchTorchOn(boolean enabled) {
        mBarcodePicker.switchTorchOn(enabled);
    }

    public void didCancel() {
        mBarcodePicker.stopScanning();

        setResult(CANCEL);
        finish();
    }

    @Override
    public void didScan(ScanSession session) {
        if (session.getNewlyRecognizedCodes().size() > 0) {
            if (!mContinuousMode) {
                session.stopScanning();

                Intent intent = new Intent();
                if (mLegacyMode) {
                    intent.putExtra("barcode", session.getNewlyRecognizedCodes().get(0).getData());
                    intent.putExtra("symbology",
                            session.getNewlyRecognizedCodes().get(0).getSymbologyName());
                } else {
                    intent.putExtra("jsonString", ScanditSDKResultRelay.jsonForSession(session).toString());
                }
                setResult(SCAN, intent);
                finish();
            } else {
                Bundle bundle = new Bundle();
                if (mLegacyMode) {
                    bundle.putString("barcode", session.getNewlyRecognizedCodes().get(0).getData());
                    bundle.putString("symbology",
                            session.getNewlyRecognizedCodes().get(0).getSymbologyName());
                } else {
                    bundle.putString("jsonString", ScanditSDKResultRelay.jsonForSession(session).toString());
                }
                ScanditSDKResultRelay.onResult(bundle);
            }
        }
    }

    @Override
    public void didEnter(String entry) {
        if (!mContinuousMode) {
            Intent intent = new Intent();
            if (mLegacyMode) {
                intent.putExtra("barcode", entry.trim());
                intent.putExtra("symbology", "UNKNOWN");
            } else {
                intent.putExtra("string", entry.trim());
            }
            setResult(MANUAL, intent);
            finish();
        } else {
            Bundle bundle = new Bundle();
            if (mLegacyMode) {
                bundle.putString("barcode", entry.trim());
                bundle.putString("symbology", "UNKNOWN");
            } else {
                bundle.putString("string", entry.trim());
            }
            ScanditSDKResultRelay.onResult(bundle);
        }
    }
    
    @Override
    public void onBackPressed() {
        didCancel();
    }

    public static void cancel() {
        if (sActiveActivity != null) {
            sActiveActivity.didCancel();
        }
    }

    public static void pause() {
        if (sActiveActivity != null) {
            sActiveActivity.pauseScanning();
        }
    }

    public static void resume() {
        if (sActiveActivity != null) {
            sActiveActivity.resumeScanning();
        }
    }

    public static void stop() {
        if (sActiveActivity != null) {
            sActiveActivity.stopScanning();
        }
    }

    public static void start() {
        if (sActiveActivity != null) {
            sActiveActivity.startScanning();
        }
    }
    
    public static void torch(boolean enabled) {
        if (sActiveActivity != null) {
            sActiveActivity.switchTorchOn(enabled);
        }
    }
}
