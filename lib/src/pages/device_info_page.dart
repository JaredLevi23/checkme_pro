// Device Info Page
// Date: 12-SEP
// Function: Show device information

import 'package:flutter/material.dart';
import 'package:checkme_pro_develop/src/models/models.dart';

class DeviceInfoPage extends StatelessWidget {
  const DeviceInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

  // data 
  final jsonInfo = (ModalRoute.of(context)?.settings.arguments as Map<String, String>)['info'];
  final DeviceInformationModel device = DeviceInformationModel.fromRawJson( jsonInfo! );

    return Scaffold(
      appBar: AppBar( title: const Text('Device information')),
      body: ListView(
        padding: const EdgeInsets.only( left: 15, right: 15, top: 10, bottom: 10),
        children: [

          // descriptions
          deviceDescription(title: device.application, subtitle: 'Application'),
          deviceDescription(title: device.branchCode, subtitle: 'Brach Code'),
          deviceDescription(title: device.model, subtitle: 'Model'),
          deviceDescription(title: device.hardware, subtitle: 'Hardware'),
          deviceDescription(title: device.software, subtitle: 'Sofware'),
          deviceDescription(title: device.theCurLanguage, subtitle: 'CUR LNG'),
          deviceDescription(title: device.language, subtitle: 'Language'),
          deviceDescription(title: device.sn, subtitle: 'SN'),
          deviceDescription(title: device.spcPVer, subtitle: 'SPCPVER'),

        ],
      )
    );
  }

    Widget deviceDescription({ required String title, required String subtitle }){
      return Card(
        child: ListTile(
          title: Text( title ),
          subtitle: Text( subtitle ),
        ),
      );
    }
}