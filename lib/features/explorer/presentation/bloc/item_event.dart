import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ItemEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetItemForConcreteId extends ItemEvent {
  final String idString;

  GetItemForConcreteId(this.idString);

  @override
  List<Object> get props => [idString];
}

class GetItemForNearLocation extends ItemEvent {}
