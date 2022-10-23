// Database 
import 'dart:io';

import 'package:checkme_pro_develop/src/db/db_tables.dart';
import 'package:checkme_pro_develop/src/models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider{
  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async{
    if( _database != null ) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database>initDB()async{

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join( documentsDirectory.path, 'CheckmePro.db' );

    return await openDatabase(
      path,
      version: 1,
      onOpen: ( db ) async {
        await db.execute( DbTables.usersTable );
        await db.execute( DbTables.ecgTable );
        await db.execute( DbTables.dlcTable);
        await db.execute( DbTables.tmpTable);
        await db.execute( DbTables.spoTable);
        await db.execute( DbTables.pedTable);
        await db.execute( DbTables.slmTable);
        await db.execute( DbTables.ecgDetailsTable);
        await db.execute( DbTables.slmDetailsTable );
      },
      onCreate: ( Database db, int version ) async {
        await db.execute( DbTables.usersTable );
        await db.execute( DbTables.ecgTable );
        await db.execute( DbTables.dlcTable);
        await db.execute( DbTables.tmpTable);
        await db.execute( DbTables.spoTable);
        await db.execute( DbTables.pedTable);
        await db.execute( DbTables.slmTable);
        await db.execute( DbTables.ecgDetailsTable);
        await db.execute( DbTables.slmDetailsTable );
      }
    );
  }

  Future<int> newValue( String tableName, dynamic value ) async {
    final db = await database;
    
    if( tableName == 'Users' ){
      final user = value as UserModel;
      final res = await db.insert(tableName, user.toJson() );
      return res;
    }

    if( tableName == 'Ecg' ){
      final user = value as EcgModel;
      final res = await db.insert(tableName, user.toJson() );
      return res;
    }

    if( tableName == 'Dlc' ){
      final user = value as DlcModel;
      final res = await db.insert(tableName, user.toJson() );
      return res;
    }

    if( tableName == 'Tmp' ){
      final user = value as TemperatureModel;
      final res = await db.insert(tableName, user.toJson() );
      return res;
    }

    if( tableName == 'Spo' ){
      final user = value as Spo2Model;
      final res = await db.insert(tableName, user.toJson() );
      return res;
    }

    if( tableName == 'Ped' ){
      final user = value as PedModel;
      final res = await db.insert(tableName, user.toJson() );
      return res;
    }

    if( tableName == 'Slm' ){
      final user = value as SlmModel;
      final res = await db.insert(tableName, user.toJson() );
      return res;
    }

    if( tableName == 'EcgDetails'){
      final user = value as EcgDetailsModel;
      final res = await db.insert(tableName, user.toJson() );
      return res;
    }

    if( tableName == 'SlmDetails' ){
      final user = value as SlmDetailsModel;
      final res = await db.insert(tableName, user.toJson() );
      return res;
    }

    return 0;
  }

  Future<int> deleteAllTable( String tableName ) async {
    final db = await database;
    final res = db.delete( tableName );
    return res;
  }

  Future<int> updateUserById( UserModel userModel )async{
    final db = await database;
    final res = db.update( 'Users' , userModel.toJson(), where: 'id=?', whereArgs: [ userModel.id ] );
    return res;

  }

  Future<List<dynamic>> getAllDb( String tableName )async{
    final db = await database;
    final res = await db.query( tableName );

    if( res.isNotEmpty ){

      if( tableName == 'Users' ){
        return res.map((e) => UserModel.fromJson(e)).toList();
      }

      if( tableName == 'Ecg' ){
        return res.map((e) => EcgModel.fromJson(e)).toList();
      }

      if( tableName == 'Dlc' ){
        return res.map((e) => DlcModel.fromJson(e)).toList();
      }

      if( tableName == 'Tmp' ){
       return res.map((e) => TemperatureModel.fromJson(e)).toList();
      }

      if( tableName == 'Spo' ){
        return res.map((e) => Spo2Model.fromJson(e)).toList();
      }

      if( tableName == 'Ped' ){
        return res.map((e) => PedModel.fromJson(e)).toList();
      }

      if( tableName == 'Slm' ){
        return res.map((e) => SlmModel.fromJson(e)).toList();
      }


    }
    return [];
  }

  Future<List<dynamic>> getValue( {required String tableName, required String dtcDate} )async{
    final db = await database;
    final res = tableName != 'Users'
    ? await db.rawQuery('SELECT * FROM $tableName WHERE dtcDate=?', [ dtcDate ])
    : await db.rawQuery('SELECT * FROM $tableName WHERE userId=?',[ int.parse( dtcDate ) ]);

    if( res.isNotEmpty ){

      if( tableName == 'Users' ){
        return res.map((e) => UserModel.fromJson(e)).toList();
      }

      if( tableName == 'Ecg' ){
        return res.map((e) => EcgModel.fromJson(e)).toList();
      }

      if( tableName == 'Dlc' ){
        return res.map((e) => DlcModel.fromJson(e)).toList();
      }

      if( tableName == 'Tmp' ){
       return res.map((e) => TemperatureModel.fromJson(e)).toList();
      }

      if( tableName == 'Spo' ){
        return res.map((e) => Spo2Model.fromJson(e)).toList();
      }

      if( tableName == 'Ped' ){
        return res.map((e) => PedModel.fromJson(e)).toList();
      }

      if( tableName == 'Slm' ){
        return res.map((e) => SlmModel.fromJson(e)).toList();
      }

      if( tableName == 'EcgDetails' ){
        return res.map((e) => EcgDetailsModel.fromJsonDB(e)).toList();
      }

      if( tableName == 'SlmDetails'){
        return res.map((e) => SlmDetailsModel.fromJsonDB(e)).toList();
      }
    }
    return [];
  }

  Future<List<dynamic>> getValueByUserId( { required String tableName, required int userId } ) async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT * FROM $tableName where userId=$userId
    ''');

    if( res.isNotEmpty ){
      if( tableName == 'Users' ){
        return res.map((e) => UserModel.fromJson(e)).toList();
      }

      if( tableName == 'Ecg' ){
        return res.map((e) => EcgModel.fromJson(e)).toList();
      }

      if( tableName == 'Dlc' ){
        return res.map((e) => DlcModel.fromJson(e)).toList();
      }

      if( tableName == 'Tmp' ){
       return res.map((e) => TemperatureModel.fromJson(e)).toList();
      }

      if( tableName == 'Spo' ){
        return res.map((e) => Spo2Model.fromJson(e)).toList();
      }

      if( tableName == 'Ped' ){
        return res.map((e) => PedModel.fromJson(e)).toList();
      }

      if( tableName == 'Slm' ){
        return res.map((e) => SlmModel.fromJson(e)).toList();
      }
    }

    return [];
  }

  

  Future<int> deleteById( {required String tableName, required String dtcDate} ) async{
    final db = await database;
    final res = db.delete( tableName, where: 'dtcDate=?', whereArgs: [ dtcDate ] );
    return res;
  }

}