import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Item extends Equatable {
  final int id;
  final String name;
  final int year;
  final String color;

  Item({@required this.id, @required this.name, this.year, this.color});

  @override
  List<Object> get props => [id];
}
