import 'dart:math';

import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class RowPage extends StatelessWidget {
  final String name = 'row';
  final FormeKey formKey = FormeKey();

  FormeFieldController<FormeFlexModel> get controller => formKey.field(name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Row'),
      ),
      body: Column(
        children: [
          Forme(
            child: FormeRow(
              name: name,
              children: [],
            ),
            key: formKey,
          ),
          Wrap(
            children: [
              Padding(
                  padding: EdgeInsets.all(5),
                  child: TextButton.icon(
                    onPressed: () {
                      controller.model = controller.model.append(
                          FormeSingleCheckbox(
                              name: Random.secure().nextDouble().toString()));
                    },
                    icon: Icon(Icons.add),
                    label: Text('append a checkbox'),
                  )),
              Padding(
                  padding: EdgeInsets.all(5),
                  child: TextButton.icon(
                    onPressed: () {
                      controller.model =
                          controller.model.prepend(Text('prepend!'));
                    },
                    icon: Icon(Icons.add),
                    label: Text('preappend a widget'),
                  )),
              Padding(
                  padding: EdgeInsets.all(5),
                  child: TextButton.icon(
                    onPressed: () {
                      controller.model = controller.model.swap(0, 1);
                    },
                    icon: Icon(Icons.add),
                    label: Text('swap first and second widget'),
                  )),
              Padding(
                  padding: EdgeInsets.all(5),
                  child: TextButton.icon(
                    onPressed: () {
                      controller.model = controller.model.remove(0);
                    },
                    icon: Icon(Icons.remove),
                    label: Text('delete first widget'),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
