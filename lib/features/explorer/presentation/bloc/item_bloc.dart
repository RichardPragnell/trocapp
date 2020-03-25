import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:trocapp/core/error/failures.dart';
import 'package:trocapp/core/usecases/usecase.dart';
import 'package:trocapp/core/util/input_converter.dart';
import 'package:trocapp/features/explorer/domain/entities/item.dart';
import 'package:trocapp/features/explorer/domain/usecases/get_concrete_item.dart';
import 'package:trocapp/features/explorer/domain/usecases/get_near_item.dart';
import 'package:trocapp/features/explorer/presentation/bloc/bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final GetConcreteItem getConcreteItem;
  final GetNearItem getNearItem;
  final InputConverter inputConverter;

  ItemBloc({
    // Changed the name of the constructor parameter (cannot use 'this.')
    @required GetConcreteItem concrete,
    @required GetNearItem near,
    @required this.inputConverter,
    // Asserts are how you can make sure that a passed in argument is not null.
    // We omit this elsewhere for the sake of brevity.
  })  : assert(concrete != null),
        assert(near != null),
        assert(inputConverter != null),
        getConcreteItem = concrete,
        getNearItem = near;

  @override
  ItemState get initialState => Empty();

  @override
  Stream<ItemState> mapEventToState(ItemEvent event,) async* {
    if (event is GetItemForConcreteId) {
      final inputEither =
      inputConverter.stringToUnsignedInteger(event.idString);

      yield* inputEither.fold(
            (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
            (integer) async* {
          yield Loading();
          final failureOrItem = await getConcreteItem(Params(id: integer));
          yield* _eitherLoadedOrErrorState(failureOrItem);
        },
      );
    } else if (event is GetItemForNearLocation) {
      yield Loading();
      final failureOrItem = await getNearItem(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrItem);
    }
  }

  Stream<ItemState> _eitherLoadedOrErrorState(
      Either<Failure, Item> failureOrItem,) async* {
    yield failureOrItem.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (item) => Loaded(item: item),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
