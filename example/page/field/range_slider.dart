import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';

class RangeSliderFieldPage
    extends BasePage<RangeValues, FormeRangeSliderModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeRangeSlider(
          decoratorBuilder: FormeInputDecoratorBuilder(
              decoration: InputDecoration(labelText: 'Range Slider')),
          min: 1,
          max: 100,
          name: name,
          model: FormeRangeSliderModel(),
          listener: FormeValueFieldListener(
            onValidate: (f, value) => value.start < 50
                ? 'start value must bigger than 50 ,current is $value'
                : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
        Wrap(
          children: [
            createButton('set min to 20', () async {
              controller.updateModel(FormeRangeSliderModel(
                min: 20,
              ));
            }),
            createButton('set max to 150', () async {
              controller.updateModel(FormeRangeSliderModel(
                max: 150,
              ));
            }),
            createButton('set divisions to 5', () async {
              controller.updateModel(FormeRangeSliderModel(
                divisions: 5,
              ));
            }),
            createButton('update theme data', () async {
              controller.updateModel(FormeRangeSliderModel(
                sliderThemeData: SliderThemeData(
                  thumbColor: Colors.red,
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.purpleAccent,
                ),
              ));
            }),
            createButton('update labelText', () async {
              updateLabel();
            }),
            createButton('update labelStyle', () {
              updateLabelStyle();
            }),
            createButton('set helper text', () {
              updateHelperStyle();
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
  String get title => 'FormeRangeSlider';
}
