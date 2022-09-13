

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
//import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothProvider with ChangeNotifier{

  // FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  // BluetoothDevice? _bluetoothDevice;

  // BluetoothDevice? get bluetoothDevice => _bluetoothDevice;

  // StreamSubscription<ScanResult>? scanSubscription;
  // StreamSubscription<BluetoothDeviceState>? deviceStateSubscription;
  
  // List<BluetoothDevice> devices = [];

  // set bluetoothDevice(BluetoothDevice? bluetoothDevice) {
  //   _bluetoothDevice = bluetoothDevice;
  //   connectToDevice();
  //   notifyListeners();
  // }

  // startScan()async{
  //   devices = [];

  //   scanSubscription = flutterBlue.scan().listen((event) { 
  //     if( event.device.name.contains("Checkme") && !devices.contains( event.device )){
  //       devices.add( event.device );
  //       log( 'NAME: ${event.device.name}' );
  //       log( 'RSSI: ${event.rssi}' );
  //       notifyListeners();      
  //     }
  //   });
  // }

  // terminateConnection(){
  //   flutterBlue.stopScan();
  //   scanSubscription?.cancel();
  //   deviceStateSubscription?.cancel();
  //   bluetoothDevice?.disconnect();
  // }

  // connectToDevice()async{
  //   await bluetoothDevice?.connect( autoConnect: true );
  //   deviceStateSubscription = bluetoothDevice?.state.listen((event) { 
  //     log('Device State: $event');

  //     if( event == BluetoothDeviceState.disconnected ){
  //       deviceStateSubscription?.cancel();
  //     }
  //   });
  // }

}