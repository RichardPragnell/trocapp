import 'package:meta/meta.dart';
import 'package:trocapp/features/explorer/domain/entities/item.dart';

class ItemModel extends Item {
  ItemModel({
    @required int id,
    @required String name,
    int year,
    String color,
  }) : super(
          id: id,
          name: name,
          year: year,
          color: color,
        );

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['name'],
      year: json['year'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'year': year,
      'color': color,
    };
  }
}
