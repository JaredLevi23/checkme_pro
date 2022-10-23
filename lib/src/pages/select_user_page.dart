import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkme_pro_develop/src/providers/providers.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';

class SelectUserPage extends StatelessWidget {
  const SelectUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    // title : PED or DLC 
    final typeFile = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final title = typeFile['title'] ?? 'None';

    return Scaffold(
      appBar: AppBar(
        title: Text('Select User $title', style: const TextStyle( color: Color.fromRGBO(50, 97, 148, 1))),
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
          
          // user model 
          final user = checkmeProvider.userList[ index ];

          // regular expression to remove unnecessary characters
          final userName = user.userName.replaceAll( RegExp('[^A-Za-z0-9 ]'), '' );
          return GestureDetector(
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular( 15 ),
                color: Colors.white,
              ) ,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // Icon User
                  const Icon( Icons.person, size: 80, color: Colors.deepOrange,),

                  // User Name
                  Text( 
                    userName, 
                    style: const TextStyle( fontSize:  18 ), 
                    textAlign: TextAlign.center
                  ),

                  // Id User
                  Text( 'ID: ${user.userId}' )
                ],
              )
            ),
            onTap: title == 'PED' 
            // pedometer per user
            ? ()async{
                if( checkmeProvider.isConnected ){
                  await checkmeProvider.beginReadFileList( 
                    indexTypeFile: 9, 
                    userId: user.userId
                  );
                }
                await checkmeProvider.loadDataById(tableName: 'Ped', userId: user.userId );
                Navigator.pushNamed(context, 'checkme/ped');
              }
            : 
            // daily check per user 
            () async{

                if( checkmeProvider.isConnected ){
                  await checkmeProvider.beginReadFileList( 
                    indexTypeFile: 2, 
                    userId: user.userId
                  );
                }
                await checkmeProvider.loadDataById(tableName: 'Dlc', userId: user.userId );
                Navigator.pushNamed(context, 'checkme/dlc');
              }
          );
        }
      )
    );
  }
}