import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../utils/utils_date.dart';

class UserResultPage extends StatelessWidget {
  const UserResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            Text('User List', style: TextStyle( color: Color.fromRGBO(50, 97, 148, 1)),),
          ],
        ),
        actions: [ 
          //ConnectionIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset('assets/svg/hoyrpm_logo.svg', width: 25, height: 25 ),
          )
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: checkmeProvider.userList.length,
        itemBuilder: (_, index){

          final user = checkmeProvider.userList[index];

          return Container(
            margin: const EdgeInsets.symmetric( horizontal: 10,vertical: 5 ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white
            ),
            child: ListTile(
              leading: CircleAvatar( 
                child: Text( '${user.id}' ),
                radius: 30,
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
              ),
              title: Text( user.userName ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( 'Birtday: ${ getBirthday( birthday: user.birthDay ).toString().split(' ')[0] }'),
                ],
              ),
              onTap: (){
                checkmeProvider.currentUser = user;
                Navigator.pushNamed(context, 'checkme/users/details');
              },
            ),
          );

      }),
    );
  }
}