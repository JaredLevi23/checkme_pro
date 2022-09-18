import 'dart:developer';

import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/shar_prefs/device_preferences.dart';
import 'package:checkme_pro_develop/src/widgets/dialog_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    final _dev = DevicePreferences();

    return Drawer(
      child: ListView(
        children: [

          //TODO: add hoyhealth icon

          const DrawerHeader(
            child: CircleAvatar(
              backgroundColor: Colors.cyan,
              child: Icon( Icons.person, size: 90, color: Colors.white,),
            )
          ),

          _optionDrawer(
            iconData: Icons.bluetooth_connected,
            title: checkmeProvider.isConnected ? 'Disconnect' : 'Connect to',
            onPressed: checkmeProvider.isConnected 
            ? () async {
              await checkmeProvider.cancelConnect();
            }
            : () async {
              Navigator.pop(context);
              await checkmeProvider.startScan();
              showDialog(context: context, builder: ( _) {
                return const DialogSelector();
              });
            }
          ),
          _optionDrawer(
            iconData: Icons.settings,
            title: 'Settings',
            onPressed: ()=> Navigator.pushNamed(context, 'checkme/settings')
          ),
          _optionDrawer(
            iconData: Icons.info,
            title: 'About',
            onPressed: (){}
          ),
          _optionDrawer(
            iconData: Icons.logout,
            title: 'Logout',
            onPressed: (){}
          ),
          
          
        ],
      ),
    );
  }

  // Option Drawer 
  Widget _optionDrawer( { required IconData iconData, required String title, required Function()? onPressed } ){
    return ListTile(
      leading: Icon( iconData , size: 30, color: Colors.cyan,),
      title: Text( title , style: const TextStyle( fontSize: 17, color: Colors.blueGrey),),
      onTap: onPressed
    ); 
  }

}