import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

typedef Updater<T> = T Function(T t);

abstract class BasePage<T, E extends FormeModel> extends StatelessWidget {
  final String name = 'field';
  final FormeKey formKey = FormeKey();

  FormeValueFieldController<T, E> get controller => formKey.valueField(name);

  String get title;

  Widget get body;

  Widget createButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: TextButton(onPressed: onPressed, child: Text(text)),
    );
  }

  Widget builderButton(
      String text, void Function(BuildContext context) onPressed) {
    return Builder(builder: (context) {
      return Padding(
        padding: EdgeInsets.all(5),
        child: TextButton(
            onPressed: () {
              onPressed(context);
            },
            child: Text(text)),
      );
    });
  }

  void showError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Colors.red,
    ));
  }

  void updateLabel() {
    controller.decoratorController.update(FormeInputDecoratorModel(
        decoration: InputDecoration(labelText: 'New Label Text')));
  }

  void updateLabelStyle() {
    controller.decoratorController.update(FormeInputDecoratorModel(
        decoration: InputDecoration(
            labelStyle: TextStyle(fontSize: 30, color: Colors.pinkAccent))));
  }

  void updateHelperStyle() {
    controller.decoratorController.update(FormeInputDecoratorModel(
        decoration: InputDecoration(helperText: 'helper text')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Forme(
          child: Builder(
            builder: (context) {
              return body;
            },
          ),
          key: formKey,
        ),
      ),
    );
  }
}
