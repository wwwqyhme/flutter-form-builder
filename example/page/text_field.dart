import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';

class TextFieldPage extends BasePage<String, FormeTextFieldModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeTextField(
          initialValue: '123',
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onInitialed: (c) {
            print(c.value);
          },
          onFocusChanged: (c, m) => print('focused changed , current is $m'),
          onErrorChanged: (field, errorText) {
            print("validate result: ${errorText?.text}");
            controller.updateModel(FormeTextFieldModel(
                decoration: InputDecoration(
              labelStyle: TextStyle(
                fontSize: 30,
                color: errorText == null || !errorText.hasError
                    ? Colors.green
                    : Colors.red,
              ),
            )));
          },
          onValueChanged: (c, m) {
            print(
                'value changed , current value is $m , old value is ${c.oldValue}');
          },
          model: FormeTextFieldModel(autofocus: true),
          name: name,
          decoration: InputDecoration(
            labelText: 'TextField',
            suffixIcon: Builder(builder: (context) {
              return ValueListenableBuilder<FormeTextFieldModel>(
                  valueListenable: controller.modelListenable,
                  builder: (context, model, child) {
                    bool sec = model.obscureText ?? false;
                    return IconButton(
                        onPressed: () {
                          controller.updateModel(
                              FormeTextFieldModel(obscureText: !sec));
                        },
                        icon: Icon(
                            sec ? Icons.visibility : Icons.visibility_off));
                  });
            }),
          ),
          validator: FormeValidates.any([
            FormeValidates.size(min: 20),
            FormeValidates.email(),
          ], errorText: 'must be an email or length > 20'),
        ),
        Wrap(
          children: [
            createButton('set value', () {
              String text = 'admin@example.com';
              (controller as FormeTextFieldController).textEditingValue =
                  TextEditingValue(
                      text: text,
                      selection:
                          FormeUtils.selection(text.length, text.length));
            }),
            createButton('set selection', () {
              String text = controller.value!;
              (controller as FormeTextFieldController).selection =
                  FormeUtils.selection(0, text.length);
            }),
            createButton('update labelText', () {
              controller.updateModel(FormeTextFieldModel(
                decoration: InputDecoration(labelText: 'New Label Text'),
              ));
            }),
            createButton('update labelStyle', () {
              controller.updateModel(FormeTextFieldModel(
                decoration: InputDecoration(
                    labelStyle:
                        TextStyle(fontSize: 30, color: Colors.pinkAccent)),
              ));
            }),
            createButton('update style', () {
              controller.updateModel(FormeTextFieldModel(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              ));
            }),
            createButton('set helper text', () {
              controller.updateModel(FormeTextFieldModel(
                decoration: InputDecoration(helperText: 'helper text'),
              ));
            }),
            createButton('set prefix icon', () {
              controller.updateModel(FormeTextFieldModel(
                  decoration: InputDecoration(
                      prefixIcon: IconButton(
                          onPressed: () {}, icon: Icon(Icons.set_meal)))));
            }),
            createButton('set suffix icon', () {
              controller.updateModel(FormeTextFieldModel(
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            controller.value = '';
                          },
                          icon: Icon(Icons.clear)))));
            }),
            createButton('set maxLines to 1', () {
              controller.updateModel(FormeTextFieldModel(
                maxLines: 1,
              ));
            }),
            createButton('set maxLength to 10', () {
              controller.updateModel(FormeTextFieldModel(
                maxLength: 10,
              ));
            }),
            builderButton('validate', (context) {
              String? errorText = controller.validate(quietly: true);
              if (errorText != null) {
                showError(context, errorText);
              }
            }),
          ],
        )
      ],
    );
  }

  @override
  String get title => 'FormeTextField';
}
