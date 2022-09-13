import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:checkme_pro_develop/src/providers/bluetooht_provider.dart';
import 'package:checkme_pro_develop/src/routes/routes.dart';
import 'package:checkme_pro_develop/src/theme/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_) => BluetoothProvider() ),
        ChangeNotifierProvider(create: (_) => CheckmeChannelProvider() )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: routes(),
        theme: themeData()
      ),
    );
  }
}