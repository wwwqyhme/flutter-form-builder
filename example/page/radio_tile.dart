import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';
import 'package:forme/src/field/forme_radio_group.dart';

class RadioTileFieldPage
    extends BasePage<String, FormeRadioGroupModel<String>> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeRadioGroup<String>(
          decoratorBuilder: FormeInputDecoratorBuilder(
              decoration: InputDecoration(labelText: 'Radio Group')),
          items: [
            FormeListTileItem(
              title: Text('java'),
              data: 'java',
              secondary: Text('secondary1'),
              subtitle: Text('subtitle'),
            ),
            FormeListTileItem(
              title: Text('c#'),
              data: 'c#',
              secondary: Text('secondary2'),
              subtitle: Text('subtitle'),
            ),
            FormeListTileItem(
              title: Text('python'),
              data: 'python',
              secondary: Text('secondary3'),
              subtitle: Text('subtitle'),
            ),
          ],
          model: FormeRadioGroupModel<String>(),
          name: name,
          listener: FormeValueFieldListener(
            onValidate:
                FormeValidates.notNull(errorText: 'pls select one item!'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
        Wrap(
          children: [
            createButton('update items', () async {
              controller.updateModel(FormeRadioGroupModel<String>(
                  items: FormeUtils.toFormeListTileItems(
                      ['flutter', 'dart', 'pub'])));
            }),
            createButton('to List Tile', () async {
              controller.updateModel(FormeRadioGroupModel<String>(split: 1));
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
  String get title => 'FormeRadioTile';
}
