import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';

class CheckboxTileFieldPage
    extends BasePage<List<String>, FormeListTileModel<String>> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeListTile<String>(
          decoratorBuilder: FormeInputDecoratorBuilder(
              decoration: InputDecoration(labelText: '123')),
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
          type: FormeListTileType.Checkbox,
          model: FormeListTileModel<String>(),
          listener: FormeValueFieldListener(
            onValidate: FormeValidates.notEmpty(errorText: 'pls select one!'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          name: name,
        ),
        Wrap(
          children: [
            createButton('update items', () async {
              controller.updateModel(FormeListTileModel<String>(
                  items: FormeUtils.toFormeListTileItems(
                      ['flutter', 'dart', 'pub'])));
            }),
            createButton('to List Tile', () async {
              controller.updateModel(FormeListTileModel<String>(split: 1));
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
  String get title => 'FormeCheckboxTile';
}
