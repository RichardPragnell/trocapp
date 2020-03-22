import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:trocapp/core/error/exceptions.dart';
import 'package:trocapp/features/explorer/data/datasources/item_remote_data_source.dart';
import 'package:trocapp/features/explorer/data/models/item_model.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  ItemRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = ItemRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('item.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteItem', () {
    final tId = 1;
    final tItemModel = ItemModel.fromJson(json.decode(fixture('item.json')));

    test(
      'should preform a GET request on a URL with number being the endpoint and with application/json header',
      () {
        //arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(fixture('item.json'), 200),
        );
        // act
        dataSource.getConcreteItem(tId);
        // assert
        verify(mockHttpClient.get(
          'https://reqres.in/api/unknown/$tId',
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getConcreteItem(tId);
        // assert
        expect(result, equals(tItemModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getConcreteItem;
        // assert
        expect(() => call(tId), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  //----------------

  group('getNearItem', () {
    final tItemModel = ItemModel.fromJson(json.decode(fixture('item.json')));

    test(
      'should preform a GET request on a URL with *near* endpoint with application/json header',
      () {
        //arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getNearItem();
        // assert
        verify(mockHttpClient.get(
          'https://reqres.in/api/unknown/15',
          headers: {'Content-Type': 'application/json'},
        )); // TODO: fix 15
      },
    );

    test(
      'should return Item when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getNearItem();
        // assert
        expect(result, equals(tItemModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getNearItem;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
