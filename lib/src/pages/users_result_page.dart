import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserResultPage extends StatelessWidget {
  const UserResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        actions: const [ ConnectionIndicator() ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: checkmeProvider.userList.length,
        itemBuilder: (_, index){

          final user = checkmeProvider.userList[index];
          final birthDay = user.birthday.split(' ');

          return Card(
            child: ListTile(
              leading: CircleAvatar( 
                child: Text( user.userId ),
                radius: 30,
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
              ),
              title: Text( user.userName ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( 'Birtday: ${birthDay[1]}-${birthDay[3]}-${birthDay[5]}'),
                ],
              ),
            ),

          );

      }),
    );
  }
}