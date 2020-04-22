import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:trocapp/core/error/exceptions.dart';
import 'package:trocapp/core/error/failures.dart';
import 'package:trocapp/core/network/network_info.dart';
import 'package:trocapp/features/explorer/data/datasources/item_local_data_source.dart';
import 'package:trocapp/features/explorer/data/datasources/item_remote_data_source.dart';
import 'package:trocapp/features/explorer/domain/entities/item.dart';
import 'package:trocapp/features/explorer/domain/repositories/item_repository.dart';

typedef Future<Item> _ConcreteOrNearChooser();

class ItemRepositoryImpl implements ItemRepository {
  final ItemRemoteDataSource remoteDataSource;
  final ItemLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ItemRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, Item>> getConcreteItem(int id) async {
    return await _getItem(() {
      return remoteDataSource.getConcreteItem(id);
    });
  }

  @override
  Future<Either<Failure, Item>> getNearItem() async {
    return await _getItem(() {
      return remoteDataSource.getNearItem();
    });
  }

  Future<Either<Failure, Item>> _getItem(
      _ConcreteOrNearChooser getConcreteOrNear
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteItem = await getConcreteOrNear();
        localDataSource.cacheItem(remoteItem);
        return Right(remoteItem);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localItem = await localDataSource.getLastItem();
        return Right(localItem);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
