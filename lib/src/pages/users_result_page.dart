import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
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

          return GestureDetector(
            child: Container(
              margin: const EdgeInsets.symmetric( horizontal: 10,vertical: 5 ),
              height: 90,
              padding: const EdgeInsets.symmetric( horizontal: 15 ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white
              ),
              child: Row(
                children: [
          
                  const CircleAvatar(
                    child: Icon( Icons.person ),
                  ),
          
                  const SizedBox(
                    width: 10,
                  ),
          
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text( 'ID: ${user.userId}' ),
                      Text( 
                        user.userName , 
                        style: const TextStyle( fontSize: 20, fontWeight: FontWeight.w600 ),
                      ),
                      Text( 
                        getBirthday( birthday: user.birthDay ).toString().split(' ')[0], 
                        style: const TextStyle( fontSize: 17),
                      ),
                    ],
                  ),
          
                  const Spacer(),
          
                  const Icon( Icons.remove_red_eye )
                ],
              ),
            ),
            onTap: (){
              checkmeProvider.currentUser = user;
              Navigator.pushNamed(context, 'checkme/users/details');
            },
          );

      }),
    );
  }
}