import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class FormeSingleCheckbox extends ValueField<bool, FormeSingleCheckboxModel> {
  FormeSingleCheckbox({
    FormeValueChanged<bool, FormeSingleCheckboxModel>? onValueChanged,
    FormFieldValidator<bool>? validator,
    AutovalidateMode? autovalidateMode,
    bool initialValue = false,
    FormFieldSetter<bool>? onSaved,
    required String name,
    bool readOnly = false,
    FormeSingleCheckboxModel? model,
    FormeErrorChanged<
            FormeValueFieldController<bool, FormeSingleCheckboxModel>>?
        onErrorChanged,
    FormeFocusChanged<
            FormeValueFieldController<bool, FormeSingleCheckboxModel>>?
        onFocusChanged,
    FormeFieldInitialed<
            FormeValueFieldController<bool, FormeSingleCheckboxModel>>?
        onInitialed,
    Key? key,
    Duration? asyncValidatorDebounce,
    FormeFieldValidator<bool>? asyncValidator,
  }) : super(
          asyncValidator: asyncValidator,
          asyncValidatorDebounce: asyncValidatorDebounce,
          onInitialed: onInitialed,
          nullValueReplacement: false,
          onFocusChanged: onFocusChanged,
          onErrorChanged: onErrorChanged,
          key: key,
          model: model ?? FormeSingleCheckboxModel(),
          readOnly: readOnly,
          name: name,
          onValueChanged: onValueChanged,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue,
          validator: validator,
          builder: (state) {
            bool readOnly = state.readOnly;
            bool value = state.value!;
            FormeCheckboxRenderData? checkboxRenderData =
                state.model.checkboxRenderData;

            bool listTile = state.model.listTile ?? false;

            if (listTile) {
              return CheckboxListTile(
                shape: checkboxRenderData?.shape,
                tileColor: checkboxRenderData?.tileColor,
                selectedTileColor: checkboxRenderData?.selectedTileColor,
                activeColor: checkboxRenderData?.activeColor,
                checkColor: checkboxRenderData?.checkColor,
                secondary: state.model.secondary,
                subtitle: state.model.subtitle,
                controlAffinity: state.model.controlAffinity ??
                    ListTileControlAffinity.platform,
                contentPadding: state.model.contentPadding,
                dense: state.model.dense,
                title: state.model.title,
                value: state.value!,
                onChanged: readOnly
                    ? null
                    : (_) {
                        state.didChange(!value);
                        state.requestFocus();
                      },
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                state.model.title ?? SizedBox(),
                FormeRenderUtils.checkbox(
                    value,
                    readOnly
                        ? null
                        : (_) {
                            state.didChange(!value);
                            state.requestFocus();
                          },
                    checkboxRenderData,
                    focusNode: state.focusNode)
              ],
            );
          },
        );
}

class FormeSingleCheckboxModel extends FormeModel {
  final Widget? title;
  final Widget? secondary;
  final Widget? subtitle;
  final EdgeInsets? contentPadding;
  final bool? dense;
  final ListTileControlAffinity? controlAffinity;
  final FormeCheckboxRenderData? checkboxRenderData;
  final bool? listTile;

  FormeSingleCheckboxModel({
    this.title,
    this.secondary,
    this.subtitle,
    this.contentPadding,
    this.dense,
    this.controlAffinity,
    this.checkboxRenderData,
    this.listTile,
  });
  FormeSingleCheckboxModel copyWith(FormeModel oldModel) {
    FormeSingleCheckboxModel old = oldModel as FormeSingleCheckboxModel;
    return FormeSingleCheckboxModel(
      title: title ?? old.title,
      secondary: secondary ?? old.secondary,
      subtitle: subtitle ?? old.subtitle,
      contentPadding: contentPadding ?? old.contentPadding,
      dense: dense ?? old.dense,
      controlAffinity: controlAffinity ?? old.controlAffinity,
      listTile: listTile ?? old.listTile,
      checkboxRenderData: FormeCheckboxRenderData.copy(
          old.checkboxRenderData, checkboxRenderData),
    );
  }
}
