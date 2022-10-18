import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailPage extends StatelessWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<CheckmeChannelProvider>(context).currentUser;
    final birthday = getBirthday(birthday:  currentUser.birthDay );

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Detail'),
      ),

      body: Column(
        
        children: [

          const SizedBox(
            height: 20,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircleAvatar(
                radius: 40,
                child: Icon( Icons.person, size: 50,),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          Text( 'ID: ${currentUser.userId}' ),
          _description(title: 'ID', value: '${currentUser.userId}' ),
          _description(title: 'User Name', value: currentUser.userName ),
          _description(title: 'Birthday', value: birthday.toString().split(' ')[0] ),
          _description(title: 'Age', value: '${  DateTime.now().year -  birthday.year } years' ),
          Text( 'gender: ${currentUser.gender}' ),
          Text( 'height: ${currentUser.height}' ),
          Text( 'weight: ${currentUser.weight}' ),
        ],
      )
    );
  }

  Widget _description( { required String title, required String value } ){
    return Container(
      margin: const EdgeInsets.symmetric( vertical: 5 ),
      child: Column(
        children: [
          Text( title, style: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold ),),
          Text( value, style: const TextStyle( fontSize: 20, fontWeight: FontWeight.w500 ),),
        ],
      ),
    );
  }
}