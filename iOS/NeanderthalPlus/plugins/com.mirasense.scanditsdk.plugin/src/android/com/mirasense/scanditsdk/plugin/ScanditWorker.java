package com.mirasense.scanditsdk.plugin;

import android.os.Handler;
import android.os.HandlerThread;

/**
 * Created by mo on 10/12/15.
 */
public class ScanditWorker extends HandlerThread {

    private Handler mHandler;

    public ScanditWorker() {
        super("ScanditWorker");
    }

    @Override
    public void start() {
        super.start();
        mHandler = new Handler(getLooper());
    }

    public Handler getHandler() {
        return mHandler;
    }
}
