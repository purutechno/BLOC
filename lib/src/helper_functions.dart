import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

getGoogleDriveDownloadLink({fileId})
{
  return "https://drive.google.com/uc?id="+fileId+"&export=download";
}
String getDecimalToRoman(number)
{
  String roman;
  switch (number)
  {
    case 1:
      roman = "I";
      break;
    case 2:
      roman = "II";
      break;
    case 3:
      roman = "III";
      break;
    case 4:
      roman = "IV";
      break;
    case 5:
      roman = "V";
      break;
    case 6:
      roman = "VI";
      break;
    case 7:
      roman = "VII";
      break;
    case 8:
      roman = "VIII";
      break;
    case 9:
      roman = "IX";
      break;
    case 10:
      roman = "X";
      break;
    case 11:
      roman = "XI";
      break;
    case 12:
      roman = "XII";
      break;
    case 13:
      roman = "XIII";
      break;
    case 14:
      roman = "XIV";
      break;
    case 15:
      roman = "XV";
      break;
    case 16:
      roman = "XVI";
      break;
    case 17:
      roman = "XVII";
      break;
    case 18:
      roman = "XVIII";
      break;
    case 19:
      roman = "XIX";
      break;
    case 20:
      roman = "XX";
      break;
    case 21:
      roman = "XXI";
      break;
    case 22:
      roman = "XXII";
      break;
    case 23:
      roman = "XXIII";
      break;
    case 24:
      roman = "XXIV";
      break;
    case 25:
      roman = "XXV";
      break;
    case 26:
      roman = "XXVI";
      break;
    
    default:
      roman = "I";
      break;

  }
  return roman;
}
truncateTheTable({tablename})async
  {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + "/IoeSolutions.db";
    var database = await openDatabase("$path");
    var total = Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM $tablename'));
    print("The total no. of records in $tablename before deleting  : $total");
    var count = await database.rawDelete('DELETE FROM $tablename');
    var total2 = Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM $tablename'));
    print("The total no. of records in $tablename after deleting  : $total2");
    return count;
  }

Future saveToSharedPreferences(key,value) async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var store = prefs.setString("$key",value);
  return store;
}
Future getFromSharedPreferences(key) async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var fetchedData = prefs.getString("$key")?? "_";
  print("fetched data from shared preference is : $fetchedData");
  return fetchedData;
}

deleteFromSharedPreferences(key) async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var result = await prefs.remove(key);
  return result;
}