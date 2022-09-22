package com.example.check_developer_main;

import android.Manifest;
import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.IBinder;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "checkmepro.connection";
    private static final String STREAM  = "checkmepro.listener";
    private BluetoothAdapter mBtAdapter;
    private boolean isBtEnabled = false;
    private boolean isConnected = false;

    private EventChannel.EventSink eventSink;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mBtAdapter = BluetoothAdapter.getDefaultAdapter();

        if( mBtAdapter.isEnabled() ){
            isBtEnabled = true;
        }
    }

    @SuppressLint("MissingPermission")
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
                (call, result) -> {
                    if( "checkmepro/btEnabled" == call.method ){
                        // MARK: bt Enabled
                        result.success( isBtEnabled );
                    } else if( "checkmepro/startScan" == call.method ){
                        // MARK: StartScan
                         mBtAdapter.startDiscovery();
                        result.success("checkmepro/startScan");
                    }else if( "checkmepro/stopScan" == call.method ){
                        // MARK: StopScan
                        mBtAdapter.cancelDiscovery();
                        result.success("checkmepro/stopScan");
                    }else if( "checkmepro/connectTo" == call.method ){
                        // MARK: Connect to

                        result.success("checkmepro/connecting");
                    }else if( "checkmepro/disconnect" == call.method ){
                        // MARK: status
                        result.success( isConnected );
                    }else if( "checkmepro/isConnected" == call.method ){
                        // MARK: status
                        result.success( isConnected );
                    }else if( "checkmepro/beginGetInfo" == call.method ){
                        // MARK: begin get info device
                    } else if( "checkmepro/getInfoCheckmePRO" == call.method ){
                        // MARK: set info
                    }else if( "checkmepro/beginSyncTime" == call.method ){
                        // MARK: sync Time
                    }else if( "checkmepro/beginReadFileList" == call.method ){
                        // MARK: begin read File
                    }else if( "checkmepro/beginReadFileListDetailsECG" == call.method ){
                        // MARK: begin read details ECG
                    }else{
                        // not implemented
                        result.notImplemented();
                    }
                }
        );

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STREAM).setStreamHandler(
            new EventChannel.StreamHandler() {
                @Override
                public void onListen(Object args, EventChannel.EventSink events) {
                    eventSink = events;
                }

                @Override
                public void onCancel(Object args) {
                    eventSink = null;
                }
            }
        );
    }

    private final BroadcastReceiver mReceiver = new BroadcastReceiver() {
        @SuppressLint("MissingPermission")
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();

            if (BluetoothDevice.ACTION_FOUND.equals(action)) {
                BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);

                if( device.getName().contains("Checkme") ){
                    eventSink.success("Device Found " + device.getName() );
                }

            }

            // Estado de bluetooth
            if( BluetoothDevice.ACTION_BOND_STATE_CHANGED.equals( action ) ){
                int stateBT = intent.getIntExtra( BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR );

                switch ( stateBT ){
                    case BluetoothAdapter.STATE_ON:
                        isBtEnabled = true;
                        eventSink.success("Enviar bt on");
                        break;
                    case BluetoothAdapter.STATE_OFF:
                        isBtEnabled = false;
                        eventSink.success("Enviar bt off");
                        break;
                }
            }
        }
    };
}
