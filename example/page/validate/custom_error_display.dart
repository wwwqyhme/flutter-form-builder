import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class CustomErrorDisplayPage<T, E extends FormeModel> extends StatelessWidget {
  final FormeKey formKey = FormeKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('custom error display'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Forme(
          quietlyValidate: true,
          //     autovalidateByOrder: true,
          child: Column(
            children: [
              CustomError(
                name: 'username',
              ),
              CustomError(
                name: 'password',
              ),
              CustomError(
                name: 'age',
              ),
              FormeTextField(
                name: 'username',
                listener: FormeValueFieldListener(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onAsyncValidate: (f, v) {
                    return Future.delayed(Duration(milliseconds: 800), () {
                      if (v.length < 10) return 'input at least 10 chars';
                    });
                  },
                ),
                decoration: InputDecoration(
                    labelText: 'username', hintText: 'input at least 10 chars'),
              ),
              FormeTextField(
                name: 'password',
                maxLines: 1,
                model: FormeTextFieldModel(obscureText: true),
                decoration: InputDecoration(labelText: 'password'),
                listener: FormeValueFieldListener(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onAsyncValidate: (f, v) {
                    return Future.delayed(Duration(milliseconds: 800), () {
                      if (v.length < 10) return 'input at least 10 chars';
                    });
                  },
                ),
              ),
              FormeSlider(
                name: 'age',
                min: 13,
                max: 100,
                decoration: InputDecoration(labelText: 'age'),
                listener: FormeValueFieldListener(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onAsyncValidate: (f, v) {
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

class CustomError extends StatelessWidget {
  final String name;

  const CustomError({Key? key, required this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<FormeFieldController?>(
        valueListenable: FormeKey.of(context).fieldListenable(name),
        builder: (context, value, child) {
          if (value == null) return SizedBox.shrink();
          FormeValueFieldController controller =
              value as FormeValueFieldController;
          return ValueListenableBuilder<FormeValidateError?>(
              valueListenable: controller.errorTextListenable,
              builder: (context, error, child) {
                if (error != null) {
                  if (error.invalid) {
                    return Text(
                      '${controller.name}: ${error.text}',
                      style: TextStyle(color: Colors.redAccent),
                    );
                  }
                  if (error.valid) {
                    return Text(
                      '${controller.name}: passed',
                      style: TextStyle(color: Colors.greenAccent),
                    );
                  }
                  if (error.validating) {
                    return Text(
                      '${controller.name}: validating',
                      style: TextStyle(color: Colors.orangeAccent),
                    );
                  }
                }
                return const SizedBox();
              });
        });
  }
}
