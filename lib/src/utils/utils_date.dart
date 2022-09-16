
// getMeasurementDateTime
DateTime getMeasurementDateTime( { required String measurementDate } ){
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
}

// getMeasureFormatTime
String getMeasureFormatTime( { required int seconds} ){
  final time = DateTime( 0 ,0 ,0 ,0,0, seconds ).toString().split(' ')[1].split('.')[0];
  return time;
}