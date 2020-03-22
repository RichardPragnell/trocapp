import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:trocapp/core/error/failures.dart';
import 'package:trocapp/core/usecases/usecase.dart';
import 'package:trocapp/features/explorer/domain/entities/item.dart';
import 'package:trocapp/features/explorer/domain/repositories/item_repository.dart';

class GetConcreteItem extends UseCase<Item, Params> {
  final ItemRepository repository;

  GetConcreteItem(this.repository);

  @override
  Future<Either<Failure, Item>> call(Params params) async {
    return await repository.getConcreteItem(params.id);
  }
}

class Params extends Equatable {
  final int id;

  Params({@required this.id});

  @override
  List<Object> get props => [id];
}
