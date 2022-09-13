import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [

          //TODO: Agregar logo de hoyhealth

          ListTile(
            title: const Text('Acerca de'),
            onTap: (){

            },
          ),
          
          ListTile(
            title: const Text('Cerrar sesión'),
            onTap: (){

            },
          )
        ],
      ),
    );
  }
}