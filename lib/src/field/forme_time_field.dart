import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

typedef FormeTimeFieldFormatter = String Function(TimeOfDay timeOfDay);

/// used to pick time only
class FormeTimeField extends ValueField<TimeOfDay, FormeTimeFieldModel> {
  FormeTimeField({
    FormeValueChanged<TimeOfDay, FormeTimeFieldModel>? onValueChanged,
    FormFieldValidator<TimeOfDay>? validator,
    AutovalidateMode? autovalidateMode,
    TimeOfDay? initialValue,
    FormFieldSetter<TimeOfDay>? onSaved,
    required String name,
    bool readOnly = false,
    FormeTimeFieldModel? model,
    FormeErrorChanged<
            FormeValueFieldController<TimeOfDay, FormeTimeFieldModel>>?
        onErrorChanged,
    FormeFocusChanged<
            FormeValueFieldController<TimeOfDay, FormeTimeFieldModel>>?
        onFocusChanged,
    FormeFieldInitialed<
            FormeValueFieldController<TimeOfDay, FormeTimeFieldModel>>?
        onInitialed,
    Key? key,
    FormeDecoratorBuilder<TimeOfDay>? decoratorBuilder,
    InputDecoration? decoration,
    int? maxLines = 1,
  }) : super(
          onInitialed: onInitialed,
          key: key,
          decoratorBuilder: decoratorBuilder,
          onFocusChanged: onFocusChanged,
          onErrorChanged: onErrorChanged,
          model: model ??
              FormeTimeFieldModel(
                textFieldModel: FormeTextFieldModel(
                  decoration: decoration,
                  maxLines: maxLines,
                ),
              ),
          name: name,
          onValueChanged: onValueChanged,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            FocusNode focusNode = state.focusNode;
            TextEditingController textEditingController =
                (state as _FormeTimeFieldState).textEditingController;

            void pickTime() {
              showTimePicker(
                context: state.context,
                initialTime: state.value ?? TimeOfDay.now(),
                builder: state.model.builder,
                routeSettings: state.model.routeSettings,
                initialEntryMode:
                    state.model.initialEntryMode ?? TimePickerEntryMode.dial,
                cancelText: state.model.cancelText,
                confirmText: state.model.confirmText,
                helpText: state.model.helpText,
              ).then((value) {
                if (value != null) state.didChange(value);
                state.requestFocus();
              });
            }

            return FormeTextFieldWidget(
                textEditingController: textEditingController,
                focusNode: focusNode,
                errorText: state.errorText,
                model: FormeTextFieldModel(
                  inputFormatters: [],
                  onTap: readOnly ? () {} : pickTime,
                  readOnly: true,
                ).copyWith(
                    state.model.textFieldModel ?? FormeTextFieldModel()));
          },
        );

  @override
  _FormeTimeFieldState createState() => _FormeTimeFieldState();

  static FormeTimeFieldFormatter defaultFormeTimeFieldFormatter = (v) =>
      '${v.hour.toString().padLeft(2, '0')}:${v.minute.toString().padLeft(2, '0')}';
}

class _FormeTimeFieldState
    extends ValueFieldState<TimeOfDay, FormeTimeFieldModel> {
  FormeTimeFieldFormatter get _formatter =>
      model.formatter ?? FormeTimeField.defaultFormeTimeFieldFormatter;

  late final TextEditingController textEditingController;

  @override
  FormeTimeField get widget => super.widget as FormeTimeField;

  @override
  void afterInitiation() {
    super.afterInitiation();
    textEditingController = TextEditingController(
        text: initialValue == null ? '' : _formatter(initialValue!));
  }

  @override
  void onValueChanged(TimeOfDay? value) {
    textEditingController.text = value == null ? '' : _formatter(value);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void clearValue() {
    setValue(null);
    textEditingController.text = '';
  }

  @override
  void afterUpdateModel(FormeTimeFieldModel old, FormeTimeFieldModel current) {
    if (current.formatter != null && value != null) {
      textEditingController.text =
          value == null ? '' : current.formatter!(value!);
    }
  }
}

class FormeTimeFieldModel extends FormeModel {
  final FormeTimeFieldFormatter? formatter;
  final TimePickerEntryMode? initialEntryMode;
  final String? cancelText;
  final String? confirmText;
  final String? helpText;
  final RouteSettings? routeSettings;
  final TransitionBuilder? builder;
  final FormeTextFieldModel? textFieldModel;

  FormeTimeFieldModel({
    this.formatter,
    this.initialEntryMode,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.routeSettings,
    this.builder,
    this.textFieldModel,
  });
  @override
  FormeTimeFieldModel copyWith(FormeModel oldModel) {
    FormeTimeFieldModel old = oldModel as FormeTimeFieldModel;

    return FormeTimeFieldModel(
      formatter: formatter ?? old.formatter,
      initialEntryMode: initialEntryMode ?? old.initialEntryMode,
      cancelText: cancelText ?? old.cancelText,
      confirmText: confirmText ?? old.confirmText,
      helpText: helpText ?? old.helpText,
      routeSettings: routeSettings ?? old.routeSettings,
      builder: builder ?? old.builder,
      textFieldModel:
          FormeTextFieldModel.copy(old.textFieldModel, textFieldModel),
    );
  }
}
