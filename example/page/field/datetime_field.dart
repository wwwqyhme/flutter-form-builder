import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';

class DateTimeFieldPage extends BasePage<DateTime?, FormeDateTimeFieldModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeTextFieldOnTapProxyWidget(
          child: FormeDateTimeField(
            name: name,
            model: FormeDateTimeFieldModel(
                textFieldModel: FormeTextFieldModel(
              readOnly: false,
              decoration: InputDecoration(labelText: 'DateTime'),
            )),
            listener: FormeValueFieldListener(
              onValidate:
                  FormeValidates.notNull(errorText: 'pls select a datetime!'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onAsyncValidate: (f, v) =>
                  Future.delayed(Duration(seconds: 1), () => 'invalid date'),
            ),
          ),
        ),
        Wrap(
          children: [
            createButton('change type to DateTime', () async {
              controller.updateModel(FormeDateTimeFieldModel(
                type: FormeDateTimeFieldType.DateTime,
              ));
            }),
            createButton('use 24h format', () async {
              controller.updateModel(FormeDateTimeFieldModel(
                type: FormeDateTimeFieldType.DateTime,
                use24hFormat: true,
              ));
            }),
            createButton('change type to Date', () async {
              controller.updateModel(FormeDateTimeFieldModel(
                type: FormeDateTimeFieldType.Date,
              ));
            }),
            createButton('change picker entry mode', () async {
              controller.updateModel(FormeDateTimeFieldModel(
                initialEntryMode: TimePickerEntryMode.input,
              ));
            }),
            createButton('change formatter', () async {
              controller.updateModel(FormeDateTimeFieldModel(
                formatter: (type, time) => time.toString(),
              ));
            }),
            createButton('update labelText', () async {
              controller.updateModel(FormeDateTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelText: 'New Label Text',
                ),
              )));
            }),
            createButton('update labelStyle', () {
              controller.updateModel(FormeDateTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 30, color: Colors.pinkAccent),
                ),
              )));
            }),
            createButton('update style', () {
              controller.updateModel(FormeDateTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )));
            }),
            createButton('set helper text', () {
              controller.updateModel(FormeDateTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  helperText: 'helper text',
                ),
              )));
            }),
            createButton('set prefix icon', () {
              controller.updateModel(FormeDateTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.timer),
                    onPressed: () {
                      controller.value = DateTime.now();
                    },
                  ),
                ),
              )));
            }),
            createButton('set suffix icon', () {
              controller.updateModel(FormeDateTimeFieldModel(
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
