// Device Info Page
// Date: 12-SEP
// Function: Show device information

import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeviceInfoPage extends StatelessWidget {
  const DeviceInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

  final device = Provider.of<CheckmeChannelProvider>(context).informationModel;

    return Scaffold(
      appBar: AppBar( 
        title: const Text('Device information', style: TextStyle( color: Color.fromRGBO(50, 97, 148, 1)),), 
        actions: const [ ConnectionIndicator() ],
      ),
      
      body: ListView(
        padding: const EdgeInsets.only( left: 15, right: 15, top: 10, bottom: 10),
        children: [
          // descriptions
          deviceDescription(title: device?.application ?? 'unknown', subtitle: 'Application'),
          deviceDescription(title: device?.branchCode ?? 'unknown', subtitle: 'Brach Code'),
          deviceDescription(title: device?.model ?? 'unknown', subtitle: 'Model'),
          deviceDescription(title: device?.hardware ?? 'unknown', subtitle: 'Hardware'),
          deviceDescription(title: device?.software ?? 'unknown', subtitle: 'Sofware'),
          deviceDescription(title: device?.theCurLanguage ?? 'unknown', subtitle: 'CUR LNG'),
          deviceDescription(title: device?.language ?? 'unknown', subtitle: 'Language'),
          deviceDescription(title: device?.sn ?? 'unknown', subtitle: 'SN'),
          deviceDescription(title: device?.spcPVer ?? 'unknown', subtitle: 'SPCPVER'),

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