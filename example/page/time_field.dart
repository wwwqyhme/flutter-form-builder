import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';

class TimeFieldPage extends BasePage<TimeOfDay?, FormeTimeFieldModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeTextFieldOnTapProxyWidget(
            child: FormeTimeField(
          onInitialed: (c) {
            print(c.value);
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          name: name,
          model: FormeTimeFieldModel(
              textFieldModel: FormeTextFieldModel(
            decoration: InputDecoration(labelText: 'DateTime'),
          )),
          validator: (value) => value == null ? 'select a time!' : null,
        )),
        Wrap(
          children: [
            createButton('change picker entry mode', () async {
              controller.updateModel(FormeTimeFieldModel(
                initialEntryMode: TimePickerEntryMode.input,
              ));
            }),
            createButton('change formatter', () async {
              controller.updateModel(FormeTimeFieldModel(
                formatter: (timeOfDay) => timeOfDay.toString(),
              ));
            }),
            createButton('update labelText', () async {
              controller.updateModel(FormeTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelText: 'New Label Text',
                ),
              )));
            }),
            createButton('update labelStyle', () {
              controller.updateModel(FormeTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 30, color: Colors.pinkAccent),
                ),
              )));
            }),
            createButton('update style', () {
              controller.updateModel(FormeTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )));
            }),
            createButton('set helper text', () {
              controller.updateModel(FormeTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  helperText: 'helper text',
                ),
              )));
            }),
            createButton('set prefix icon', () {
              controller.updateModel(FormeTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.timer),
                    onPressed: () {
                      controller.value = TimeOfDay.fromDateTime(DateTime.now());
                    },
                  ),
                ),
              )));
            }),
            createButton('set suffix icon', () {
              controller.updateModel(FormeTimeFieldModel(
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
  String get title => 'FormeTimeField';
}
