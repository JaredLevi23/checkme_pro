import 'package:checkme_pro_develop/src/shar_prefs/device_preferences.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _prefs = DevicePreferences();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: ListView(
        children: [

          ListTile(
            title: const Text('Delete device'),
            subtitle: Text( _prefs.uuid ),
            onTap: (){
              _prefs.uuid = '';
            },
          )

        ],
      ),
    );
  }
}