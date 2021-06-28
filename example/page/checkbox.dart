import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';

class CheckboxPage extends BasePage<bool, FormeSingleCheckboxModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeSingleCheckbox(
          model: FormeSingleCheckboxModel(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          name: name,
          validator: (value) =>
              !value! ? 'you must accept before continue!' : null,
        ),
        Wrap(
          children: [
            builderButton('set label', (context) {
              controller.updateModel(FormeSingleCheckboxModel(
                title: Text('label'),
              ));
            }),
            builderButton('change to listtile style', (context) {
              controller.updateModel(FormeSingleCheckboxModel(
                  title: Text('label'),
                  subtitle: Text('ok'),
                  listTile: true,
                  secondary: Icon(Icons.ac_unit_outlined),
                  checkboxRenderData: FormeCheckboxRenderData(
                    activeColor: Colors.red,
                    tileColor: Colors.yellow,
                    selectedTileColor: Colors.green,
                  )));
            }),
            builderButton('validate', (context) {})
          ],
        )
      ],
    );
  }

  @override
  String get title => 'FormeSingleCheckbox';
}
