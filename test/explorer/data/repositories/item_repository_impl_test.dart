import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trocapp/core/error/exceptions.dart';
import 'package:trocapp/core/error/failures.dart';
import 'package:trocapp/core/network/network_info.dart';
import 'package:trocapp/features/explorer/data/datasources/item_local_data_source.dart';
import 'package:trocapp/features/explorer/data/datasources/item_remote_data_source.dart';
import 'package:trocapp/features/explorer/data/models/item_model.dart';
import 'package:trocapp/features/explorer/data/repositories/item_repository_impl.dart';
import 'package:trocapp/features/explorer/domain/entities/item.dart';

class MockRemoteDataSource extends Mock implements ItemRemoteDataSource {}

class MockLocalDataSource extends Mock implements ItemLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  ItemRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ItemRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteItem', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these three variables throughout all the tests
    final tId = 1;
    final tItemModel = ItemModel(id: tId, name: 'Test Item');
    final Item tItem = tItemModel;

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getConcreteItem(tId);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteItem(any))
              .thenAnswer((_) async => tItemModel);
          // act
          final result = await repository.getConcreteItem(tId);
          // assert
          verify(mockRemoteDataSource.getConcreteItem(tId));
          expect(result, equals(Right(tItem)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteItem(any))
              .thenAnswer((_) async => tItemModel);
          // act
          await repository.getConcreteItem(tId);
          // assert
          verify(mockRemoteDataSource.getConcreteItem(tId));
          verify(mockLocalDataSource.cacheItem(tItemModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteItem(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getConcreteItem(tId);
          // assert
          verify(mockRemoteDataSource.getConcreteItem(tId));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastItem())
              .thenAnswer((_) async => tItemModel);
          // act
          final result = await repository.getConcreteItem(tId);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastItem());
          expect(result, equals(Right(tItem)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastItem()).thenThrow(CacheException());
          // act
          final result = await repository.getConcreteItem(tId);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastItem());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  //---------------------

  group('getNearItem', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    final tItemModel = ItemModel(id: 123, name: 'Test Item');
    final Item tItem = tItemModel;

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getNearItem();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getNearItem())
              .thenAnswer((_) async => tItemModel);
          // act
          final result = await repository.getNearItem();
          // assert
          verify(mockRemoteDataSource.getNearItem());
          expect(result, equals(Right(tItem)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getNearItem())
              .thenAnswer((_) async => tItemModel);
          // act
          await repository.getNearItem();
          // assert
          verify(mockRemoteDataSource.getNearItem());
          verify(mockLocalDataSource.cacheItem(tItemModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getNearItem()).thenThrow(ServerException());
          // act
          final result = await repository.getNearItem();
          // assert
          verify(mockRemoteDataSource.getNearItem());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastItem())
              .thenAnswer((_) async => tItemModel);
          // act
          final result = await repository.getNearItem();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastItem());
          expect(result, equals(Right(tItem)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastItem()).thenThrow(CacheException());
          // act
          final result = await repository.getNearItem();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastItem());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
