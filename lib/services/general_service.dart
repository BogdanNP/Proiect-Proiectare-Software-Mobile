import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/app_values.dart';

class GeneralService {
  Future<Map<String, dynamic>> uploadData(
    String path,
    Map<String, dynamic> uploadObject,
  ) async {
    http.Response response = await http.post(
      Uri.parse("${AppValues.apiUrl}$path"),
      body: jsonEncode(uploadObject),
    );
    debugPrint("PATH: [${AppValues.apiUrl}$path]");
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse["status"] == "SUCCESS") {
        return jsonResponse["data"];
      }
      if (jsonResponse["status"] == "ERROR") {
        throw Exception(jsonResponse["message"]);
      }
      return jsonResponse;
    } else {
      throw Exception('Failed to save.');
    }
  }

  Future<List<Map<String, dynamic>>> getDataList(String path) async {
    http.Response response =
        await http.get(Uri.parse("${AppValues.apiUrl}$path"));
    debugPrint("PATH: [${AppValues.apiUrl}$path]");
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse["status"] == "SUCCESS") {
        debugPrint("ResponseStatus: SUCCESS");
        return (jsonResponse["data"] as List<dynamic>)
            .map((e) => (e as Map<String, dynamic>))
            .toList();
      }
      if (jsonResponse["status"] == "ERROR") {
        debugPrint("ResponseStatus: ERROR");
        throw Exception(jsonResponse["message"]);
      }
      return [];
    } else {
      debugPrint("ResponseStatus: FAILED");
      throw Exception('Failed to load.');
    }
  }

  Future<Map<String, dynamic>> getData(String path) async {
    http.Response response =
        await http.get(Uri.parse("${AppValues.apiUrl}$path"));
    debugPrint("PATH: [${AppValues.apiUrl}$path]");
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse["status"] == "SUCCESS") {
        debugPrint("ResponseStatus: SUCCESS");
        return (jsonResponse["data"]) as Map<String, dynamic>;
      }
      if (jsonResponse["status"] == "ERROR") {
        debugPrint("ResponseStatus: ERROR");
        throw Exception(jsonResponse["message"]);
      }
      return {};
    } else {
      debugPrint("ResponseStatus: FAILED");
      throw Exception('Failed to load.');
    }
  }

  Future<Map<String, dynamic>> updateData(
    String path,
    Map<String, dynamic> updateObject,
  ) async {
    http.Response response = await http.put(
      Uri.parse("${AppValues.apiUrl}$path"),
      body: jsonEncode(updateObject),
    );
    debugPrint("PATH: [${AppValues.apiUrl}$path]");
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse["status"] == "SUCCESS") {
        debugPrint("ResponseStatus: SUCCESS");
        return jsonResponse["data"];
      }
      if (jsonResponse["status"] == "ERROR") {
        debugPrint("ResponseStatus: ERROR");
        throw Exception(jsonResponse["message"]);
      }
      return jsonResponse;
    } else {
      debugPrint("ResponseStatus: FAILED");
      throw Exception('Failed to update.');
    }
  }

  Future<Map<String, dynamic>> deleteData(
    String path,
    int id,
  ) async {
    debugPrint("PATH: [${AppValues.apiUrl}$path?id=$id]");
    http.Response response = await http.delete(
      Uri.parse("${AppValues.apiUrl}$path?id=$id"),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse["status"] == "ERROR") {
        debugPrint("ResponseStatus: ERROR");
        throw Exception(jsonResponse["message"]);
      }
      debugPrint("ResponseStatus: SUCCESS");
      return jsonResponse;
    } else {
      debugPrint("ResponseStatus: FAILED");
      throw Exception('Failed to delete.');
    }
  }
}
