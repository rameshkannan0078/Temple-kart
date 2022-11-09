import 'dart:convert';
import 'package:demo_project/src/models/getProdByCat_model.dart';
import 'package:http/http.dart' as http;
import 'package:demo_project/src/global/global.dart';

class StoreApi {
  Future<GetProdByCatID> storeApi(String id) async {
    var responseJson;
    await http.post(Uri.parse('${baseUrl()}get_pro_by_cat_id'), body: {
      'cat_id': id,
    }).then((response) {
      responseJson = _returnResponse(response);
    }).catchError((onError) {
      print(onError);
    });
    return GetProdByCatID.fromJson(responseJson);
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
