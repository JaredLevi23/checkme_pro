import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkme_pro_develop/src/providers/providers.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';

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
          // info
          _deviceInfo(title: device?.application ?? 'unknown', subtitle: 'Application'),
          _deviceInfo(title: device?.branchCode ?? 'unknown', subtitle: 'Brach Code'),
          _deviceInfo(title: device?.model ?? 'unknown', subtitle: 'Model'),
          _deviceInfo(title: device?.hardware ?? 'unknown', subtitle: 'Hardware'),
          _deviceInfo(title: device?.software ?? 'unknown', subtitle: 'Sofware'),
          _deviceInfo(title: device?.theCurLanguage ?? 'unknown', subtitle: 'CUR LNG'),
          _deviceInfo(title: device?.language ?? 'unknown', subtitle: 'Language'),
          _deviceInfo(title: device?.sn ?? 'unknown', subtitle: 'SN'),
          _deviceInfo(title: device?.spcPVer ?? 'unknown', subtitle: 'SPCPVER'),

        ],
      )
    );
  }

    Widget _deviceInfo({ required String title, required String subtitle }){
      return Card(
        child: ListTile(
          title: Text( title ),
          subtitle: Text( subtitle ),
        ),
      );
    }
}