import 'package:flutter/material.dart';

import '../pages/pages.dart';

Map<String, Widget Function(BuildContext)> routes(){
  return {
    'home': (_) => const HomePage(),
    'checkme/dlc'                 : (_) => const DlcResultsPage(),
    'checkme/dlc/details'         : (_) => const DlcDetailsResultsPage(),
    'checkme/dlc/record'          : (_) => const DlcDetailsRecordPage(),
    'checkme/dlc-android/details' : (_) => const DlcDetailsResultAndroidPage(),
    'checkme/dlc-android/record'  : (_) => const DlcDetailsRecordAndroidPage(),
    'checkme/ecg'                 : (_) => const EcgResultsPage(),
    'checkme/ecg/details'         : (_) => const EcgDetailResultPage(),
    'checkme/ecg/record'          : (_) => const EcgDetailsRecordPage(),
    'checkme/ecg-android/details' : (_) => const EcgDetailResultAndroidPage(),
    'checkme/ecg-android/record'  : (_) => const EcgDetailsRecordAndroidPage(),
    'checkme/info'                : (_) => const DeviceInfoPage(),
    'checkme/users'               : (_) => const UserResultPage(),
    'checkme/selectUser'          : (_) => const SelectUserPage(),
    'checkme/sml'                 : (_) => const SlmResultsPage(),
    'checkme/slm/details'         : (_) => const SlmDetailsPage(),
    'checkme/spo2'                : (_) => const Spo2ResultsPage(),
    'checkme/ped'                 : (_) => const PedResultsPage(),
    'checkme/temp'                : (_) => const TemperaturesResultsPage(),
    'checkme/settings'            : (_) => const SettingsPage(),
  };
}