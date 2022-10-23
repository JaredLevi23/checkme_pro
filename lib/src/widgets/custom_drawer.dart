// Drawer 

import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/shar_prefs/device_preferences.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    final _dev = DevicePreferences();

    return Drawer(
      backgroundColor: const Color.fromRGBO(10, 72, 113, 1),
      child: ListView(
        children: [

          //TODO: add hoyhealth icon

          DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                const CircleAvatar(
                  child: Icon(Icons.person),
                ),

                const SizedBox(
                  width: 10,
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('User', style: TextStyle( fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),),
                    Text('Account', style: TextStyle( fontSize: 15, color: Colors.white ),)
                  ],
                )
              ],
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
              checkmeProvider.offlineMode = false;
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
            onPressed: ()async {
              if( checkmeProvider.informationModel == null ){
                await checkmeProvider.getInfoCheckmePRO();
              }
              Navigator.pushNamed(context, 'checkme/info');
            }
          ),

          _optionDrawer(
            iconData: Icons.school, 
            title: 'HoyLearning', 
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
      leading: Icon( iconData , size: 30, color: Colors.white,),
      title: Text( title , style: const TextStyle( fontSize: 17, color: Colors.white),),
      onTap: onPressed
    ); 
  }

}