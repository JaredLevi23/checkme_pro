import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/widgets/sync_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogSelector extends StatelessWidget {
  const DialogSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);

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
                        final res = await checkmeProvider.connectToDevice( uuid: device.uuid );

                        if( res == 'checkmepro/connecting' ){
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
                SyncButton(title: 'Detener', onPressed: (){
                  checkmeProvider.stopScan();
                }),
                SyncButton(title: 'Close', onPressed: (){
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