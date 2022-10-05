import 'package:checkme_pro_develop/src/shar_prefs/device_preferences.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/routes/routes.dart';
import 'package:checkme_pro_develop/src/theme/theme.dart';

import 'src/providers/bluetooht_provider.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  final devicePrefs = DevicePreferences();
  await devicePrefs.initPrefs();

  runApp(
    const MyApp()
  );
} 

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_) => CheckmeChannelProvider() ),
        ChangeNotifierProvider(create: (_) => BluetoothProvider() ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        //home: CircularProgressPage(),
        initialRoute: 'home',
        routes: routes(),
        theme: themeData()
      ),
    );
  }
}