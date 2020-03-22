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
      _getItemFromUrl('https://reqres.in/api/unknown/15'); // TODO: fix 15

  Future<ItemModel> _getItemFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
