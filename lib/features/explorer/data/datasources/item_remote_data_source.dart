import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:trocapp/core/error/exceptions.dart';
import 'package:trocapp/features/explorer/data/models/item_model.dart';

abstract class ItemRemoteDataSource {
  /// Calls the https://reqres.in/api/unknown/{id} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ItemModel> getConcreteItem(int id);

  /// Calls the https://reqres.in/api/unknown/1 endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ItemModel> getNearItem();
}

class ItemRemoteDataSourceImpl implements ItemRemoteDataSource {
  final http.Client client;

  ItemRemoteDataSourceImpl({@required this.client});

  @override
  Future<ItemModel> getConcreteItem(int id) =>
      _getItemFromUrl('https://reqres.in/api/unknown/$id');

  @override
  Future<ItemModel> getNearItem() =>
      _getItemFromUrl('https://reqres.in/api/unknown/1'); // TODO: fix 1

  Future<ItemModel> _getItemFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      ApiData rawAPI = ApiData.fromJson(json.decode(response.body));
      return ItemModel.fromJson(rawAPI.data.toJson());
    } else {
      throw ServerException();
    }
  }
}


class ApiData {
  Data data;

  ApiData({this.data});

  ApiData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String name;
  int year;
  String color;
  String pantoneValue;

  Data({this.id, this.name, this.year, this.color, this.pantoneValue});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    year = json['year'];
    color = json['color'];
    pantoneValue = json['pantone_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['year'] = this.year;
    data['color'] = this.color;
    data['pantone_value'] = this.pantoneValue;
    return data;
  }
}
