// Connection Indicator 

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';

class ConnectionIndicator extends StatelessWidget {
  const ConnectionIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    final isConnected = checkmeProvider.isConnected;
    final isSync = checkmeProvider.isSync;

    return GestureDetector(
      child: Container(        
        margin: const EdgeInsets.only( right: 15),
        child: Row(
          children: [
            if( isSync )
              const SizedBox(
                width: 40,
                height: 3,
                child: LinearProgressIndicator()
              ),
            
            const SizedBox( width: 5, ),
            Icon(
              Icons.circle,
              color: isConnected ? Colors.greenAccent : Colors.red,
              size: 15,
            ),
          ],
        ),
      ),
      onTap: () async {
        await checkmeProvider.startScan();
        showDialog(context: context, builder: ( _) {
          return const DialogSelector();
        });
      }
    );
  }
}