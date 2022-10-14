import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothProvider with ChangeNotifier{

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  StreamSubscription<BluetoothState>? btStateSuscription;
  bool _isEnabled = false;

  bool get isEnabled => _isEnabled;

  set isEnabled(bool isEnabled) {
    _isEnabled = isEnabled;
    notifyListeners();
  }

  BluetoothProvider(){
    _isEnabled = false;
    initSubscription();
  }

  Future<void>initSubscription() async {

    await finishSuscription();

    btStateSuscription = flutterBlue.state.listen((event) async {
       if( event == BluetoothState.on ){
        isEnabled = true;
       } else if( event == BluetoothState.off ){
        isEnabled = false;
       } else{
        await finishSuscription();
        await initSubscription();
       }
    });
  }

  Future<void> finishSuscription() async {
    await btStateSuscription?.cancel();
  }

}