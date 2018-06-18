
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

import android.os.Bundle;

import com.scandit.barcodepicker.ScanSession;
import com.scandit.recognition.Barcode;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

public class ScanditSDKResultRelay {
    
    private static ScanditSDKResultRelayCallback mCallback;
    
    public static void setCallback(ScanditSDKResultRelayCallback callback) {
        mCallback = callback;
    }
    
    public static void onResult(Bundle bundle) {
        if (mCallback != null) {
            mCallback.onResultByRelay(bundle);
        }
    }

    public static JSONObject jsonForSession(ScanSession session) {
        JSONObject json = new JSONObject();
        try {
            json.put("newlyRecognizedCodes", jsonForCodes(session.getNewlyRecognizedCodes()));
            json.put("newlyLocalizedCodes", jsonForCodes(session.getNewlyLocalizedCodes()));
            json.put("allRecognizedCodes", jsonForCodes(session.getAllRecognizedCodes()));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return json;
    }

    public static JSONArray jsonForCodes(List<Barcode> codes) {
        JSONArray array = new JSONArray();

        for (Barcode code : codes) {
            JSONObject object = new JSONObject();
            try {
                object.put("symbology", code.getSymbologyName());
                object.put("gs1DataCarrier", code.isGs1DataCarrier());
                object.put("recognized", code.isRecognized());
                object.put("data", code.getData());
                array.put(object);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return array;
    }
    
    public interface ScanditSDKResultRelayCallback {
        void onResultByRelay(Bundle bundle);
    }
}
