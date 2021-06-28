import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:forme/forme.dart';

class FormeNumberField extends ValueField<num, FormeNumberFieldModel> {
  FormeNumberField({
    FormeValueChanged<num, FormeNumberFieldModel>? onValueChanged,
    FormFieldValidator<num>? validator,
    AutovalidateMode? autovalidateMode,
    num? initialValue,
    ValueChanged<num?>? onSubmitted,
    FormFieldSetter<num>? onSaved,
    required String name,
    bool readOnly = false,
    FormeNumberFieldModel? model,
    FormeErrorChanged<FormeValueFieldController<num, FormeNumberFieldModel>>?
        onErrorChanged,
    FormeFocusChanged<FormeValueFieldController<num, FormeNumberFieldModel>>?
        onFocusChanged,
    FormeFieldInitialed<FormeValueFieldController<num, FormeNumberFieldModel>>?
        onInitialed,
    Key? key,
    FormeDecoratorBuilder<num>? decoratorBuilder,
    InputDecoration? decoration,
    int? maxLines = 1,
    Duration? asyncValidatorDebounce,
    FormeFieldValidator<num>? asyncValidator,
  }) : super(
          asyncValidator: asyncValidator,
          asyncValidatorDebounce: asyncValidatorDebounce,
          onInitialed: onInitialed,
          decoratorBuilder: decoratorBuilder,
          onFocusChanged: onFocusChanged,
          onErrorChanged: onErrorChanged,
          key: key,
          model:
              (model ?? FormeNumberFieldModel()).copyWith(FormeNumberFieldModel(
            textFieldModel: FormeTextFieldModel(
              decoration: decoration,
              maxLines: maxLines,
            ),
          )),
          readOnly: readOnly,
          name: name,
          onSaved: onSaved,
          onValueChanged: onValueChanged,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            FocusNode focusNode = state.focusNode;
            int decimal = state.model.decimal ?? 0;
            bool allowNegative = state.model.allowNegative ?? false;
            double? max = state.model.max;
            TextEditingController textEditingController =
                (state as _NumberFieldState).textEditingController;

            String regex = r'[0-9' +
                (decimal > 0 ? '.' : '') +
                (allowNegative ? '-' : '') +
                ']';
            List<TextInputFormatter> formatters = [
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text == '') return newValue;
                if (allowNegative && newValue.text == '-') return newValue;
                double? parsed = double.tryParse(newValue.text);
                if (parsed == null) {
                  return oldValue;
                }
                int indexOfPoint = newValue.text.indexOf(".");
                if (indexOfPoint != -1) {
                  int decimalNum = newValue.text.length - (indexOfPoint + 1);
                  if (decimalNum > decimal) {
                    return oldValue;
                  }
                }

                if (max != null && parsed > max) {
                  return oldValue;
                }
                return newValue;
              }),
              FilteringTextInputFormatter.allow(RegExp(regex))
            ];

            if (state.model.textFieldModel?.inputFormatters != null) {
              formatters.addAll(state.model.textFieldModel!.inputFormatters!);
            }

            void onChanged(String value) {
              num? parsed = num.tryParse(value);
              if (parsed != null && parsed != state.value) {
                state.updateController = false;
                state.didChange(parsed);
              } else {
                if (value.isEmpty && state.value != null) {
                  state.didChange(null);
                }
              }
            }

            return FormeTextFieldWidget(
                textEditingController: textEditingController,
                focusNode: focusNode,
                errorText: state.errorText,
                model: FormeTextFieldModel(
                  inputFormatters: formatters,
                  readOnly: readOnly,
                  onTap: readOnly ? () {} : state.model.textFieldModel?.onTap,
                  onChanged: onChanged,
                  keyboardType: TextInputType.number,
                  onSubmitted: onSubmitted == null
                      ? null
                      : (v) => onSubmitted(state.value),
                ).copyWith(
                    state.model.textFieldModel ?? FormeTextFieldModel()));
          },
        );

  @override
  _NumberFieldState createState() => _NumberFieldState();
}

class _NumberFieldState extends ValueFieldState<num, FormeNumberFieldModel> {
  late final TextEditingController textEditingController;
  @override
  FormeNumberField get widget => super.widget as FormeNumberField;

  bool updateController = true;

  @override
  num? get value => super.value == null
      ? null
      : model.decimal == 0
          ? super.value!.toInt()
          : super.value!.toDouble();

  @override
  void afterInitiation() {
    super.afterInitiation();
    textEditingController = TextEditingController(
        text: initialValue == null ? '' : initialValue.toString());
  }

  @override
  void onValueChanged(num? value) {
    if (updateController) {
      String str = value == null ? '' : value.toString();
      if (textEditingController.text != str) {
        textEditingController.text = str;
      }
    } else {
      updateController = true;
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void clearValue() {
    textEditingController.text = '';
    setValue(null);
  }

  @override
  void afterUpdateModel(
      FormeNumberFieldModel old, FormeNumberFieldModel current) {
    if (value == null) return;
    if (current.max != null && current.max! < value!) clearValue();
    if (current.allowNegative != null && !current.allowNegative! && value! < 0)
      clearValue();
    int? decimal = current.decimal;
    if (decimal != null) {
      int indexOfPoint = value.toString().indexOf(".");
      if (indexOfPoint == -1) return;
      int decimalNum = value.toString().length - (indexOfPoint + 1);
      if (decimalNum > decimal) clearValue();
    }
  }
}

class FormeNumberFieldModel extends FormeModel {
  final int? decimal;
  final double? max;
  final bool? allowNegative;
  final FormeTextFieldModel? textFieldModel;

  FormeNumberFieldModel({
    this.decimal,
    this.max,
    this.allowNegative,
    this.textFieldModel,
  });

  FormeNumberFieldModel copyWith(FormeModel oldModel) {
    FormeNumberFieldModel old = oldModel as FormeNumberFieldModel;
    return FormeNumberFieldModel(
      decimal: decimal ?? old.decimal,
      max: max ?? old.max,
      allowNegative: allowNegative ?? old.allowNegative,
      textFieldModel:
          FormeTextFieldModel.copy(old.textFieldModel, textFieldModel),
    );
  }
}
