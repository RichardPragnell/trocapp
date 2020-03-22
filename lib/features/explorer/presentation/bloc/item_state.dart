import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:trocapp/features/explorer/domain/entities/item.dart';

@immutable
abstract class ItemState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends ItemState {}

class Loading extends ItemState {}

class Loaded extends ItemState {
  final Item item;

  Loaded({@required this.item});

  @override
  List<Object> get props => [item];
}

class Error extends ItemState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
