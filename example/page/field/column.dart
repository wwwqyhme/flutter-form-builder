import 'dart:math';

import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class ColumnPage extends StatelessWidget {
  final String name = 'row';
  final FormeKey formKey = FormeKey();

  FormeFieldController<FormeFlexModel> get controller => formKey.field(name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Column'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Forme(
                child: FormeColumn(
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
                          FormeFlexModel model = controller.model;
                          if (!formKey.hasField('row1')) {
                            for (int i = 0; i < 10; i++) {
                              model.append(
                                FormeRow(children: [
                                  Expanded(
                                      child: FormeTextField(
                                    name: 'text$i',
                                    initialValue: '$i',
                                  )),
                                  FormeSingleCheckbox(
                                    name: 'checkbox$i',
                                  ),
                                  FormeSingleSwitch(
                                    name: 'switch$i',
                                  ),
                                ], name: 'row$i'),
                              );
                            }
                            controller.model = model;
                          }
                        },
                        icon: Icon(Icons.add),
                        label: Text('append 10 rows'),
                      )),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: TextButton.icon(
                        onPressed: () {
                          controller.model = controller.model.prepend(Row(
                            children: [
                              Expanded(
                                child: FormeTextField(
                                    name: Random.secure()
                                        .nextDouble()
                                        .toString()),
                              ),
                              FormeSingleCheckbox(
                                  name:
                                      Random.secure().nextDouble().toString()),
                              FormeSingleSwitch(
                                  name:
                                      Random.secure().nextDouble().toString()),
                            ],
                          ));
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
        ),
      ),
    );
  }
}
