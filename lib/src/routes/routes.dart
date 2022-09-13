
import 'package:flutter/material.dart';
import '../pages/pages.dart';

Map<String, Widget Function(BuildContext)> routes(){
  return {
    'home': (_) => const HomePage(),
    'checkme/ecg': (_) => const EcgResultsPage(),
    'checkme/info':(_)=> const DeviceInfoPage(),
    'checkme/temp': (_) => const TemperaturesResultsPage(),
    'checkme/spo2': (_) => const Spo2ResultsPage(),
    'checkme/sml': (_) => const SmlResultsPage(),
    'checkme/users': (_) => const UserResultPage()
  };
}