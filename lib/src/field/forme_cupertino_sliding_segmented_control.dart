import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class FormeCupertinoSlidingSegmentedControl<T extends Object>
    extends ValueField<T, FormeCupertinoSlidingSegmentedControlModel<T>> {
  FormeCupertinoSlidingSegmentedControl({
    required String name,
    required Map<T, Widget> chidren,
    FormeCupertinoSlidingSegmentedControlModel<T>? model,
    T? initialValue,
    AutovalidateMode? autovalidateMode,
    FormFieldValidator<T>? validator,
    FormeValueChanged<T, FormeCupertinoSlidingSegmentedControlModel<T>>?
        onValueChanged,
    FormFieldSetter<T>? onSaved,
    bool readOnly = false,
    FormeErrorChanged<
            FormeValueFieldController<T,
                FormeCupertinoSlidingSegmentedControlModel<T>>>?
        onErrorChanged,
    FormeFocusChanged<
            FormeValueFieldController<T,
                FormeCupertinoSlidingSegmentedControlModel<T>>>?
        onFocusChanged,
    FormeFieldInitialed<
            FormeValueFieldController<T,
                FormeCupertinoSlidingSegmentedControlModel<T>>>?
        onInitialed,
    Key? key,
    FormeDecoratorBuilder<T>? decoratorBuilder,
    InputDecoration? decoration,
  }) : super(
            onInitialed: onInitialed,
            name: name,
            initialValue: initialValue,
            autovalidateMode: autovalidateMode,
            onErrorChanged: onErrorChanged,
            validator: validator,
            onValueChanged: onValueChanged,
            onSaved: onSaved,
            readOnly: readOnly,
            onFocusChanged: onFocusChanged,
            key: key,
            decoratorBuilder: decoratorBuilder ??
                (decoration == null
                    ? null
                    : FormeInputDecoratorBuilder(
                        decoration: decoration,
                        wrapper: (child) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: child,
                        ),
                      )),
            model: (model ?? FormeCupertinoSlidingSegmentedControlModel<T>())
                .copyWith(FormeCupertinoSlidingSegmentedControlModel(
                    children: chidren)),
            builder: (state) {
              bool readOnly = state.readOnly;
              return Row(
                children: [
                  Expanded(
                      child: Focus(
                    focusNode: state.focusNode,
                    child: AbsorbPointer(
                      absorbing: readOnly,
                      child: CupertinoSlidingSegmentedControl<T>(
                          groupValue: state.value,
                          children: state.model.children!,
                          thumbColor: (readOnly
                                  ? state.model.disableThumbColor
                                  : state.model.thumbColor) ??
                              const CupertinoDynamicColor.withBrightness(
                                color: Color(0xFFFFFFFF),
                                darkColor: Color(0xFF636366),
                              ),
                          backgroundColor: (readOnly
                                  ? state.model.disableBackgroundColor
                                  : state.model.backgroundColor) ??
                              CupertinoColors.tertiarySystemFill,
                          padding: state.model.padding ??
                              const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 3),
                          onValueChanged: (v) {
                            state.didChange(v);
                            state.requestFocus();
                          }),
                    ),
                  ))
                ],
              );
            });

  @override
  _FormeCupertinoSegmentedControlState<T> createState() =>
      _FormeCupertinoSegmentedControlState();
}

class _FormeCupertinoSegmentedControlState<T extends Object>
    extends ValueFieldState<T, FormeCupertinoSlidingSegmentedControlModel<T>> {
  @override
  FormeCupertinoSlidingSegmentedControlModel<T> beforeUpdateModel(
      FormeCupertinoSlidingSegmentedControlModel<T> old,
      FormeCupertinoSlidingSegmentedControlModel<T> current) {
    if (current.children != null &&
        value != null &&
        !current.children!.containsKey(value)) {
      setValue(null);
    }
    return super.beforeUpdateModel(old, current);
  }

  @override
  FormeCupertinoSlidingSegmentedControlModel<T> beforeSetModel(
      FormeCupertinoSlidingSegmentedControlModel<T> old,
      FormeCupertinoSlidingSegmentedControlModel<T> current) {
    if (current.children == null || current.children!.length < 2) {
      current = current.copyWith(FormeCupertinoSlidingSegmentedControlModel<T>(
          children: old.children));
    }
    return beforeUpdateModel(old, current);
  }
}

class FormeCupertinoSlidingSegmentedControlModel<T> extends FormeModel {
  final Color? thumbColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final Map<T, Widget>? children;
  final Color? disableThumbColor;
  final Color? disableBackgroundColor;

  FormeCupertinoSlidingSegmentedControlModel({
    this.thumbColor,
    this.backgroundColor,
    this.disableThumbColor,
    this.disableBackgroundColor,
    this.padding,
    this.children,
  });

  @override
  FormeCupertinoSlidingSegmentedControlModel<T> copyWith(FormeModel oldModel) {
    FormeCupertinoSlidingSegmentedControlModel<T> old =
        oldModel as FormeCupertinoSlidingSegmentedControlModel<T>;
    return FormeCupertinoSlidingSegmentedControlModel<T>(
      thumbColor: thumbColor ?? old.thumbColor,
      backgroundColor: backgroundColor ?? old.backgroundColor,
      disableThumbColor: disableThumbColor ?? old.disableThumbColor,
      disableBackgroundColor:
          disableBackgroundColor ?? old.disableBackgroundColor,
      padding: padding ?? old.padding,
      children: children ?? old.children,
    );
  }
}
