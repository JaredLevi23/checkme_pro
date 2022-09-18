import 'dart:developer';

import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectUserPage extends StatelessWidget {
  const SelectUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    final typeFile = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final title = typeFile['title'] ?? 'None';

    return Scaffold(
      appBar: AppBar(
        title: Text('Select User $title'),
        actions: const[
          ConnectionIndicator()
        ],
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: checkmeProvider.userList.length,
        itemBuilder: (_, index){

          final user = checkmeProvider.userList[ index ];

          return GestureDetector(
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon( Icons.person, size: 80, color: Colors.black54,),
                  Text( 
                    user.userName, 
                    style: const TextStyle( fontSize:  18 ), 
                    textAlign: TextAlign.center
                  ),
                  Text( 'ID: ${user.userId}' )
                ],
              )
            ),
            onTap: title == 'PED' 
            ? ()async{
                final res = await checkmeProvider.beginReadFileList( 
                  indexTypeFile: 9, 
                  userId: int.parse(user.userId)
                );
                Navigator.pushNamed(context, 'checkme/ped');
              }
            : () async{
                final res = await checkmeProvider.beginReadFileList( 
                  indexTypeFile: 2, 
                  userId: int.parse(user.userId)
                );
                Navigator.pushNamed(context, 'checkme/dlc');
              }
          );
        }
      )
    );
  }
}