import 'dart:convert';
import 'package:http/http.dart';
import 'package:pinterest/models/post_model.dart';

class Network {
  static bool isTester = true;

  static String SERVER_DEVELOPMENT = "api.unsplash.com";
  static String SERVER_PRODUCTION = "api.unsplash.com";

  static Map<String, String> getHeaders() {
    Map<String,String> headers = {'Accept-Version':'v1','Authorization':'Client-ID VfSnHgBEmZ1z8uRsy9eEAlHJYpdbAITWd0wQtf7uDew'};
    return headers;
  }

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  /* Http Requests */

  static Future<String?> GET(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await get(uri, headers: getHeaders());
    // Log.d(response.body);
    if (response.statusCode == 200) return response.body;

    return null;
  }

  static Future<String?> POST(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response = await post(uri, headers: getHeaders(), body: jsonEncode(params));
    // Log.d(response.body);

    if (response.statusCode == 200 || response.statusCode == 201)
      return response.body;
    return null;
  }

  static Future<String?> PUT(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response = await put(uri, headers: getHeaders(), body: jsonEncode(params));
    // Log.d(response.body);

    if (response.statusCode == 200) return response.body;
    return null;
  }

  static Future<String?> PATCH(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response = await patch(uri, headers: getHeaders(), body: jsonEncode(params));
    // Log.d(response.body);
    if (response.statusCode == 200) return response.body;

    return null;
  }

  static Future<String?> DELETE(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await delete(uri, headers: getHeaders());
    // Log.d(response.body);
    if (response.statusCode == 200) return response.body;

    return null;
  }

  /* Http Apis */
  static String API_LIST = "/photos";
  static String API_LIST_search = "/search/photos";
  static String API_CREATE = "/photos/?client_id=VfSnHgBEmZ1z8uRsy9eEAlHJYpdbAITWd0wQtf7uDew";
  static String API_UPDATE = "/photos/?client_id=VfSnHgBEmZ1z8uRsy9eEAlHJYpdbAITWd0wQtf7uDew/"; //{id}
  static String API_DELETE = "/photos/?client_id=VfSnHgBEmZ1z8uRsy9eEAlHJYpdbAITWd0wQtf7uDew/"; //{id}

  /* Http Params */
  static Map<String, dynamic> paramsEmpty() {
    Map<String, dynamic> params = {};
    return params;
  }

  static Map<String, dynamic> paramsPage(int pageNumber) {
    Map<String, String> params = {};
    params.addAll({
      "page":pageNumber.toString()
    });
    return params;
  }

  static List<Post> parseResponse(String response) {
    List json = jsonDecode(response);
    List<Post> photos = List<Post>.from(json.map((x) => Post.fromJson(x)));
    print("${photos.length}");
    return photos;
  }

  static Map<String, dynamic> paramsSearch(String search, int pageNumber) {
    Map<String, String> params = {};
    params.addAll({
      "page":pageNumber.toString(),
      "query":search
    });
    return params;
  }

  static List<Post> parseSearchParse(String response) {
    Map<String, dynamic> json = jsonDecode(response);
    print("pages: ${json["total"]}\ntotal_pages: ${json["total_pages"]}");
    List<Post> photos = List<Post>.from(json["results"].map((x) => Post.fromJson(x)));
    return photos;
  }
}