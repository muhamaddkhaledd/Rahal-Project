import 'package:dio/dio.dart';
import 'package:rahal_application/shared/components/constants.dart';

class diohelper
{
  static Dio? dio;
  static init()
  {
    dio=Dio(
      BaseOptions(
        baseUrl: apiconstants.baseurl,
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type':'application/json',
        }
      )
    );
  }
static Future<Response> getdata({
  required String url,
  required Map<String, dynamic> query,
})async
{
    return await dio!.get(
    url,
    queryParameters: query);
}
  static Future<Response> postdata({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
  })async{
    return await dio!.post(
    url,
    queryParameters: query,
    data: data);
  }


}