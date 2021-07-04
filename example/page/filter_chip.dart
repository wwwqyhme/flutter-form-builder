import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';

class FilterChipFieldPage extends BasePage<List<String>, FormeFilterChipModel> {
  @override
  Widget get body {
    return Builder(builder: (context) {
      return Column(
        children: [
          FormeFilterChip<String>(
            decoratorBuilder: FormeInputDecoratorBuilder(
                decoration: InputDecoration(labelText: 'Filter Chip')),
            name: name,
            items: FormeUtils.toFormeChipItems(['flutter', 'android', 'iOS']),
            model: FormeFilterChipModel(
              exceedCallback: () =>
                  showError(context, 'you can select only  one item!'),
            ),
            listener: FormeValueFieldListener(
              onValidate: FormeValidates.size(
                  min: 2, errorText: 'select at least two items!'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
          Wrap(
            children: [
              createButton('set selectable count to 1', () async {
                controller.updateModel(FormeFilterChipModel<String>(
                  count: 1,
                ));
              }),
              createButton('update items', () async {
                controller.updateModel(FormeFilterChipModel<String>(
                  items: FormeUtils.toFormeChipItems(['java', 'c#', 'python']),
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
    });
  }

  @override
  String get title => 'FormeFilterChip';
}
