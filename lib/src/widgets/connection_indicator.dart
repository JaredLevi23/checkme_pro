import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';

class ConnectionIndicator extends StatelessWidget {
  const ConnectionIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final isConnected = Provider.of<CheckmeChannelProvider>(context).isConnected;

    return Container(
      margin: const EdgeInsets.only( right: 15),
      child: Icon(
        Icons.circle,
        color: isConnected ? Colors.greenAccent : Colors.red,
        size: 15,
      ),
    );
  }
}