import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trocapp/core/error/failures.dart';
import 'package:trocapp/core/usecases/usecase.dart';
import 'package:trocapp/core/util/input_converter.dart';
import 'package:trocapp/features/explorer/domain/entities/item.dart';
import 'package:trocapp/features/explorer/domain/usecases/get_concrete_item.dart';
import 'package:trocapp/features/explorer/domain/usecases/get_near_item.dart';
import 'package:trocapp/features/explorer/presentation/bloc/bloc.dart';

class MockGetConcreteItem extends Mock implements GetConcreteItem {}

class MockGetNearItem extends Mock implements GetNearItem {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  ItemBloc bloc;
  MockGetConcreteItem mockGetConcreteItem;
  MockGetNearItem mockGetNearItem;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteItem = MockGetConcreteItem();
    mockGetNearItem = MockGetNearItem();
    mockInputConverter = MockInputConverter();

    bloc = ItemBloc(
      concrete: mockGetConcreteItem,
      near: mockGetNearItem,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetItemForConcreteId', () {
    // The event takes in a String
    final tIdString = '1';
    // This is the successful output of the InputConverter
    final tIdParsed = int.parse(tIdString);
    // Item instance is needed too, of course
    final tItem = Item(id: 1, name: 'test item');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tIdParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        // act
        bloc.add(GetItemForConcreteId(tIdString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tIdString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final expected = [
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetItemForConcreteId(tIdString));
      },
    );

    test(
      'should get data from the concrete use case',
          () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteItem(any))
            .thenAnswer((_) async => Right(tItem));
        // act
        bloc.add(GetItemForConcreteId(tIdString));
        await untilCalled(mockGetConcreteItem(any));
        // assert
        verify(mockGetConcreteItem(Params(id: tIdParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
          () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteItem(any))
            .thenAnswer((_) async => Right(tItem));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(item: tItem),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetItemForConcreteId(tIdString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
          () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteItem(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetItemForConcreteId(tIdString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
          () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteItem(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetItemForConcreteId(tIdString));
      },
    );
  });

  //---------------

  group('GetTriviaForNearItem', () {
    final tItem = Item(id: 1, name: 'test item', color: "#FFFFFF");

    test(
      'should get data from the near use case',
          () async {
        // arrange
        when(mockGetNearItem(any))
            .thenAnswer((_) async => Right(tItem));
        // act
        bloc.add(GetItemForNearLocation());
        await untilCalled(mockGetNearItem(any));
        // assert
        verify(mockGetNearItem(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
          () async {
        // arrange
        when(mockGetNearItem(any))
            .thenAnswer((_) async => Right(tItem));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(item: tItem),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetItemForNearLocation());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
          () async {
        // arrange
        when(mockGetNearItem(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetItemForNearLocation());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
          () async {
        // arrange
        when(mockGetNearItem(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetItemForNearLocation());
      },
    );
  });
}
