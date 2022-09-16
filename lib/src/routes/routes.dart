import 'package:flutter/material.dart';

import '../pages/pages.dart';

Map<String, Widget Function(BuildContext)> routes(){
  return {
    'home': (_) => const HomePage(),
    'checkme/dlc'        : (_) => const DlcResultsPage(),
    'checkme/dlc/details': (_) => const DlcDetailsResultsPage(),
    'checkme/ecg'        : (_) => const EcgResultsPage(),
    'checkme/ecg/details': (_) => const EcgDetailResultPage(),
    'checkme/info'       : (_) => const DeviceInfoPage(),
    'checkme/users'      : (_) => const UserResultPage(),
    'checkme/selectUser' : (_) => const SelectUserPage(),
    'checkme/sml'        : (_) => const SmlResultsPage(),
    'checkme/spo2'       : (_) => const Spo2ResultsPage(),
    'checkme/ped'        : (_) => const PedResultsPage(),
    'checkme/temp'       : (_) => const TemperaturesResultsPage(),
  };
}