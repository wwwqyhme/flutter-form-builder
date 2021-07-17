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
          listener: FormeValueFieldListener(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onInitialed: (c) {
              print(c.value);
            },
            onAsyncValidate: (f, v) =>
                Future.delayed(Duration(milliseconds: 800), () {
              if (v.length > 10) return null;
              return 'username is exists';
            }),
            onFocusChanged: (c, m) => print('focused changed , current is $m'),
            onErrorChanged: (field, errorText) {
              print(errorText);
            },
            onValueChanged: (c, m) {
              print(
                  'value changed , current value is $m , old value is ${c.oldValue}');
            },
            onValidate: FormeValidates.any([
              FormeValidates.size(min: 5),
              FormeValidates.email(),
            ], errorText: 'must be an email or length > 5'),
          ),
          model: FormeTextFieldModel(autofocus: true),
          name: name,
          decoration: InputDecoration(
            labelText: 'TextField',
            suffixIcon: Builder(builder: (context) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<FormeTextFieldModel>(
                      valueListenable: controller.modelListenable,
                      builder: (context, model, child) {
                        bool sec = model.obscureText ?? false;
                        return IconButton(
                            onPressed: () {
                              (controller as FormeTextFieldController)
                                  .textEditingController
                                  .text = 'xxx';
                              controller.updateModel(
                                  FormeTextFieldModel(obscureText: !sec));
                            },
                            icon: Icon(
                                sec ? Icons.visibility : Icons.visibility_off));
                      })
                ],
              );
            }),
          ),
        ),
        Builder(builder: (context) {
          return ValueListenableBuilder<FormeValidateError?>(
              valueListenable: controller.errorTextListenable,
              builder: (context, error, _child) {
                if (error != null) {
                  if (error.validating) return Text('async validating...');
                  if (error.fail)
                    return Text(
                      'an error occured',
                      style: TextStyle(color: Colors.red),
                    );
                }
                return const SizedBox();
              });
        }),
        Wrap(
          children: [
            createButton('reset', () {
              controller.reset();
            }),
            createButton('set value', () {
              String text = 'admin@example.com';
              (controller as FormeTextFieldController)
                      .textEditingController
                      .value =
                  TextEditingValue(
                      text: text,
                      selection:
                          FormeUtils.selection(text.length, text.length));
            }),
            createButton('set selection', () {
              String text = controller.value;
              (controller as FormeTextFieldController)
                  .textEditingController
                  .selection = FormeUtils.selection(0, text.length);
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
              controller.validate(quietly: false).then((value) {
                if (value.error?.invalid ?? false)
                  showError(context, value.error!.text!);
              });
            }),
          ],
        )
      ],
    );
  }

  @override
  String get title => 'FormeTextField';
}
