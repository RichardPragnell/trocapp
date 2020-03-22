import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trocapp/features/explorer/data/models/item_model.dart';
import 'package:trocapp/features/explorer/domain/entities/item.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tItemModel =
      ItemModel(id: 1, year: 2020, name: 'Test', color: '#FFFFFF');

  test(
    'should be a subclass of Item entity',
    () async {
      // assert
      expect(tItemModel, isA<Item>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model from the JSON',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('item.json'));
        printOnFailure(jsonMap.toString());
        // act
        final result = ItemModel.fromJson(jsonMap);
        // assert
        expect(result, tItemModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tItemModel.toJson();
        // assert
        final expectedJsonMap = {
          "id": 1,
          "name": "Test",
          "year": 2020,
          "color": "#FFFFFF",
        };
        expect(result, expectedJsonMap);
      },
    );
  });
}
