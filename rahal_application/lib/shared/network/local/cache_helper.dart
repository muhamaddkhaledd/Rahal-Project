import 'package:shared_preferences/shared_preferences.dart';

class cachehelper
{
  static SharedPreferences? sharedPreferences;
  static init() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }
  static Future<bool> putpooldata(String key,bool value)async
  {
   return await sharedPreferences!.setBool(key, value);
  }
  static bool? getpooldata(String key)
  {
    return sharedPreferences!.getBool(key);
  }

  //the best methods:
  static Future<bool> saveshareddata({
  required String key,
  required dynamic value,
})async
  {
    if(value is bool)return await sharedPreferences!.setBool(key, value);
    if(value is int)return await sharedPreferences!.setInt(key, value);
    if(value is String)return await sharedPreferences!.setString(key, value);
    return await sharedPreferences!.setDouble(key, value);
  }
  static dynamic getshareddata({required String key})
  {
    return sharedPreferences!.get(key);
  }


}