import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';

class DateRangeFieldPage
    extends BasePage<DateTimeRange?, FormeDateRangeFieldModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeDateRangeField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          name: name,
          model: FormeDateRangeFieldModel(
              textFieldModel: FormeTextFieldModel(
            decoration: InputDecoration(labelText: 'DateRange'),
          )),
          validator: (value) => value == null ? 'select a date range!' : null,
        ),
        Wrap(
          children: [
            createButton('set firstDate to tomorrow', () async {
              DateTime now = DateTime.now();
              controller.updateModel(FormeDateRangeFieldModel(
                firstDate: DateTime(now.year, now.month, now.day + 1),
              ));
            }),
            createButton('set lastDate to next month', () async {
              DateTime now = DateTime.now();
              controller.updateModel(FormeDateRangeFieldModel(
                lastDate: DateTime(now.year, now.month + 1, now.day),
              ));
            }),
            createButton('change picker entry mode', () async {
              controller.updateModel(FormeDateRangeFieldModel(
                initialEntryMode: DatePickerEntryMode.input,
              ));
            }),
            createButton('change formatter', () async {
              controller.updateModel(FormeDateRangeFieldModel(
                formatter: (range) => range.toString(),
              ));
            }),
            createButton('update labelText', () async {
              controller.updateModel(FormeDateRangeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelText: 'New Label Text',
                ),
              )));
            }),
            createButton('update labelStyle', () {
              controller.updateModel(FormeDateRangeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 30, color: Colors.pinkAccent),
                ),
              )));
            }),
            createButton('update style', () {
              controller.updateModel(FormeDateRangeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )));
            }),
            createButton('set helper text', () {
              controller.updateModel(FormeDateRangeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  helperText: 'helper text',
                ),
              )));
            }),
            createButton('set prefix icon', () {
              controller.updateModel(FormeDateRangeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.timer),
                    onPressed: () {
                      DateTime now = DateTime.now();
                      controller.value = DateTimeRange(
                          start: now,
                          end: DateTime(now.year, now.month + 1, now.day));
                    },
                  ),
                ),
              )));
            }),
            createButton('set suffix icon', () {
              controller.updateModel(FormeDateRangeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      controller.clearValue();
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
