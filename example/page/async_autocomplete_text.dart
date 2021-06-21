import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';

class AsyncAutocompleteText
    extends BasePage<User, FormeAsyncAutocompleteTextModel<User>> {
  static const List<User> _userOptions = <User>[
    User(name: 'Alice', email: 'alice@example.com'),
    User(name: 'Bob', email: 'bob@example.com'),
    User(name: 'Charlie', email: 'charlie123@gmail.com'),
  ];

  @override
  Widget get body {
    return Column(
      children: [
        FormeAsnycAutocompleteText<User>(
          onFocusChanged: (c, f) => print(f),
          optionsBuilder: (v) {
            if (v.text == '') {
              return Future.delayed(Duration.zero, () {
                return Iterable.empty();
              });
            }
            return Future.delayed(Duration(milliseconds: 800), () {
              return _userOptions.where((User option) {
                return option.toString().contains(v.text.toLowerCase());
              });
            });
          },
          model: FormeAsyncAutocompleteTextModel<User>(
              queryWhenEmpty: true,
              emptyOptionBuilder: (context) {
                return Text('no options found');
              },
              textFieldModel: FormeTextFieldModel(
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: 'Async Autocomplete Text',
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.clearValue();
                      },
                      icon: Icon(Icons.clear),
                    )),
              )),
          name: name,
          validator: (v) => v == null ? 'pls select one !' : null,
        ),
        Padding(
          padding: EdgeInsets.only(top: 250),
          child: Wrap(
            children: [
              createButton('update display', () {
                controller.updateModel(FormeAsyncAutocompleteTextModel(
                    displayStringForOption: (u) => u.name));
              }),
              createButton('update optionsView height', () {
                controller.updateModel(
                    FormeAsyncAutocompleteTextModel(optionsViewHeight: 300));
              }),
              createButton('update optionsView builder', () {
                controller.updateModel(FormeAsyncAutocompleteTextModel(
                  loadingOptionBuilder: (context) => Text('loading...'),
                  emptyOptionBuilder: (contex) => Text('empty ...'),
                  optionsViewDecoratorBuilder:
                      (context, child, width, closeOptionsView) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: SizedBox(
                          child: child,
                          width: width,
                        ),
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, users) {
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: users.length,
                        itemBuilder: (BuildContext context, int index) {
                          final User option = users.elementAt(index);
                          return InkWell(
                            onTap: () {
                              onSelected(option);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: Text(
                                  option.name,
                                  style: TextStyle(fontSize: 30),
                                ),
                                subtitle: Text(option.email),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ));
              }),
              createButton('update options builder', () {
                controller.updateModel(
                    FormeAsyncAutocompleteTextModel(optionsBuilder: (v) {
                  if (v.text == '')
                    return Future.delayed(Duration.zero, () => []);
                  return Future.delayed(Duration(seconds: 1), () {
                    return <User>[
                      User(name: 'Alice1', email: 'alice1@example.com'),
                      User(name: 'Bob2', email: 'bob2@example.com'),
                      User(name: 'Charlie3', email: 'charlie3@gmail.com'),
                    ];
                  });
                }));
              }),
              createButton('reset', () {
                controller.reset();
              }),
              createButton('validate', () {
                controller.validate();
              }),
            ],
          ),
        )
      ],
    );
  }

  @override
  String get title => 'FormeAutocompleteText';
}

@immutable
class User {
  const User({
    required this.email,
    required this.name,
  });

  final String email;
  final String name;

  @override
  String toString() {
    return '$name, $email';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is User && other.name == name && other.email == email;
  }

  @override
  int get hashCode => hashValues(email, name);
}
