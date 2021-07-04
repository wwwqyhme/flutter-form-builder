import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';

class DropdownButtonFieldPage
    extends BasePage<String, FormeDropdownButtonModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeDropdownButton<String>(
          items: [],
          decoratorBuilder: FormeInputDecoratorBuilder(
              decoration: InputDecoration(labelText: 'Dropdown'),
              wrapper: (child) => DropdownButtonHideUnderline(
                    child: child,
                  ),
              emptyChecker: (value) => value == null),
          name: name,
          listener: FormeValueFieldListener(
            onValidate:
                FormeValidates.notNull(errorText: 'pls select one item!'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
        Wrap(
          children: [
            createButton('load items', () async {
              controller.updateModel(FormeDropdownButtonModel<String>(
                  icon: SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(),
              )));
              Future<List<DropdownMenuItem<String>>> future =
                  Future.delayed(Duration(seconds: 2), () {
                return FormeUtils.toDropdownMenuItems(
                    ['java', 'dart', 'c#', 'python', 'flutter']);
              });
              future.then((value) {
                controller.updateModel(FormeDropdownButtonModel<String>(
                    icon: Icon(Icons.arrow_drop_down), items: value));
              });
            }),
            createButton('update style', () {
              controller.updateModel(FormeDropdownButtonModel<String>(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
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
  String get title => 'FormeDropdown';
}
