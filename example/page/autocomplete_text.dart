import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'async_autocomplete_text.dart';
import 'base_page.dart';

class AutocompleteText
    extends BasePage<User, FormeAutocompleteTextModel<User>> {
  static const List<User> _userOptions = <User>[
    User(name: 'Alice', email: 'alice@example.com'),
    User(name: 'Bob', email: 'bob@example.com'),
    User(name: 'Charlie', email: 'charlie123@gmail.com'),
  ];

  @override
  Widget get body {
    return Column(
      children: [
        FormeAutocompleteText<User>(
          optionsBuilder: (v) {
            if (v.text == '') {
              return Iterable.empty();
            }
            return _userOptions.where((User option) {
              return option.toString().contains(v.text.toLowerCase());
            });
          },
          decoration: InputDecoration(labelText: 'Autocomplete Text'),
          model: FormeAutocompleteTextModel<User>(
              textFieldModel: FormeTextFieldModel(maxLines: 1)),
          name: name,
          asyncValidator: (v) => Future.delayed(Duration(milliseconds: 800),
              () => 'this errorText is from async validator'),
          validator: (v) => v == null ? 'pls select one !' : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        Padding(
            padding: EdgeInsets.only(top: 250),
            child: Wrap(
              children: [
                createButton('update display', () {
                  controller.updateModel(FormeAutocompleteTextModel(
                      displayStringForOption: (u) => u.name));
                }),
                createButton('reset', () {
                  controller.reset();
                }),
                createButton('validate', () {
                  controller.validate();
                }),
                createButton('update optionsView height', () {
                  controller.updateModel(
                      FormeAutocompleteTextModel(optionsViewHeight: 300));
                }),
                createButton('update optionsView builder', () {
                  controller.updateModel(FormeAutocompleteTextModel(
                      optionsViewBuilder: (context, onSelected, users, width) {
                    return Text('123');
                  }));
                }),
                createButton('update options builder', () {
                  controller.updateModel(
                      FormeAutocompleteTextModel(optionsBuilder: (v) {
                    return <User>[
                      User(name: 'Alice1', email: 'alice@example.com'),
                      User(name: 'Bob2', email: 'bob@example.com'),
                      User(name: 'Charlie3', email: 'charlie123@gmail.com'),
                    ];
                  }));
                }),
              ],
            )),
      ],
    );
  }

  @override
  String get title => 'FormeAutocompleteText';
}
