import 'dart:convert';
import 'package:demo_project/src/models/home_model.dart';
import 'package:http/http.dart' as http;
import 'package:demo_project/src/global/global.dart';

class HometApi {
  Future<HomeModel> homeApi() async {
    var responseJson;
    await http.get(Uri.parse('${baseUrl()}home')).then((response) {
      responseJson = _returnResponse(response);
    }).catchError((onError) {
      print(onError);
    });
    return HomeModel.fromJson(responseJson);
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);

        return responseJson;
      case 400:
        throw Exception(response.body.toString());
      case 401:
        throw Exception(response.body.toString());
      case 403:
        throw Exception(response.body.toString());
      case 500:
      default:
        throw Exception(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
