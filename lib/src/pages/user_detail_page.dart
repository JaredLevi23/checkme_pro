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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User Detail'),
      ),

      body: SingleChildScrollView(
        child: Column(
          
          children: [

            Text( 'ID: ${ currentUser.id }' , style: const TextStyle( fontSize: 20 ),),
            _description( title: 'User Name', value: currentUser.userName, iconData: Icons.person ),
            _description( title: 'Birthday', value: birthday.toString().split(' ')[0], iconData: Icons.cake),
            _description( title: 'Age', value: '${  DateTime.now().year -  birthday.year } years', iconData: Icons.calendar_today_rounded ),
            _description( title:'Gender', value: currentUser.gender == '0' ? 'Male' : 'Female', iconData: Icons.male ),
            _description( title:'Height', value:currentUser.height, iconData: Icons.height ),
            _description( title:'Weight', value:currentUser.weight, iconData: Icons.balance ),
            const Divider(),
      
          ],
        ),
      )
    );
  }


  Widget _description( {required String title, required String value, IconData? iconData} ){
    return Column(
      children: [
        const Divider(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white
          ),
          child: ListTile(
            title:    Text( value, style: const TextStyle( fontSize: 22, fontWeight: FontWeight.w400 ),),
            subtitle: Text( title, style: const TextStyle( fontSize: 18 ),),
            leading: Icon( iconData ?? Icons.star, size: 40, ),
          ),
        ),
      ],
    );
  }
}