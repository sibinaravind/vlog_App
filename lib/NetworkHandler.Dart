import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart'; // logger used for arrange the result and error

class NetworkHandler {
  String baseurl = "http://192.168.42.90:5000";
  var log = new Logger(); // creatying instance  for logger
  FlutterSecureStorage storage = FlutterSecureStorage();
  Future get(String url) async {
    String tocken =
        await storage.read(key: "token"); // passing tocken to database
    log.i(tocken);
    url = formatter(url);
    var response =
        await http.get(url, headers: {"Authorization": "Bearer $tocken"});
    print(response);
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    String tocken = await storage.read(key: "token");
    log.i(tocken);
    url = formatter(url);
    var response = await http.post(url,
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $tocken"
        },
        body: json.encode(body));
    log.i(response.body);
    log.i(response.statusCode);
    return response;
  }

  //post method for using model calass
  Future<http.Response> post1(String url, var body) async {
    String tocken = await storage.read(key: "token");
    log.i(tocken);
    url = formatter(url);
    var response = await http.post(url,
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $tocken"
        },
        body: json.encode(body));
    log.i(response.body);
    log.i(response.statusCode);
    return response;
  }

// Future is the return type
  Future<http.StreamedResponse> patchImage(String url, String filepath) async {
    String tocken = await storage.read(key: "token");
    log.i(tocken);
    url = formatter(url);
    var request = http.MultipartRequest(
        'PATCH', Uri.parse(url)); // sending the long files
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({
      "Content-type": "application/json",
      "Authorization": "Bearer $tocken"
    });
    var response = request.send();
    return response;
  }

  NetworkImage getImage(String username) {
    String url = formatter("/uploads/$username.jpg");
    return NetworkImage(url);
  } // this is for accessing image from backend

  String formatter(String url) {
    return baseurl + url;
  }
}
