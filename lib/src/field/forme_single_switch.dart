import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class FormeSingleSwitch extends ValueField<bool, FormeSingleSwitchModel> {
  FormeSingleSwitch({
    FormeValueChanged<bool, FormeSingleSwitchModel>? onValueChanged,
    FormFieldValidator<bool>? validator,
    AutovalidateMode? autovalidateMode,
    bool initialValue = false,
    FormFieldSetter<bool>? onSaved,
    required String name,
    bool readOnly = false,
    Widget? label,
    FormeSingleSwitchModel? model,
    FormeErrorChanged<FormeValueFieldController<bool, FormeSingleSwitchModel>>?
        onErrorChanged,
    FormeFocusChanged<FormeValueFieldController<bool, FormeSingleSwitchModel>>?
        onFocusChanged,
    FormeFieldInitialed<
            FormeValueFieldController<bool, FormeSingleSwitchModel>>?
        onInitialed,
    Key? key,
  }) : super(
          onInitialed: onInitialed,
          nullValueReplacement: false,
          key: key,
          onFocusChanged: onFocusChanged,
          onErrorChanged: onErrorChanged,
          model: model ?? FormeSingleSwitchModel(),
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
            bool listTile = state.model.listTile ?? false;
            FormeSwitchRenderData? switchRenderData =
                state.model.switchRenderData;
            if (listTile) {
              return SwitchListTile(
                tileColor: switchRenderData?.tileColor,
                activeColor: switchRenderData?.activeColor,
                activeTrackColor: switchRenderData?.activeTrackColor,
                inactiveThumbColor: switchRenderData?.inactiveThumbColor,
                inactiveTrackColor: switchRenderData?.inactiveTrackColor,
                activeThumbImage: switchRenderData?.activeThumbImage,
                inactiveThumbImage: switchRenderData?.inactiveThumbImage,
                shape: switchRenderData?.shape,
                selectedTileColor: switchRenderData?.selectedTileColor,
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
              mainAxisSize: MainAxisSize.min,
              children: [
                state.model.title ?? SizedBox(),
                FormeRenderUtils.formeSwitch(
                  value,
                  readOnly
                      ? null
                      : (_) {
                          state.didChange(!value);
                          state.requestFocus();
                        },
                  state.model.switchRenderData,
                  focusNode: state.focusNode,
                )
              ],
            );
          },
        );
}

class FormeSingleSwitchModel extends FormeModel {
  final Widget? title;
  final Widget? secondary;
  final Widget? subtitle;
  final EdgeInsets? contentPadding;
  final bool? dense;
  final ListTileControlAffinity? controlAffinity;
  final bool? listTile;
  final FormeSwitchRenderData? switchRenderData;

  FormeSingleSwitchModel({
    this.title,
    this.secondary,
    this.subtitle,
    this.contentPadding,
    this.dense,
    this.controlAffinity,
    this.switchRenderData,
    this.listTile,
  });

  FormeSingleSwitchModel copyWith(FormeModel oldModel) {
    FormeSingleSwitchModel old = oldModel as FormeSingleSwitchModel;
    return FormeSingleSwitchModel(
      title: title ?? old.title,
      secondary: secondary ?? old.secondary,
      subtitle: subtitle ?? old.subtitle,
      contentPadding: contentPadding ?? old.contentPadding,
      dense: dense ?? old.dense,
      controlAffinity: controlAffinity ?? old.controlAffinity,
      listTile: listTile ?? old.listTile,
      switchRenderData:
          FormeSwitchRenderData.copy(old.switchRenderData, switchRenderData),
    );
  }
}
