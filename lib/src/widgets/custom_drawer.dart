import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            iconData: Icons.settings,
            title: 'Settings',
            onPressed: (){}
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