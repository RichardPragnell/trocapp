import 'package:dartz/dartz.dart';
import 'package:trocapp/core/error/failures.dart';
import 'package:trocapp/features/explorer/domain/entities/item.dart';

abstract class ItemRepository {
  Future<Either<Failure, Item>> getConcreteItem(int id);

  Future<Either<Failure, Item>> getNearItem();
}
