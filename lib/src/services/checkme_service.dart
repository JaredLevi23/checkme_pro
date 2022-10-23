import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckmeService with ChangeNotifier{
  
  // TODO: Add http requests to send measurements

  Future<void>post()async{
    final response = await http.post( 
      Uri.parse('URL'), 
      headers: { 
        'Content-type': 'application/json',
        'Authorization': 'Some token'
      }, 
      body: {} 
    );

    log( '${response.statusCode}' );
  }

}