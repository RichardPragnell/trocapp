import 'package:dartz/dartz.dart';
import 'package:trocapp/core/error/failures.dart';
import 'package:trocapp/core/usecases/usecase.dart';
import 'package:trocapp/features/explorer/domain/entities/item.dart';
import 'package:trocapp/features/explorer/domain/repositories/item_repository.dart';

class GetNearItem extends UseCase<Item, NoParams> {
  final ItemRepository repository;

  GetNearItem(this.repository);

  @override
  Future<Either<Failure, Item>> call(NoParams params) async {
    return await repository.getNearItem();
  }
}
