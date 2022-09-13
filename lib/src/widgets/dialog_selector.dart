// import 'package:checkme_pro_develop/src/providers/bluetooht_provider.dart';
// import 'package:checkme_pro_develop/src/widgets/sync_button.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class DialogSelector extends StatelessWidget {
//   const DialogSelector({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     final bleProvider = Provider.of<BluetoothProvider>(context);

//     return Material(
//       color: Colors.transparent,
//       child: Container(
//         color: Colors.white,
//         margin: const EdgeInsets.all(15),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: bleProvider.devices.length,
//                 itemBuilder: (_, index) {

//                   final device = bleProvider.devices[index];

//                   return Card(
//                     child: ListTile(
//                       title: Text( device.name ),
//                       subtitle: Text( device.id.id ),
//                       onTap: () async {
//                         bleProvider.bluetoothDevice = device;
//                         await bleProvider.connectToDevice();
//                       },
//                     ),
//                   );
//                 }
//               )
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SyncButton(title: 'Detener', onPressed: (){
//                   bleProvider.terminateConnection();
//                 }),
//                 SyncButton(title: 'Cancelar', onPressed: (){
//                   bleProvider.terminateConnection();
//                 }),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }