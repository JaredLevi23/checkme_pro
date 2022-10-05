import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/shar_prefs/device_preferences.dart';
import 'package:checkme_pro_develop/src/widgets/sync_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogSelector extends StatelessWidget {
  const DialogSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);

    final _devicePrefs = DevicePreferences();

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric( horizontal: 30, vertical: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: checkmeProvider.devices.length,
                itemBuilder: (_, index) {

                  final device = checkmeProvider.devices[index];

                  return Container(
                    margin: const EdgeInsets.symmetric( vertical: 10, horizontal: 15 ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all( color: Colors.cyan, width: 2),
                      color: Colors.white
                    ),
                    child: ListTile(
                      title: Text( device.name, style: const TextStyle( fontSize: 18 ), ),
                      subtitle: Text( device.uuid),
                      leading: const CircleAvatar(child: Icon( Icons.bluetooth_searching_sharp )),
                      onTap: () async {
                        
                        checkmeProvider.currentDevice = device;
                        _devicePrefs.uuid = '';
                        _devicePrefs.deviceName = '';

                        final res = await checkmeProvider.connectToDevice( uuid: device.uuid, deviceName: device.name );

                        if( res ){
                          Navigator.pop(context);
                        }
                      },
                    ),
                  );
                }
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SyncButton(title: 'Cancel', onPressed: (){
                  checkmeProvider.stopScan();
                  Navigator.pop(context);
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}