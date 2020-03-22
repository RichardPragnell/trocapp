import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trocapp/core/error/exceptions.dart';
import 'package:trocapp/features/explorer/data/datasources/item_local_data_source.dart';
import 'package:trocapp/features/explorer/data/models/item_model.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  ItemLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ItemLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastItem', () {
    final tItemModel =
        ItemModel.fromJson(json.decode(fixture('item_cached.json')));

    test(
      'should return Item from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('item_cached.json'));
        // act
        final result = await dataSource.getLastItem();
        // assert
        verify(mockSharedPreferences.getString(CACHED_ITEM));
        expect(result, equals(tItemModel));
      },
    );

    test('should throw a CacheException when there is not a cached value', () {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      // Not calling the method here, just storing it inside a call variable
      final call = dataSource.getLastItem;
      // assert
      // Calling the method happens from a higher-order function passed.
      // This is needed to test if calling a method throws an exception.
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheItem', () {
    final tItemModel =
        ItemModel(id: 1, name: 'test item', year: 2020, color: "#FFFFFF");

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // act
        dataSource.cacheItem(tItemModel);
        // assert
        final expectedJsonString = json.encode(tItemModel.toJson());
        verify(mockSharedPreferences.setString(
          CACHED_ITEM,
          expectedJsonString,
        ));
      },
    );
  });
}
