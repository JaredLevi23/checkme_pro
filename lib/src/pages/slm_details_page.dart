import 'dart:developer';

import 'package:checkme_pro_develop/src/models/models.dart';
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SlmDetailsPage extends StatelessWidget {
  const SlmDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    final currentSlm = checkmeProvider.currentSlm;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sleep Monitor Details', style: TextStyle( color: Color.fromRGBO(50, 97, 148, 1))),
        ),
        body: const SlmGraph(),
      ),
    );
  }
}