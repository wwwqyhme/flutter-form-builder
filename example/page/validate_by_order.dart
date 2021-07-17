import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class ValidateByOrderPage<T, E extends FormeModel> extends StatelessWidget {
  final FormeKey formKey = FormeKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Validate By Order'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Forme(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autovalidateByOrder: true,
          child: Column(
            children: [
              FormeTextField(
                name: 'username',
                listener: FormeValueFieldListener(
                  onAsyncValidate: (f, v) {
                    return Future.delayed(Duration(milliseconds: 800), () {
                      if (v.length < 10) return 'input at least 10 chars';
                    });
                  },
                  onValidate: FormeValidates.size(
                      min: 5, errorText: 'input at least 5 chars'),
                  onErrorChanged: (f, e) {
                    f.updateModel(FormeTextFieldModel(
                        decoration: InputDecoration(
                            helperText: e != null && e.validating
                                ? 'async validating'
                                : '')));
                  },
                ),
                decoration: InputDecoration(
                    labelText: 'username', hintText: 'input at least 10 chars'),
              ),
              FormeTextField(
                order: 10,
                name: 'password',
                maxLines: 1,
                model: FormeTextFieldModel(obscureText: true),
                decoration: InputDecoration(labelText: 'password'),
                listener: FormeValueFieldListener(
                    onErrorChanged: (f, e) {
                      print(e?.text);
                    },
                    onValidate: FormeValidates.all([
                      FormeValidates.notEmpty(),
                      FormeValidates.size(min: 6),
                    ], errorText: 'input at least 6 chars')),
              ),
              FormeSlider(
                name: 'age',
                min: 13,
                max: 100,
                decoration: InputDecoration(labelText: 'age'),
                listener: FormeValueFieldListener(onErrorChanged: (f, e) {
                  f.decoratorController.update(FormeInputDecoratorModel(
                      decoration: InputDecoration(
                          helperText: e != null && e.validating
                              ? 'async validating'
                              : '')));
                }, onAsyncValidate: (f, v) {
                  return Future.delayed(Duration(milliseconds: 800), () {
                    if (v < 50) return 'age can not smaller than 50';
                  });
                }),
              ),
            ],
          ),
          key: formKey,
        ),
      ),
    );
  }
}
