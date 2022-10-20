
// getMeasurementDateTime
import 'dart:developer';

DateTime getMeasurementDateTime( { required String measurementDate } ){

  if( measurementDate.length > 14 ){
    final dateSplit = measurementDate.split(' ');
    final date = DateTime( 
      int.parse(dateSplit[1]), // year
      int.parse(dateSplit[3]), // month
      int.parse(dateSplit[5]), // day
      int.parse(dateSplit[7]), // hour
      int.parse(dateSplit[9]), // minute
      int.parse(dateSplit[11]) // second 
    );
    return date;
  }else{
    final dateFormat = measurementDate.split('');
    final date = DateTime(
      int.parse( dateFormat[0] + dateFormat[1] + dateFormat[2] + dateFormat[3] ), // year
      int.parse( dateFormat[4] + dateFormat[5] ), // month
      int.parse( dateFormat[6] + dateFormat[7] ), // day
      int.parse( dateFormat[8] + dateFormat[9] ), // hour
      int.parse( dateFormat[10] + dateFormat[11] ), // minute
      int.parse( dateFormat[12] + dateFormat[13] ) // seconds
    );

    return date;
  }
}

// getMeasureFormatTime
String getMeasureFormatTime( { required int seconds} ){
  final time = DateTime( 0 ,0 ,0 ,0,0, seconds ).toString().split(' ')[1].split('.')[0];
  return time;
}

DateTime getBirthday( { required String birthday } ){  
  if( birthday.startsWith('year')){
    final dateTime = birthday.split(' ');

    final date = DateTime(
      int.parse( dateTime[1] ),
      int.parse( dateTime[3] ),
      int.parse( dateTime[5] ),
    );

    return date;
  }else{
    final dateTime = birthday.split(' ');
    final date = DateTime( 
      int.parse( dateTime[5]),
      getMonth( dateTime[1] ),
      int.parse( dateTime[2] )
     );

     return date;
  }
}


int getMonth( String month ){
  if( month == "Jan" ){
    return 1; 
  }
  if( month == "Feb" ){
    return 2; 
  }
  if( month == "Mar" ){
    return 3; 
  }
  if( month == "Abr" ){
    return 4; 
  }
  if( month == "May" ){
    return 5; 
  }
  if( month == "Jun" ){
    return 6; 
  }
  if( month == "Jul" ){
    return 7; 
  }
  if( month == "Aug" ){
    return 8; 
  }
  if( month == "Sep" ){
    return 9; 
  }
  if( month == "Oct" ){
    return 10; 
  }
  if( month == "Nov" ){
    return 11; 
  }
  if( month == "Dec" ){
    return 12; 
  }

  return 1;
}