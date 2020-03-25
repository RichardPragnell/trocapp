import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trocapp/features/explorer/presentation/bloc/bloc.dart';

class ItemControls extends StatefulWidget {
  const ItemControls({
    Key key,
  }) : super(key: key);

  @override
  _ItemControlsState createState() => _ItemControlsState();
}

class _ItemControlsState extends State<ItemControls> {
  final controller = TextEditingController();
  String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input an id',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text('Search'),
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: dispatchConcrete,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                child: Text('Get near item'),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<ItemBloc>(context).add(GetItemForConcreteId(inputStr));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<ItemBloc>(context).add(GetItemForNearLocation());
  }
}
