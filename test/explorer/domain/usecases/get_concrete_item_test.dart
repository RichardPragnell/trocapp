import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trocapp/features/explorer/domain/entities/item.dart';
import 'package:trocapp/features/explorer/domain/repositories/item_repository.dart';
import 'package:trocapp/features/explorer/domain/usecases/get_concrete_item.dart';

class MockItemRepository extends Mock implements ItemRepository {}

void main() {
  GetConcreteItem usecase;
  MockItemRepository mockItemRepository;

  setUp(() {
    mockItemRepository = MockItemRepository();
    usecase = GetConcreteItem(mockItemRepository);
  });

  final tId = 1;
  final tItem = Item(id: 1, name: 'test', year: 2020, color: "#FFFFFF");

  test(
    'should get item for the id from the repository',
    () async {
      // "On the fly" implementation of the Repository using the Mockito package.
      // When getConcreteItem is called with any argument, always answer with
      // the Right "side" of Either containing a test Item object.
      when(mockItemRepository.getConcreteItem(any))
          .thenAnswer((_) async => Right(tItem));
      // The "act" phase of the test. Call the not-yet-existent method.
      final result = await usecase(Params(id: tId));
      // UseCase should simply return whatever was returned from the Repository
      expect(result, Right(tItem));
      // Verify that the method has been called on the Repository
      verify(mockItemRepository.getConcreteItem(tId));
      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mockItemRepository);
    },
  );
}
