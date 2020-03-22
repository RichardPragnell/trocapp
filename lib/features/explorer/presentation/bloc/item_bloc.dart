import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:trocapp/core/util/input_converter.dart';
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
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    if (event is GetItemForConcreteId) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.idString);

      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        // Although the "success case" doesn't interest us with the current test,
        // we still have to handle it somehow.
        (integer) => throw UnimplementedError(),
      );
    }
  }
}
