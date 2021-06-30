import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';

class NumberFieldPage extends BasePage<num?, FormeNumberFieldModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeNumberField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          name: name,
          model: FormeNumberFieldModel(
              max: 99,
              textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(labelText: 'Number'),
              )),
          validator: (value) => value == null || value < 50
              ? 'value must bigger than 50,current value is $value'
              : null,
        ),
        Wrap(
          children: [
            createButton('set max value to 1000', () async {
              controller.updateModel(FormeNumberFieldModel(
                max: 1000,
              ));
            }),
            createButton('set decimal to 2', () async {
              controller.updateModel(FormeNumberFieldModel(
                decimal: 2,
              ));
            }),
            createButton('allow negative', () async {
              controller.updateModel(FormeNumberFieldModel(
                allowNegative: true,
              ));
            }),
            createButton('update labelText', () async {
              controller.updateModel(FormeNumberFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelText: 'New Label Text',
                ),
              )));
            }),
            createButton('update labelStyle', () {
              controller.updateModel(FormeNumberFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 30, color: Colors.pinkAccent),
                ),
              )));
            }),
            createButton('update style', () {
              controller.updateModel(FormeNumberFieldModel(
                  textFieldModel: FormeTextFieldModel(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )));
            }),
            createButton('set helper text', () {
              controller.updateModel(FormeNumberFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  helperText: 'helper text',
                ),
              )));
            }),
            createButton('set prefix icon', () {
              controller.updateModel(FormeNumberFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.timer),
                    onPressed: () {
                      controller.value = 10;
                    },
                  ),
                ),
              )));
            }),
            createButton('set suffix icon', () {
              controller.updateModel(FormeNumberFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      controller.value = null;
                    },
                  ),
                ),
              )));
            }),
            createButton('validate', () {
              controller.validate();
            }),
          ],
        )
      ],
    );
  }

  @override
  String get title => 'FormeNumberField';
}
