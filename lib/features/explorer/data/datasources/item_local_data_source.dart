import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trocapp/core/error/exceptions.dart';
import 'package:trocapp/features/explorer/data/models/item_model.dart';

abstract class ItemLocalDataSource {
  /// Gets the cached [ItemModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<ItemModel> getLastItem();

  Future<void> cacheItem(ItemModel itemToCache);
}

const CACHED_ITEM = 'CACHED_ITEM';

class ItemLocalDataSourceImpl implements ItemLocalDataSource {
  final SharedPreferences sharedPreferences;

  ItemLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<ItemModel> getLastItem() {
    final jsonString = sharedPreferences.getString(CACHED_ITEM);
    if (jsonString != null) {
      // Future which is immediately completed
      return Future.value(ItemModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheItem(ItemModel itemToCache) {
    return sharedPreferences.setString(
      CACHED_ITEM,
      json.encode(itemToCache.toJson()),
    );
  }
}
