import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trocapp/core/usecases/usecase.dart';
import 'package:trocapp/features/explorer/domain/entities/item.dart';
import 'package:trocapp/features/explorer/domain/repositories/item_repository.dart';
import 'package:trocapp/features/explorer/domain/usecases/get_near_item.dart';

class MockItemRepository extends Mock implements ItemRepository {}

void main() {
  GetNearItem usecase;
  MockItemRepository mockItemRepository;

  setUp(() {
    mockItemRepository = MockItemRepository();
    usecase = GetNearItem(mockItemRepository);
  });

  final tItem = Item(id: 1, name: 'Near Item', year: 2020, color: '#FFFFFF');

  test(
    'should get near item from the repository',
    () async {
      // arrange
      when(mockItemRepository.getNearItem())
          .thenAnswer((_) async => Right(tItem));
      // act
      // Since near item doesn't require any parameters, we pass in NoParams.
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tItem));
      verify(mockItemRepository.getNearItem());
      verifyNoMoreInteractions(mockItemRepository);
    },
  );
}
