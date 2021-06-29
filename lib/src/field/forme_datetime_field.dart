import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:forme/forme.dart';

enum FormeDateTimeFieldType { Date, DateTime }

///used to pick datetime and date
class FormeDateTimeField
    extends ValueField<DateTime?, FormeDateTimeFieldModel> {
  FormeDateTimeField({
    FormeValueChanged<DateTime?, FormeDateTimeFieldModel>? onValueChanged,
    FormFieldValidator<DateTime?>? validator,
    AutovalidateMode? autovalidateMode,
    DateTime? initialValue,
    FormeFieldSetter<DateTime?>? onSaved,
    required String name,
    bool readOnly = false,
    FormeDateTimeFieldModel? model,
    FormeErrorChanged<DateTime?, FormeDateTimeFieldModel>? onErrorChanged,
    FormeValueFieldFocusChanged<DateTime?, FormeDateTimeFieldModel>?
        onFocusChanged,
    FormeValueFieldInitialed<DateTime?, FormeDateTimeFieldModel>? onInitialed,
    Key? key,
    FormeDecoratorBuilder<DateTime?>? decoratorBuilder,
    InputDecoration? decoration,
    int? maxLines = 1,
    FormeAsyncValidateConfiguration? asyncValidateConfiguration,
    FormeAsyncValidator<DateTime?>? asyncValidator,
  }) : super(
          asyncValidator: asyncValidator,
          asyncValidateConfiguration: asyncValidateConfiguration,
          onInitialed: onInitialed,
          decoratorBuilder: decoratorBuilder,
          key: key,
          onFocusChanged: onFocusChanged,
          onErrorChanged: onErrorChanged,
          model: (model ?? FormeDateTimeFieldModel())
              .copyWith(FormeDateTimeFieldModel(
            type: FormeDateTimeFieldType.Date,
            textFieldModel: FormeTextFieldModel(
              maxLines: maxLines,
              decoration: decoration,
            ),
          )),
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
                (state as _FormeDateTimeFieldState).textEditingController;
            DateTime firstDate = state.model.firstDate ?? DateTime(1970);
            DateTime lastDate = state.model.lastDate ?? DateTime(2099);

            void pickTime() {
              DateTime value = state.initialDateTime;
              TimeOfDay? timeOfDay = state.value == null
                  ? null
                  : TimeOfDay(hour: value.hour, minute: value.minute);

              showDatePicker(
                context: state.context,
                initialDate: value,
                firstDate: firstDate,
                lastDate: lastDate,
                helpText: state.model.helpText,
                cancelText: state.model.cancelText,
                confirmText: state.model.confirmText,
                routeSettings: state.model.routeSettings,
                textDirection: state.model.textFieldModel?.textDirection,
                initialDatePickerMode:
                    state.model.initialDatePickerMode ?? DatePickerMode.day,
                errorFormatText: state.model.errorFormatText,
                errorInvalidText: state.model.errorInvalidText,
                fieldHintText: state.model.fieldHintText,
                fieldLabelText: state.model.fieldLabelText,
                initialEntryMode: state.model.dateInitialEntryMode ??
                    DatePickerEntryMode.calendar,
                selectableDayPredicate: state.model.selectableDayPredicate,
              ).then((date) {
                if (date != null) {
                  if (state.model.type! == FormeDateTimeFieldType.DateTime)
                    showTimePicker(
                        initialEntryMode: state.model.initialEntryMode ??
                            TimePickerEntryMode.dial,
                        cancelText: state.model.timeCancelText,
                        confirmText: state.model.timeConfirmText,
                        helpText: state.model.timeHelpText,
                        routeSettings: state.model.timeRouteSettings,
                        context: state.context,
                        initialTime: timeOfDay ??
                            TimeOfDay(hour: value.hour, minute: value.minute),
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                                alwaysUse24HourFormat:
                                    state.model.use24hFormat ?? false),
                            child: child!,
                          );
                        }).then((value) {
                      if (value != null) {
                        DateTime dateTime = DateTime(date.year, date.month,
                            date.day, value.hour, value.minute);
                        state.didChange(dateTime);
                      }
                    });
                  else {
                    state.didChange(date);
                  }
                }
                state.requestFocus();
              });
            }

            return FormeTextFieldWidget(
                textEditingController: textEditingController,
                focusNode: focusNode,
                errorText: state.errorText,
                model: FormeTextFieldModel(
                  inputFormatters: [],
                  onTap: readOnly ? null : pickTime,
                  readOnly: true,
                ).copyWith(
                    state.model.textFieldModel ?? FormeTextFieldModel()));
          },
        );

  @override
  _FormeDateTimeFieldState createState() => _FormeDateTimeFieldState();

  static FormeDateTimeFormatter defaultDateTimeFormatter =
      (FormeDateTimeFieldType type, DateTime dateTime) {
    switch (type) {
      case FormeDateTimeFieldType.Date:
        return '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
      case FormeDateTimeFieldType.DateTime:
        return '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  };
}

typedef FormeDateTimeFormatter = String Function(
    FormeDateTimeFieldType type, DateTime dateTime);

class _FormeDateTimeFieldState
    extends ValueFieldState<DateTime?, FormeDateTimeFieldModel> {
  FormeDateTimeFormatter get _formatter =>
      model.formatter ?? FormeDateTimeField.defaultDateTimeFormatter;

  late final TextEditingController textEditingController;

  @override
  FormeDateTimeField get widget => super.widget as FormeDateTimeField;

  @override
  void afterInitiation() {
    super.afterInitiation();
    textEditingController = TextEditingController(
        text: value == null ? '' : _formatter(model.type!, value!));
  }

  @override
  void onValueChanged(DateTime? value) {
    textEditingController.text =
        value == null ? '' : _formatter(model.type!, value);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void clearValue() {
    textEditingController.text = '';
    didChange(null);
  }

  void _clearValue() {
    setValue(null);
    textEditingController.text = '';
  }

  @override
  FormeDateTimeFieldModel beforeSetModel(
      FormeDateTimeFieldModel old, FormeDateTimeFieldModel current) {
    if (current.type == null)
      current = current
          .copyWith(FormeDateTimeFieldModel(type: FormeDateTimeFieldType.Date));
    return current;
  }

  @override
  void afterUpdateModel(
      FormeDateTimeFieldModel old, FormeDateTimeFieldModel current) {
    if (value == null) return;
    if (current.firstDate != null && current.firstDate!.isAfter(value!))
      _clearValue();
    if (value != null &&
        current.lastDate != null &&
        current.lastDate!.isBefore(value!)) _clearValue();
    if (value != null &&
        (current.formatter != null ||
            (current.type != null && current.type != old.type)))
      textEditingController.text =
          (current.formatter ?? FormeDateTimeField.defaultDateTimeFormatter)(
              (current.type ?? old.type!), value!);
    if (value != null &&
        current.type != null &&
        current.type != old.type &&
        current.type == FormeDateTimeFieldType.Date) {
      setValue(DateTime(value!.year, value!.month, value!.day));
      textEditingController.text =
          (current.formatter ?? FormeDateTimeField.defaultDateTimeFormatter)(
              FormeDateTimeFieldType.Date, value!);
    }
  }

  @override
  DateTime? get value {
    DateTime? value = super.value;
    if (value == null) return null;
    return simple(value);
  }

  DateTime get initialDateTime {
    if (value != null) return value!;
    DateTime now = DateTime.now();
    DateTime date =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);
    if (model.lastDate != null && model.lastDate!.isBefore(date))
      date = model.lastDate!;
    if (model.firstDate != null && model.firstDate!.isAfter(date))
      date = model.firstDate!;
    switch (model.type!) {
      case FormeDateTimeFieldType.Date:
        return DateTime(date.year, date.month, date.day);
      case FormeDateTimeFieldType.DateTime:
        return date;
    }
  }

  DateTime simple(DateTime time) {
    switch (model.type ?? FormeDateTimeFieldType.Date) {
      case FormeDateTimeFieldType.Date:
        return DateTime(time.year, time.month, time.day);
      case FormeDateTimeFieldType.DateTime:
        return DateTime(
            time.year, time.month, time.day, time.hour, time.minute);
    }
  }
}

class FormeDateTimeFieldModel extends FormeModel {
  final FormeDateTimeFieldType? type;
  final FormeDateTimeFormatter? formatter;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? helpText;
  final String? cancelText;
  final String? confirmText;
  final RouteSettings? routeSettings;
  final TextDirection? pickerTextDirection;
  final DatePickerMode? initialDatePickerMode;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldHintText;
  final String? fieldLabelText;
  final TimePickerEntryMode? initialEntryMode;
  final DatePickerEntryMode? dateInitialEntryMode;
  final String? timeCancelText;
  final String? timeConfirmText;
  final String? timeHelpText;
  final RouteSettings? timeRouteSettings;
  final SelectableDayPredicate? selectableDayPredicate;
  final TransitionBuilder? builder;
  final FormeTextFieldModel? textFieldModel;
  final bool? use24hFormat;

  FormeDateTimeFieldModel({
    this.type,
    this.formatter,
    this.firstDate,
    this.lastDate,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.routeSettings,
    this.pickerTextDirection,
    this.initialDatePickerMode,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.initialEntryMode,
    this.timeCancelText,
    this.timeConfirmText,
    this.timeHelpText,
    this.timeRouteSettings,
    this.selectableDayPredicate,
    this.builder,
    this.dateInitialEntryMode,
    this.textFieldModel,
    this.use24hFormat,
  });

  @override
  FormeDateTimeFieldModel copyWith(FormeModel oldModel) {
    FormeDateTimeFieldModel old = oldModel as FormeDateTimeFieldModel;
    return FormeDateTimeFieldModel(
      type: type ?? old.type,
      formatter: formatter ?? old.formatter,
      firstDate: firstDate ?? old.firstDate,
      lastDate: lastDate ?? old.lastDate,
      helpText: helpText ?? old.helpText,
      cancelText: cancelText ?? old.cancelText,
      confirmText: confirmText ?? old.confirmText,
      routeSettings: routeSettings ?? old.routeSettings,
      pickerTextDirection: pickerTextDirection ?? old.pickerTextDirection,
      initialDatePickerMode: initialDatePickerMode ?? old.initialDatePickerMode,
      errorFormatText: errorFormatText ?? old.errorFormatText,
      errorInvalidText: errorInvalidText ?? old.errorInvalidText,
      fieldHintText: fieldHintText ?? old.fieldHintText,
      fieldLabelText: fieldLabelText ?? old.fieldLabelText,
      initialEntryMode: initialEntryMode ?? old.initialEntryMode,
      dateInitialEntryMode: dateInitialEntryMode ?? old.dateInitialEntryMode,
      timeCancelText: timeCancelText ?? old.timeCancelText,
      timeConfirmText: timeConfirmText ?? old.timeConfirmText,
      timeHelpText: timeHelpText ?? old.timeHelpText,
      timeRouteSettings: timeRouteSettings ?? old.timeRouteSettings,
      selectableDayPredicate:
          selectableDayPredicate ?? old.selectableDayPredicate,
      builder: builder ?? old.builder,
      use24hFormat: use24hFormat ?? old.use24hFormat,
      textFieldModel:
          FormeTextFieldModel.copy(old.textFieldModel, textFieldModel),
    );
  }
}
