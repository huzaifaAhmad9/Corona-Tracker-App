import 'dart:convert';

import 'package:corona_tracker/Utlities/app_url.dart';
import 'package:http/http.dart' as http;

import '../Model/World_stats_model.dart';
class  StatesServices{
  Future<WorldStatsModel> fetchWorldStateRecords() async{
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return WorldStatsModel.fromJson(data);
    } else{
      throw Exception('Error');
    }
  }






  Future<List<dynamic>> countriesListApi() async{
    var data;
    final response = await http.get(Uri.parse(AppUrl.countriesList));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());
      return data;
    } else{
      throw Exception('Error');
    }
  }

}