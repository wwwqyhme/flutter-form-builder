import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';

class SliderFieldPage extends BasePage<double, FormeSliderModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeSlider(
          decoratorBuilder: FormeInputDecoratorBuilder(
              decoration: InputDecoration(labelText: 'Slider')),
          min: 1,
          max: 100,
          name: name,
          model: FormeSliderModel(),
          listener: FormeValueFieldListener(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onValidate:
                FormeValidates.min(50, errorText: 'value must bigger than 50 '),
            onAsyncValidate: (f, value) => Future.delayed(
                Duration(milliseconds: 800),
                () => 'this is an errorText from async validator'),
          ),
        ),
        Wrap(
          children: [
            createButton('reset', () async {
              controller.reset();
            }),
            createButton('set min to 20', () async {
              controller.updateModel(FormeSliderModel(
                min: 20,
              ));
            }),
            createButton('set max to 150', () async {
              controller.updateModel(FormeSliderModel(
                max: 150,
              ));
            }),
            createButton('set divisions to 5', () async {
              controller.updateModel(FormeSliderModel(
                divisions: 5,
              ));
            }),
            createButton('update theme data', () async {
              controller.updateModel(FormeSliderModel(
                sliderThemeData: SliderThemeData(
                  thumbColor: Colors.red,
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.purpleAccent,
                ),
              ));
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
  String get title => 'FormeSlider';
}
