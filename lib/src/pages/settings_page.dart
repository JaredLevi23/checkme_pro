import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/shar_prefs/device_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {

    final _prefs = DevicePreferences();
    final checkmeProvider = Provider.of< CheckmeChannelProvider >(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle( color: Color.fromRGBO(50, 97, 148, 1))),
      ),

      body: ListView(
        children: [

          // checkme pro name 
          ListTile(
            title: const Text('Delete device'),
            subtitle: Text( _prefs.deviceName == '' ? 'No device connected' : _prefs.deviceName ),
            leading: const Icon( Icons.delete, size: 30,), 
            trailing: const Icon( Icons.arrow_right_sharp ),
            onTap: () async {

              await showDialog(context: context, builder: (_) {
                return AlertDialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: Container(
                    margin: const EdgeInsets.symmetric( horizontal: 8, vertical: 30 ),
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular( 15 ),
                      color: Colors.white
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Text('Are you sure you want to remove the device?', textAlign: TextAlign.center,),
                        const Divider(),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              child: const Text('Yes'),
                              onPressed: (){
                                checkmeProvider.cancelConnect();
                                _prefs.uuid = '';
                                _prefs.deviceName = '';

                                Navigator.pop(context);
                              }, 
                            ),
                            TextButton(
                              onPressed: ()=> Navigator.pop(context), 
                              child: const Text('No')
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });

              setState(() {});
            },
          )

        ],
      ),
    );
  }
}