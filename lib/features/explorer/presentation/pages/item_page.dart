import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trocapp/features/explorer/presentation/bloc/bloc.dart';
import 'package:trocapp/features/explorer/presentation/widgets/widgets.dart';
import 'package:trocapp/injection_container.dart';

class ItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<ItemBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ItemBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
              BlocBuilder<ItemBloc, ItemState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return ItemDisplay(item: state.item);
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  } else {
                    return MessageDisplay(
                      message: "This is impossible!",
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              // Bottom half
              ItemControls()
            ],
          ),
        ),
      ),
    );
  }
}
