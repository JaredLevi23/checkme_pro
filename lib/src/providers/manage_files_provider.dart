// import 'dart:io';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// class ManageFilesProvider with ChangeNotifier{

//   final files = [
//     'user',
//     'dlc',
//     'ecg',
//     'ped',
//     'tmp',
//     'spo2',
//     'slm'
//   ];

//   Future<String> get _localPath async{
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }

//   Future<File> _localFile( {required String fileName} ) async{
//     final path = await _localPath;
//     return File( '$path/$fileName.json' );
//   }
 
//   Future<File> writeFileJson( String fileName, String content )async{
//     final file = await _localFile( fileName: fileName );
//     return file.writeAsString( content );
//   }

//   Future<String> readFileJson( String fileName )async{
//     try{
//       final file = await _localFile(fileName: fileName);
//       final contents = await file.readAsString();
//       return contents;
//     }catch( err ){
//       log('Error Read File json: $err');
//       return '';
//     }
//   }

// }